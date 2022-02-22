class Notification {
  String key;
  int state;
  int severity;
  String uid;
  int epoch;
  String? site;
  String? dismissedTS;
  String? userId;
  String? desc;
  String? title;
  String? descText;
  int id;

  Notification(
      {required this.key,
      required this.state,
      required this.severity,
      required this.uid,
      required this.epoch,
      required this.site,
      required this.dismissedTS,
      required this.userId,
      required this.desc,
      required this.title,
      required this.descText,
      required this.id});

  markAsRead() {
    this.state = 1;
  }

  factory Notification.fromJson(Map<String, dynamic> json) {
    return Notification(
        key: json["key"],
        state: json['state'],
        severity: json['severity'],
        uid: json["UID"],
        epoch: json["epoch"],
        site: json["site"],
        dismissedTS: json['dismissedTS'],
        userId: json["userId"],
        desc: json['desc'],
        title: json['title'],
        descText: json['descText'],
        id: json['id']);
  }
}
