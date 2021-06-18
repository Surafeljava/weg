class Message {
  final String message;
  final String time;
  final String from;

  Message({required this.message, required this.time, required this.from});

  factory Message.fromJson(dynamic json) {
    return Message(
        message: json["message"], time: json["time"], from: json["from"]);
  }

  Map<String, dynamic> toJson() => {
        "message": message,
        "time": time,
        "from": from,
      };
}
