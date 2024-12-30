// models/user.dart
class User {
  final String id; // User ID
  final String name; // Display name (optional)
  final String email; // Email address
  final String username; // Derived from email

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.username,
  });

  factory User.fromMap(Map<String, dynamic> data, String id) {
    return User(
      id: id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      username: data['username'] ?? '', // New username field
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'username': username, // Include username in the map
    };
  }
}
