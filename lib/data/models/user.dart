class User {
  final String username;
  final String password;
  User({
    required this.username,
    required this.password,
  });

  static List<User> listUser() {
    return [
      User(username: "it_helpdesk1", password: "123456a@"),
      User(username: "it_helpdesk2", password: "123456a@"),
      User(username: "it_helpdesk3", password: "123456a@"),
    ];
  }
}
