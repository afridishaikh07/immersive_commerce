class User {
  final String id;
  final String email;
  final String name;
  final String? profileImagePath;
  final DateTime createdAt;

  const User({
    required this.id,
    required this.email,
    required this.name,
    this.profileImagePath,
    required this.createdAt,
  });

  User copyWith({
    String? id,
    String? email,
    String? name,
    String? profileImagePath,
    DateTime? createdAt,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      profileImagePath: profileImagePath ?? this.profileImagePath,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'profileImagePath': profileImagePath,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
      profileImagePath: json['profileImagePath'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is User &&
        other.id == id &&
        other.email == email &&
        other.name == name &&
        other.profileImagePath == profileImagePath &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        email.hashCode ^
        name.hashCode ^
        profileImagePath.hashCode ^
        createdAt.hashCode;
  }
}
