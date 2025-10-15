/// ユーザーエンティティ
class User {
  final String id;
  final String name;
  final String email;
  final String avatarUrl;

  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.avatarUrl,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is User &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          email == other.email &&
          avatarUrl == other.avatarUrl;

  @override
  int get hashCode =>
      id.hashCode ^ name.hashCode ^ email.hashCode ^ avatarUrl.hashCode;

  @override
  String toString() => 'User(id: $id, name: $name, email: $email)';
}

