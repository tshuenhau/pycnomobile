import 'package:flutter/material.dart';
import 'package:Sensr/builders/AlertsBuilder.dart';
import 'package:Sensr/controllers/NotificationsController.dart';
import 'package:Sensr/widgets/AlertListTile.dart';
import 'package:get/get.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';

class AlertsPage extends StatefulWidget {
  const AlertsPage({Key? key}) : super(key: key);

  @override
  State<AlertsPage> createState() => _AlertsPageState();
}

class _AlertsPageState extends State<AlertsPage> {
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
            iconTheme: IconThemeData(
              color: Theme.of(context)
                  .colorScheme
                  .primary, //change your color here
            ),
            elevation: 0,
            backgroundColor:
                Theme.of(context).colorScheme.background.withOpacity(0.95),
            bottom: PreferredSize(
              preferredSize: new Size(double.infinity,
                  MediaQuery.of(context).size.height * 0.9 / 100),
              child: Container(
                height: MediaQuery.of(context).size.height * 5 / 100,
                child: TabBar(
                    labelColor: Theme.of(context).colorScheme.tertiary,
                    unselectedLabelColor: Theme.of(context).primaryColor,
                    indicatorSize: TabBarIndicatorSize.label,
                    indicator: DotIndicator(
                      color: Theme.of(context).colorScheme.tertiary,
                      distanceFromCenter: -16,
                      radius: 3,
                      paintingStyle: PaintingStyle.fill,
                    ),
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
            child:
                TabBarView(physics: NeverScrollableScrollPhysics(), children: [
              RefreshIndicator(
                onRefresh: _refreshData,
                child: Obx(() => notificationsController
                            .unreadNotifications.length ==
                        0
                    ? ListView(
                        children: [
                          Container(
                              height:
                                  MediaQuery.of(context).size.height * 70 / 100,
                              child:
                                  Center(child: Text("No New Notifications")))
                        ],
                      )
                    : ListView.builder(
                        itemCount: notificationsController
                                    .unreadNotifications.length ==
                                0
                            ? 1
                            : notificationsController
                                .unreadNotifications.length,
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return AlertListTile(
                              notification: notificationsController
                                  .unreadNotifications[index]);
                        })),
              ),
              RefreshIndicator(
                onRefresh: _refreshData,
                child: Obx(() => notificationsController
                            .readNotifications.length ==
                        0
                    ? ListView(
                        children: [
                          Container(
                              height:
                                  MediaQuery.of(context).size.height * 70 / 100,
                              child: Center(
                                  child:
                                      Text("No Recently Read Notifications")))
                        ],
                      )
                    : ListView.builder(
                        itemCount:
                            notificationsController.readNotifications.length,
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return AlertListTile(
                              notification: notificationsController
                                  .readNotifications[index]);
                        })),
              ),
            ]),
          ),
        ));
  }
}
