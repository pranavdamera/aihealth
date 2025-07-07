class Patient {
  String id;
  String name;
  int age;
  String gender;
  Patient({required this.id, required this.name, required this.age, required this.gender});
  Map<String, dynamic> toMap() => {'name': name, 'age': age, 'gender': gender};
}