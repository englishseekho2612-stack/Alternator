/// Detailed user profile containing preference flags
class UserProfile {
  final String uid;
  final String displayName;
  final String email;
  final String profilePictureUrl;
  final String preferredLanguage; // en, hi, hinglish
  final bool emailNotificationsEnabled;
  final bool pushNotificationsEnabled;
  final DateTime createdAt;
  final DateTime lastSyncedAt;
  final bool isCloudSyncActive;

  UserProfile({
    required this.uid,
    required this.displayName,
    required this.email,
    required this.profilePictureUrl,
    required this.preferredLanguage,
    required this.emailNotificationsEnabled,
    required this.pushNotificationsEnabled,
    required this.createdAt,
    required this.lastSyncedAt,
    required this.isCloudSyncActive,
  });

  UserProfile copyWith({
    String? uid,
    String? displayName,
    String? email,
    String? profilePictureUrl,
    String? preferredLanguage,
    bool? emailNotificationsEnabled,
    bool? pushNotificationsEnabled,
    DateTime? createdAt,
    DateTime? lastSyncedAt,
    bool? isCloudSyncActive,
  }) {
    return UserProfile(
      uid: uid ?? this.uid,
      displayName: displayName ?? this.displayName,
      email: email ?? this.email,
      profilePictureUrl: profilePictureUrl ?? this.profilePictureUrl,
      preferredLanguage: preferredLanguage ?? this.preferredLanguage,
      emailNotificationsEnabled: emailNotificationsEnabled ?? this.emailNotificationsEnabled,
      pushNotificationsEnabled: pushNotificationsEnabled ?? this.pushNotificationsEnabled,
      createdAt: createdAt ?? this.createdAt,
      lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
      isCloudSyncActive: isCloudSyncActive ?? this.isCloudSyncActive,
    );
  }

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      uid: json['uid'] ?? 'anon_user_123',
      displayName: json['displayName'] ?? 'A Alternator User',
      email: json['email'] ?? 'user@apps-alternator.com',
      profilePictureUrl: json['profilePictureUrl'] ?? 'https://api.dicebear.com/7.x/adventurer/svg?seed=Felix',
      preferredLanguage: json['preferredLanguage'] ?? 'en',
      emailNotificationsEnabled: json['emailNotificationsEnabled'] ?? true,
      pushNotificationsEnabled: json['pushNotificationsEnabled'] ?? true,
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      lastSyncedAt: DateTime.parse(json['lastSyncedAt'] ?? DateTime.now().toIso8601String()),
      isCloudSyncActive: json['isCloudSyncActive'] ?? true,
    );
  }

  Map<String, dynamic> toJson() => {
    'uid': uid,
    'displayName': displayName,
    'email': email,
    'profilePictureUrl': profilePictureUrl,
    'preferredLanguage': preferredLanguage,
    'emailNotificationsEnabled': emailNotificationsEnabled,
    'pushNotificationsEnabled': pushNotificationsEnabled,
    'createdAt': createdAt.toIso8601String(),
    'lastSyncedAt': lastSyncedAt.toIso8601String(),
    'isCloudSyncActive': isCloudSyncActive,
  };
}
