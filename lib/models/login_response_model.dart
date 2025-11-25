import 'user_model.dart';
import 'subscription_model.dart';

class LoginResponse {
  final String message;
  final User user;
  final Subscription subscription;
  final String token;

  LoginResponse({
    required this.message,
    required this.user,
    required this.subscription,
    required this.token,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;
    return LoginResponse(
      message: json['message'] as String,
      user: User.fromJson(data['user'] as Map<String, dynamic>),
      subscription: Subscription.fromJson(data['subscription'] as Map<String, dynamic>),
      token: data['token'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'data': {
        'user': user.toJson(),
        'subscription': subscription.toJson(),
        'token': token,
      },
    };
  }
}
