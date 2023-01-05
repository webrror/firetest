import 'package:firetest/services/authentication.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUpEmailPass extends StatefulWidget {
  const SignUpEmailPass({super.key});

  @override
  State<SignUpEmailPass> createState() => _SignUpEmailPassState();
}

class _SignUpEmailPassState extends State<SignUpEmailPass> {
  final _formKey = GlobalKey<FormState>();
  bool _obscurePass = true;
  bool _obscureConfirmPass = true;
  final _email = TextEditingController();
  final _pass = TextEditingController();
  final _confirmPass = TextEditingController();

  void storeToPrefs(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', email);
  }

  AuthenticationService authService = AuthenticationService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Signup"),
      ),
      body: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                const SizedBox(
                  height: 30,
                ),
                const Text(
                  "Signup with email and password",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                ),
                const SizedBox(
                  height: 50,
                ),
                TextFormField(
                  controller: _email,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Email can't be empty";
                    } else if (!RegExp(
                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                        .hasMatch(value)) {
                      return "Enter a valid email";
                    }
                  },
                  decoration: InputDecoration(
                      label: const Text("Email"),
                      prefixIcon: const Icon(FluentIcons.mail_20_regular),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                ),
                const SizedBox(
                  height: 25,
                ),
                TextFormField(
                  controller: _pass,
                  decoration: InputDecoration(
                    label: const Text("Password"),
                    prefixIcon: const Icon(FluentIcons.password_20_regular),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    suffixIcon: GestureDetector(
                      onTap: () {
                        setState(() {
                          _obscurePass = !_obscurePass;
                        });
                      },
                      child: Icon(_obscurePass
                          ? FluentIcons.eye_20_regular
                          : FluentIcons.eye_off_20_regular),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty || value.length < 6) {
                      return "Password can't be less than 6 characters";
                    }
                  },
                  obscureText: _obscurePass,
                ),
                const SizedBox(
                  height: 25,
                ),
                TextFormField(
                  controller: _confirmPass,
                  decoration: InputDecoration(
                    label: const Text("Confirm Password"),
                    prefixIcon: const Icon(FluentIcons.password_20_regular),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    suffixIcon: GestureDetector(
                      onTap: () {
                        setState(() {
                          _obscureConfirmPass = !_obscureConfirmPass;
                        });
                      },
                      child: Icon(_obscureConfirmPass
                          ? FluentIcons.eye_20_regular
                          : FluentIcons.eye_off_20_regular),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty || value != _pass.text) {
                      return "Passwords don't match";
                    }
                  },
                  obscureText: _obscureConfirmPass,
                ),
                const SizedBox(
                  height: 30,
                ),
                SizedBox(
                    width: 150,
                    child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            authService
                                .signUp(_email.text, _pass.text)
                                .then((value) {
                              if (value != null && value.user.email != null) {
                                storeToPrefs(value.user.email);
                                Navigator.pop(context);
                                Navigator.pop(context);

                                Get.snackbar(
                                  'Success',
                                  'Successfully signed up',
                                  icon: const Icon(
                                      FluentIcons.checkmark_circle_20_regular),
                                  snackPosition: SnackPosition.BOTTOM,
                                  backgroundColor:
                                      Colors.green.withOpacity(0.8),
                                );
                              } else {
                                Get.snackbar(
                                  'Signup failed',
                                  'There was some problem while signing up',
                                  snackPosition: SnackPosition.BOTTOM,
                                  icon: const Icon(
                                      FluentIcons.error_circle_20_regular),
                                  backgroundColor: Colors.red.withOpacity(0.8),
                                );
                              }
                            });
                          }
                        },
                        child: const Text("Submit")))
              ],
            ),
          )),
    );
  }
}
