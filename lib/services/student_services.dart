import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:student_firebase/model/student_model.dart';

class StudentService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  late final CollectionReference<StudentModel> studentRef;
  Reference main = FirebaseStorage.instance.ref();

  StudentService() {
    studentRef = firestore
        .collection("student-record")
        .withConverter<StudentModel>(
            fromFirestore: (snapshot, options) =>
                StudentModel.fromJson(snapshot.data()!),
            toFirestore: (value, options) => value.toJson());
  }
}
