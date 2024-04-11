// ignore_for_file: unused_local_variable

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quran_app/constant/customlogo.dart';
import 'package:quran_app/constant/textformfield.dart';
import 'package:quran_app/core/constant.dart';
import 'package:quran_app/features/home/pages/home_screen.dart';
import 'package:quran_app/starting/welcome_signup.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController password = TextEditingController();
  TextEditingController email = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(15),
        child: ListView(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 50),
                Customlogo(),
                SizedBox(height: 20),
                SizedBox(height: 10),
                SizedBox(height: 20),
                Text(
                  "Input Your Email",
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500, fontSize: 18),
                ),
                SizedBox(height: 10),
                CustomTextForm(
                  hinttext: "",
                  mycontroller: email,
                ),
                SizedBox(height: 10),
                Text(
                  "Input Your Password",
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 10),
                CustomTextForm(
                  hinttext: "",
                  mycontroller: password,
                  isPassword: true,
                ),
                InkWell(
                  onTap: () async {
                    if (email.text == "") {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('email not found'),
                            content: Text('please insert an exesting email'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context)
                                      .pop(); // Ferme la boîte de dialogue
                                },
                                child: Text('Fermer'),
                              ),
                            ],
                          );
                        },
                      );
                      return;
                    }
                    await FirebaseAuth.instance
                        .sendPasswordResetEmail(email: email.text);
                    // ignore: use_build_context_synchronously
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Reset password'),
                          content: const Text(
                              'if your email exist , we sended a reset password link'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(context)
                                    .pop(); // Ferme la boîte de dialogue
                              },
                              child: const Text('Fermer'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Container(
                    alignment: Alignment.topRight,
                    margin: EdgeInsets.only(top: 10, bottom: 20),
                    child: Text(
                      "Forgot password?",
                      textAlign: TextAlign.right,
                      style: GoogleFonts.poppins(
                          fontSize: 14, color: Colors.grey[900]),
                    ),
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  height: 45,
                  child: Material(
                    child: GestureDetector(
                      onTap: () async {
                        try {
                          final credential = await FirebaseAuth.instance
                              .signInWithEmailAndPassword(
                            email: email.text,
                            password: password.text,
                          );
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomeScreenNew()));
                        } on FirebaseAuthException catch (e) {
                          if (e.code == 'user-not-found') {
                            print('No user found for that email.');
                          } else if (e.code == 'wrong-password') {
                            print('Wrong password provided for that user.');
                          }
                        }
                      },
                      child: Container(
                        width: double.infinity,
                        height: 45,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: const Center(
                          child: Text(
                            "Login",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(PageRouteBuilder(
                        transitionDuration: Duration.zero,
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            Signup1()));
                  },
                  child: Center(
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                              text: "Doesn't have account? ",
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey)),
                          TextSpan(
                            text: " Register",
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF7885ff),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
