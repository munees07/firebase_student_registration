import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:student_firebase/controller/firebase_provider.dart';
import 'package:student_firebase/controller/image_provider.dart';
import 'package:student_firebase/view/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyCzD4VHlIor3DpI7o1sK8fIFqicervJSBA",
            authDomain: "fir-first-27610.firebaseapp.com",
            projectId: "fir-first-27610",
            storageBucket: "fir-first-27610.appspot.com",
            messagingSenderId: "182597927169",
            appId: "1:182597927169:web:163c653e4501a4f762db00",
            measurementId: "G-6147LPESY0"));
  } else {
    await Firebase.initializeApp();
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MultiProvider(providers: [ChangeNotifierProvider(create: (context) => FireBaseProvider()),ChangeNotifierProvider(create: (context) => ImageProviders())],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: HomePage(),
        ),
    );
  }
}
