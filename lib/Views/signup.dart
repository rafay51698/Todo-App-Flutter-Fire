// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/Views/home.dart';
import 'package:todo_app/Views/login.dart';
import 'package:todo_app/theme/colors.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();

  final _formkey = GlobalKey<FormState>();

  createUser() async {
    if (_formkey.currentState!.validate()) {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: _emailController.text, password: _passController.text);

        String uid = userCredential.user!.uid;
        FirebaseFirestore.instance.collection('users').doc(uid).set({
          "username": _nameController.text,
          "email": _emailController.text,
        });

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(),
          ),
        );
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          // ignore: avoid_print
          print('The password provided is too weak.');
        }
      } catch (e) {
        // ignore: avoid_print
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(left: 30, right: 30, bottom: 20, top: 40),
            child: Form(
              key: _formkey,
              child: Column(
                children: [
                  const Center(
                    child: FlutterLogo(
                      size: 100,
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.05,
                  ),
                  TextFormField(
                    style: TextStyle(color: white),
                    controller: _nameController,
                    autocorrect: true,
                    // autofocus: true,
                    // obscureText: true,

                    keyboardType: TextInputType.name,
                    validator: (val) =>
                        val!.isEmpty ? "This field must not be empty!" : null,
                    decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.person,
                          color: white,
                        ),
                        // prefixIconColor: Colors.white,

                        labelText: "Username",
                        labelStyle: TextStyle(color: white),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(color: white)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        helperText: "Abdul Rafay",
                        helperStyle: TextStyle(color: white),
                        filled: true,
                        fillColor: primary),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.03,
                  ),
                  TextFormField(
                    controller: _emailController,
                    style: TextStyle(color: white),
                    autocorrect: true,
                    keyboardType: TextInputType.emailAddress,
                    validator: (val) =>
                        val!.isEmpty ? "Email address is empty!" : null,
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.email_outlined,
                        color: white,
                      ),
                      labelText: "Email",
                      labelStyle: TextStyle(color: white),
                      filled: true,
                      fillColor: primary,
                      helperText: "rafay@gmail.com",
                      helperStyle: TextStyle(color: white),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(color: white)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.03,
                  ),
                  TextFormField(
                    controller: _passController,
                    style: TextStyle(color: white),
                    autocorrect: true,
                    obscureText: true,
                    validator: (val) =>
                        val!.isEmpty ? "Password is empty!" : null,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.security,
                        color: white,
                      ),
                      labelText: "Password",
                      labelStyle: TextStyle(color: Colors.white),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(color: Colors.white)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      filled: true,
                      fillColor: primary,
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.03,
                  ),
                  CupertinoButton(
                    child: const Text("Signup"),
                    onPressed: createUser,
                    color: primary,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginPage(),
                        ),
                      );
                    },
                    child: Text(
                      "Already a member? login here!",
                      style: TextStyle(color: white),
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
