import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo_app/Views/home.dart';
// import 'package:todo_app/Views/home.dart';
import 'package:todo_app/Views/signup.dart';

import '../theme/colors.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();

  final _formkey = GlobalKey<FormState>();

  loginUser() async {
    if (_formkey.currentState!.validate()) {
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: _emailController.text, password: _passController.text);

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: ((context) => const HomePage()),
          ),
        );
      } on FirebaseAuthException catch (e) {
        if (e.code == 'not-found') {
          // ignore: avoid_print
          print('No user found for that email.');
        } else if (e.code == 'wrong-password') {
          // ignore: avoid_print
          print('Wrong password provided for that user.');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.only(left: 15, right: 15),
            child: Form(
              key: _formkey,
              child: Column(
                children: [
                  const SizedBox(
                    height: 100,
                  ),
                  const Center(
                    child: FlutterLogo(
                      size: 100,
                    ),
                  ),
                  const SizedBox(
                    height: 60,
                  ),
                  TextFormField(
                    controller: _emailController,
                    // style: const TextStyle(color: black),
                    autocorrect: true,
                    keyboardType: TextInputType.emailAddress,
                    validator: (val) =>
                        val!.isEmpty ? "Email address is empty!" : null,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(
                        Icons.email_outlined,
                        // color: black,
                      ),
                      labelText: "Email",
                      // labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                      // focusedBorder: OutlineInputBorder(
                      //     borderRadius: BorderRadius.circular(20),
                      //     borderSide: const BorderSide(color: Colors.white),
                      //     ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      // filled: true,
                      // fillColor: const Color.fromARGB(255, 26, 24, 24),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    controller: _passController,
                    // style: const TextStyle(color: Colors.white),
                    autocorrect: true,
                    obscureText: true,
                    validator: (val) =>
                        val!.isEmpty ? "Password is empty!" : null,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(
                        Icons.security,
                        // color: Colors.white,
                      ),
                      labelText: "Password",
                      // labelStyle: const TextStyle(color: Colors.white),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        // borderSide: const BorderSide(color: Colors.white)
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      // filled: true,
                      // fillColor: const Color.fromARGB(255, 26, 24, 24),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CupertinoButton(
                    child: const Text(
                      "Sign in",
                      style: TextStyle(color: Colors.blueAccent),
                    ),
                    onPressed: loginUser,
                    color: primary,
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SignupPage(),
                        ),
                      );
                    },
                    child: const Text(
                      "Don't have an account ? Signup here!",
                      // style: TextStyle(color: white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
