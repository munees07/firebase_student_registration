// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:student_firebase/controller/firebase_provider.dart';
import 'package:student_firebase/controller/image_provider.dart';
import 'package:student_firebase/helpers/snackbar_helper.dart';
import 'package:student_firebase/helpers/textfield_helper.dart';
import 'package:student_firebase/model/student_model.dart';

class AddPage extends StatelessWidget {
  AddPage({super.key});

  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController classController = TextEditingController();

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
              child: Column(
                children: [
                  FutureBuilder(
                    future: Future.value(
                        Provider.of<ImageProviders>(context).pickedImage),
                    builder: (context, snapshot) {
                      return CircleAvatar(
                        radius: 40,
                        backgroundImage: snapshot.data != null
                            ? FileImage(snapshot.data!)
                            : null,
                      );
                    },
                  ),
                  const Gap(10),
                  TextButton(
                      onPressed: () {
                        Provider.of<ImageProviders>(context, listen: false)
                            .pickImage(ImageSource.gallery);
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
                        onPressed: () async {
                          await addstudentData(context);
                          Navigator.pop(context);
                        },
                        child: const Text('Submit')),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  addstudentData(BuildContext context) async {
    final provider = Provider.of<FireBaseProvider>(context, listen: false);
    final imageprovider = Provider.of<ImageProviders>(context, listen: false);
    final name = nameController.text;
    final age = ageController.text;
    final className = classController.text;
    await provider.imageAdder(File(imageprovider.pickedImage!.path));

    final student = StudentModel(
        name: name,
        age: int.parse(age),
        className: className,
        image: provider.downloadurl);
    provider.addStudent(student);
    successMessage(context, message: 'student added successfully');
    imageprovider.clearPickedImage();
  }
}
