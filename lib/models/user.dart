class User {
  final int id;
  final String username;
  final String? firstName;
  final String? lastName;
  final String email;
  final String token;

  /// Campos opcionales de cliente
  final String? document;
  final String? phone;
  final String? address;

  User({
    required this.id,
    required this.username,
    this.firstName,
    this.lastName,
    required this.email,
    required this.token,
    this.document,
    this.phone,
    this.address,
  });

  /// Para el login (viene token)
  factory User.fromJson(Map<String, dynamic> json) => User(
    id:        json['user']['id']    as int,
    username:  json['user']['name'],     // o cambia según tu JSON
    firstName: null,
    lastName:  null,
    email:     json['user']['email'] as String,
    token:     json['token']          as String,
  );

  /// Para mapear clientes
  factory User.fromClientJson(Map<String, dynamic> json) => User(
    id:        json['id']          as int,
    username:  '',                    // no aplica aquí
    firstName: json['first_name']    as String,
    lastName:  json['last_name']     as String,
    email:     json['email']         as String,
    token:     '',                    // no aplica aquí
    document:  json['document']      as String?,
    phone:     json['phone']         as String?,
    address:   json['address']       as String?,
  );
}
