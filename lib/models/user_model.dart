class User {
  final int id;
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String email;
  final String jollyEmail;
  final String country;
  final List<String> personalizations;
  final String createdAt;
  final String updatedAt;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.email,
    required this.jollyEmail,
    required this.country,
    required this.personalizations,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      phoneNumber: json['phone_number'] as String,
      email: json['email'] as String,
      jollyEmail: json['jolly_email'] as String,
      country: json['country'] as String,
      personalizations: (json['personalizations'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'phone_number': phoneNumber,
      'email': email,
      'jolly_email': jollyEmail,
      'country': country,
      'personalizations': personalizations,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
