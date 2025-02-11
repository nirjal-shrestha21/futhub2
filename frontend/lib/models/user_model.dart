class User {
  final String id;
  final String name;
  final String email;
  final String role; // 'admin', 'futsal_owner', 'player'
  final String phoneNumber;
  final String? profilePicture;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.phoneNumber,
    this.profilePicture,
  });

  // Convert JSON to User object
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      role: json['role'],
      phoneNumber: json['phone_number'] ?? '', // Default empty string if phone number is missing
      profilePicture: json['profile_picture'] ?? 'https://example.com/default-profile.png',
    );
  }

  // Convert User object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role,
      'phone_number': phoneNumber,
      'profile_picture': profilePicture,
    };
  }
}
