import 'package:firetest/screens/fbAuth/signInEmailPass.dart';
import 'package:firetest/screens/fbAuth/signUpEmailPass.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home.dart';

class AllAuthOptions extends StatefulWidget {
  const AllAuthOptions({super.key});

  @override
  State<AllAuthOptions> createState() => _AllAuthOptionsState();
}

class _AllAuthOptionsState extends State<AllAuthOptions> {
  String? emailForScreen;

  @override
  void initState() {
    super.initState();
    checkLoggedIn();
  }

  void checkLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('email');
    if (email != null) {
      setState(() {
        emailForScreen = email;
      });
      navTo();
    }
  }

  void navTo() {
    Navigator.pushReplacement(context, MaterialPageRoute(
      builder: (context) {
        return Home(email: emailForScreen!);
      },
    ));
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Firebase Authentication"),
      ),
      body: SizedBox(
        width: screenWidth,
        child: Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return const SignUpEmailPass();
                    },
                  ));
                },
                label: const Text('Sign Up with email and password'),
                icon: const Icon(FluentIcons.mail_add_20_regular),
              ),
              SizedBox(height: screenHeight * 0.02),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return const SignInEmailPass();
                    },
                  ));
                },
                label: const Text('Sign In with email and password'),
                icon: const Icon(FluentIcons.mail_20_regular),
              ),
              SizedBox(height: screenHeight * 0.02),
              ElevatedButton.icon(
                onPressed: null,
                label: const Text('Sign In with phone number'),
                icon: const Icon(FluentIcons.phone_key_20_regular),
              )
            ],
          ),
        ),
      ),
    );
  }
}
