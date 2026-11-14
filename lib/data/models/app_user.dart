class AppUser {
  const AppUser({
    required this.uid,
    required this.name,
    required this.email,
    this.phone = '',
  });

  factory AppUser.fromMap(String uid, Map<String, dynamic> map) => AppUser(
    uid: uid,
    name: (map['name'] as String?) ?? 'User',
    email: (map['email'] as String?) ?? '',
    phone: (map['phone'] as String?) ?? '',
  );

  final String uid;
  final String name;
  final String email;
  final String phone;
}
