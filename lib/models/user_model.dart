import '../constants.dart';

class AppUser {
  final String id;
  final String name;
  final String email;
  final UserType userType;

  AppUser({
    required this.id,
    required this.name,
    required this.email,
    required this.userType,
  });

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      userType: UserType.values.firstWhere(
        (e) => e.toString() == 'UserType.${json['userType']}',
        orElse: () => UserType.customer,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'userType': userType.toString().split('.').last,
    };
  }
}
