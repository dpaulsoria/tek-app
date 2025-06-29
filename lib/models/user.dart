class User {
  final String username;
  final String name;
  final String password;
  final String email;
  final String token;
  User({
    required this.username,
    required this.name,
    required this.password,
    required this.email,
    required this.token
  });
  /// Crea un User a partir de un JSON
  factory User.fromJson(Map<String, dynamic> json) => User(
    username: json['username'] as String,
    name:     json['name']     as String,
    password: json['password'] as String,
    email:    json['email']    as String,
    token:    json['token']    as String,
  );

  /// Convierte este User a JSON
  Map<String, dynamic> toJson() => {
    'username': username,
    'name':     name,
    'password': password,
    'email':    email,
    'token':    token,
  };
}
