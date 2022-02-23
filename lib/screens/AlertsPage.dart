import 'package:flutter/material.dart';
import 'package:pycnomobile/builders/AlertsBuilder.dart';
import 'package:pycnomobile/controllers/NotificationsController.dart';
import 'package:pycnomobile/theme/GlobalTheme.dart';
import 'package:pycnomobile/widgets/AlertListTile.dart';
import 'package:get/get.dart';

class AlertsPage extends StatefulWidget {
  const AlertsPage({Key? key}) : super(key: key);

  @override
  State<AlertsPage> createState() => _AlertsPageState();
}

class _AlertsPageState extends State<AlertsPage> {
  List<Widget> unreadNotifications = buildAlerts(isRead: false);
  List<Widget> readNotifications = buildAlerts(isRead: true);
  final NotificationsController notificationsController =
      Get.put(NotificationsController());

  Future _refreshData() async {
    await notificationsController.getNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor:
                globalTheme.colorScheme.background.withOpacity(0.95),
            bottom: PreferredSize(
              preferredSize: new Size(double.infinity,
                  MediaQuery.of(context).size.height * 0.9 / 100),
              child: Container(
                height: MediaQuery.of(context).size.height * 5 / 100,
                child: TabBar(
                    labelColor: globalTheme.colorScheme.secondary,
                    unselectedLabelColor: globalTheme.primaryColor,
                    indicatorSize: TabBarIndicatorSize.label,
                    indicator: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10)),
                        color: globalTheme.colorScheme.surface),
                    tabs: [
                      Tab(
                        child: SizedBox(
                          child: Align(
                            alignment: Alignment.center,
                            child: Text("Unread"),
                          ),
                        ),
                      ),
                      Tab(
                        child: Align(
                          alignment: Alignment.center,
                          child: Text("Read"),
                        ),
                      ),
                    ]),
              ),
            ),
          ),
          body: Padding(
            padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.5 / 100),
            child: TabBarView(children: [
              RefreshIndicator(
                  onRefresh: _refreshData,
                  child: Obx(
                      () => ListView(children: buildAlerts(isRead: false)))),
              RefreshIndicator(
                onRefresh: _refreshData,
                child: Obx(() => ListView.builder(
                    itemCount: notificationsController.readNotifications.length,
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return AlertListTile(
                          notification:
                              notificationsController.readNotifications[index]);
                    })),
              ),
            ]),
          ),
        ));
  }
}
