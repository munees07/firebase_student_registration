import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:student_firebase/controller/firebase_provider.dart';
import 'package:student_firebase/helpers/snackbar_helper.dart';
import 'package:student_firebase/model/student_model.dart';
import 'package:student_firebase/view/add_page.dart';
import 'package:student_firebase/view/edit_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          backgroundColor: const Color.fromARGB(255, 72, 94, 105),
          title: const Text(
            'Student-Record',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          )),
      floatingActionButton: FloatingActionButton.small(
          child: const Icon(Icons.add),
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => AddPage()));
          }),
      body: Stack(
        children: [
          Image.asset(
              alignment: Alignment.centerLeft,
              height: double.infinity,
              width: double.infinity,
              fit: BoxFit.fitHeight,
              'assets/background.jpg'),
          Consumer<FireBaseProvider>(builder: (context, provider, child) {
            return StreamBuilder<QuerySnapshot<StudentModel>>(
              stream: provider.getStudents(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                List<QueryDocumentSnapshot<StudentModel>> studentDoc =
                    snapshot.data?.docs ?? [];
                return ListView.builder(
                  itemCount: studentDoc.length,
                  itemBuilder: (context, index) {
                    StudentModel students = studentDoc[index].data();
                    final imageUrl =
                        students.image ?? 'assets/13-10-2023 12_17_21.png';
                    final id = studentDoc[index].id;
                    return Container(
                      margin: const EdgeInsets.only(top: 20, right: 5),
                      child: Slidable(
                        endActionPane:
                            ActionPane(motion: const ScrollMotion(), children: [
                          SlidableAction(
                              icon: Icons.edit,
                              borderRadius: BorderRadius.circular(15),
                              backgroundColor: Colors.grey.shade300,
                              onPressed: (context) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => EditPage(
                                            id: id, students: students)));
                              }),
                          const Gap(5),
                          SlidableAction(
                              icon: Icons.delete,
                              borderRadius: BorderRadius.circular(15),
                              backgroundColor: Colors.redAccent,
                              onPressed: (context) {
                                Provider.of<FireBaseProvider>(context,
                                        listen: false)
                                    .deleteStudent(id);
                                Provider.of<FireBaseProvider>(context,
                                        listen: false)
                                    .deleteImage(students.image);
                                successMessage(context,
                                    message: 'deleted successfully');
                              })
                        ]),
                        child: Container(
                          margin: const EdgeInsets.only(right: 20, left: 20),
                          child: Material(
                            color: Colors.white.withOpacity(0.2),
                            elevation: 5,
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(right: 20, left: 20),
                                child: Row(
                                  children: [
                                    Column(
                                      children: [
                                        const Gap(15),
                                        CircleAvatar(
                                            backgroundColor: Colors.blue,
                                            backgroundImage:
                                                NetworkImage(imageUrl),
                                            radius: 40),
                                        const Gap(15)
                                      ],
                                    ),
                                    const Gap(40),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text("Name : ${students.name}",
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold)),
                                        Text("Age : ${students.age.toString()}",
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold)),
                                        Text("Class : ${students.className}",
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold)),
                                        const Gap(10)
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            );
          }),
        ],
      ),
    );
  }
}
