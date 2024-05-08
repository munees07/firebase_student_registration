class StudentModel {
  String name;
  int age;
  String className;
  String? image;

  StudentModel({required this.name,required this.age,required this.className,
  required this.image
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'age': age,
      'class': className,
      'image': image,
    };
  }

  factory StudentModel.fromJson(Map<String, dynamic> json) {
    return StudentModel(
      name: json['name'],
      age: json['age'],
      className: json['class'],
      image: json['image'],
    );
  }
}
