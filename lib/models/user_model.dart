class User {
  String id;
  String name;
  String email;
  String occupation;
  String bio;

  User({required this.id, required this.name, required this.email, required this.occupation, required this.bio});

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json['_id'],
    name: json['name'],
    email: json['email'],
    occupation: json['occupation'],
    bio: json['bio'],
  );

  Map<String, dynamic> toJson() => {
    '_id': id,
    'name': name,
    'email': email,
    'occupation': occupation,
    'bio': bio,
  };
}