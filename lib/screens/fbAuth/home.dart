import 'package:flutter/material.dart';

import 'package:firetest/screens/allexamples.dart';
import 'package:firetest/services/authentication.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  const Home({
    Key? key,
    required this.email,
  }) : super(key: key);
  final String email;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  AuthenticationService authService = AuthenticationService();

  void removeDetails() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('email');
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard"),
      ),
      body: SizedBox(
        width: screenWidth,
        child: Column(
          children: [
            SizedBox(
              height: screenHeight * 0.1,
            ),
            Text(
              "Email : ${widget.email}",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: screenHeight * 0.3),
            ElevatedButton(
                onPressed: () {
                  authService.signOut().then((value) => removeDetails()).then(
                      (value) =>
                          Navigator.pop(context, MaterialPageRoute(
                            builder: (context) {
                              return const AllExamples();
                            },
                          )));
                },
                style: ElevatedButton.styleFrom(foregroundColor: Colors.red),
                child: const Text("Sign Out")),
            SizedBox(
              height: screenHeight * 0.1,
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.pop(context, MaterialPageRoute(
                    builder: (context) {
                      return const AllExamples();
                    },
                  ));
                },
                child: const Text("Go to main menu"))
          ],
        ),
      ),
    );
  }
}
