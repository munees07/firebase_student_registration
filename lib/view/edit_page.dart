// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:student_firebase/controller/firebase_provider.dart';
import 'package:student_firebase/controller/image_provider.dart';
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
  bool isClicked = true;

  @override
  void initState() {
    nameController.text = widget.students.name;
    ageController.text = widget.students.age.toString();
    classController.text = widget.students.className;
    Provider.of<ImageProviders>(context, listen: false).file =
        File(widget.students.image ?? "");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 72, 94, 105),
      ),
      body: Stack(
        children: [
          Image.asset(
              alignment: Alignment.centerLeft,
              height: double.infinity,
              width: double.infinity,
              fit: BoxFit.fitHeight,
              'assets/background.jpg'),
          SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.only(left: 20, right: 20, top: 30),
              child:
                  Consumer<ImageProviders>(builder: (context, provider, child) {
                return Column(
                  children: [
                    FutureBuilder<File?>(
                      future: Future.value(provider.file),
                      builder: (context, snapshot) {
                        return CircleAvatar(
                          backgroundColor: Colors.grey,
                          radius: 40,
                          backgroundImage: !isClicked
                              ? FileImage(provider.file!.path as File)
                              : NetworkImage(provider.file!.path)
                                  as ImageProvider,
                        );
                      },
                    ),
                    const Gap(10),
                    TextButton(
                        onPressed: () {
                          provider.getCam(ImageSource.gallery);
                        },
                        child: const Text('Pick a image')),
                    const Gap(10),
                    textFieldWidget(controller: nameController, text: 'Name'),
                    const Gap(10),
                    textFieldWidget(controller: ageController, text: 'Age'),
                    const Gap(10),
                    textFieldWidget(
                        controller: classController, text: 'Class Name'),
                    const Gap(20),
                    Center(
                        child: ElevatedButton(
                            onPressed: () {
                              editStudentData(context, widget.students.image);
                            },
                            child: const Text('Submit')))
                  ],
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  editStudentData(BuildContext context, imageurl) async {
    final provider = Provider.of<FireBaseProvider>(context, listen: false);
    final imageProvider = Provider.of<ImageProviders>(context, listen: false);
    final name = nameController.text;
    final age = ageController.text;
    final className = classController.text;
    await provider.imageUpdate(imageurl, File(imageProvider.file!.path));
    final student = StudentModel(
        name: name,
        age: int.parse(age),
        className: className,
        image: provider.downloadurl);
    provider.editStudent(widget.id, student);
    showDialog(
      context: context,
      useSafeArea: true,
      builder: (context) => AlertDialog(
        content: const Text('Student edited successfully'),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text('OK'))
        ],
      ),
    );
  }
}
