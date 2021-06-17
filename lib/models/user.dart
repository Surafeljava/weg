class User {
  final String name;
  final String ip;

  User({required this.name, required this.ip});

  factory User.fromJson(dynamic json) {
    return User(
      name: json['name'],
      ip: json['ip'],
    );
  }

  Map<String, dynamic> toJson() => {
        "name": name,
        "ip": ip,
      };
}
