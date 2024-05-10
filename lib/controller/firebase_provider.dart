// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:student_firebase/model/student_model.dart';
import 'package:student_firebase/services/student_services.dart';

class FireBaseProvider extends ChangeNotifier {
  StudentService studentService = StudentService();
  String imagename = DateTime.now().microsecondsSinceEpoch.toString();
  String downloadurl = "";

  Stream<QuerySnapshot<StudentModel>> getStudents() {
    return studentService.studentRef.snapshots();
  }

  imageAdder(image) async {
    Reference imagefolder = studentService.firebaseStorage.child('images');
    Reference uploadimage = imagefolder.child("$imagename.jpg");
    try {
      await uploadimage.putFile(image);
      downloadurl = await uploadimage.getDownloadURL();

      print(downloadurl);
    } catch (error) {
      return Exception('image cant be added $error');
    }
  }

  imageUpdate(imageurl, updatedimage) async {
    try {
      Reference editpic = FirebaseStorage.instance.refFromURL(imageurl);
      await editpic.putFile(updatedimage);
      downloadurl = await editpic.getDownloadURL();
    } catch (error) {
      return Exception('image is not updated$error');
    }
  }

  deleteImage(imageurl) async {
    try {
      Reference delete = FirebaseStorage.instance.refFromURL(imageurl);
      await delete.delete();
    } catch (error) {
      return Exception('image is not deleted $error');
    }
  }

  Future<void> addStudent(StudentModel student) async {
    await studentService.studentRef.add(student);
    notifyListeners();
  }

  Future<void> editStudent(String id, StudentModel student) async {
    studentService.studentRef.doc(id).update(student.toJson());
    notifyListeners();
  }

  Future<void> deleteStudent(String id) async {
    studentService.studentRef.doc(id).delete();
    notifyListeners();
  }
}
