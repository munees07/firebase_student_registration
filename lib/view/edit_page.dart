import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:student_firebase/controller/firebase_provider.dart';
import 'package:student_firebase/helpers/textfield_helper.dart';
import 'package:student_firebase/model/student_model.dart';

class EditPage extends StatefulWidget {
  final String id;
  final StudentModel students;
  const EditPage({super.key, required this.id, required this.students});

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController classController = TextEditingController();

  @override
  void initState() {
    nameController.text = widget.students.name;
    ageController.text = widget.students.age.toString();
    classController.text = widget.students.className;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.only(left: 20, right: 20, top: 30),
        child: Column(
          children: [
            textFieldWidget(controller: nameController, text: 'Name'),
            const Gap(10),
            textFieldWidget(controller: ageController, text: 'Age'),
            const Gap(10),
            textFieldWidget(controller: classController, text: 'Class Name'),
            const Gap(20),
            Center(
                child: ElevatedButton(
                    onPressed: () {
                      editStudentData(context);
                    },
                    child: const Text('Submit')))
          ],
        ),
      ),
    );
  }

  editStudentData(BuildContext context) {
    final provider = Provider.of<FireBaseProvider>(context, listen: false);
    final name = nameController.text;
    final age = ageController.text;
    final className = classController.text;
    final student =
        StudentModel(name: name, age: int.parse(age), className: className,image: '');
    provider.editStudent(widget.id, student);
    Navigator.pop(context);
  }
}
