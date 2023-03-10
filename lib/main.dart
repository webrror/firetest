import 'package:firebase_core/firebase_core.dart';
import 'package:firetest/screens/allexamples.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.deepPurple,
        primaryColor: Colors.deepPurple,
        brightness: Brightness.light
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.green,
        primaryColor: Colors.green,
        brightness: Brightness.dark
      ),
      home: const AllExamples(),
    );
  }
}

