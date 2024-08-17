class UserProfile {
  final String id;
  final String displayName;
  final String email;
  final String? photoUrl;

  UserProfile({
    required this.id,
    required this.displayName,
    required this.email,
    this.photoUrl,
  });

  factory UserProfile.fromFirestore(Map<String, dynamic> data, String id) {
    return UserProfile(
      id: id,
      displayName: data['displayName'] ?? 'No Name',
      email: data['email'] ?? 'No Email',
      photoUrl: data['photoUrl'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'displayName': displayName,
      'email': email,
      'photoUrl': photoUrl,
    };
  }
}
