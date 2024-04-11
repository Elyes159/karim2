import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quran_app/constant/textformfield.dart';
import 'package:quran_app/constant/custombutton.dart';
import 'package:quran_app/constant/NumericTextForm.dart';
import 'package:quran_app/starting/signin.dart';

class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  PageController _pageController = PageController();
  TextEditingController password = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController username = TextEditingController();
  TextEditingController age = TextEditingController();

  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_currentPage > 0)
                Padding(
                  padding: const EdgeInsets.only(left: 16, top: 16),
                  child: IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () {
                      _pageController.previousPage(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                  ),
                ),
              const SizedBox(height: 150),
              _buildPageView(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPageView() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      child: PageView(
        controller: _pageController,
        onPageChanged: (int page) {
          setState(() {
            _currentPage = page;
          });
        },
        children: [
          _buildAge(),
          _buildUsernamePage(),
          _buildEmailPage(),
          _buildPasswordPage(),
        ],
      ),
    );
  }

  Widget _buildAge() {
    return Column(
      children: [
        Text(
          "How old are you?",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w500,
            fontSize: 25,
          ),
        ),
        const SizedBox(height: 40),
        NumericTextForm(
          hinttext: "",
          mycontroller: age,
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          height: 60,
          child: CustomButton(
            title: "Next",
            onPressed: () {
              _pageController.nextPage(
                duration: Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildUsernamePage() {
    return Column(
      children: [
        Text(
          "What is your name?",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w500,
            fontSize: 25,
          ),
        ),
        const SizedBox(height: 40),
        CustomTextForm(
          hinttext: "",
          mycontroller: username,
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          height: 60,
          child: CustomButton(
            title: "Next",
            onPressed: () {
              _pageController.nextPage(
                duration: Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildEmailPage() {
    return Column(
      children: [
        Text(
          "What is your email?",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w500,
            fontSize: 25,
          ),
        ),
        const SizedBox(height: 40),
        CustomTextForm(
          hinttext: "",
          mycontroller: email,
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          height: 60,
          child: CustomButton(
            title: "Next",
            onPressed: () {
              _pageController.nextPage(
                duration: Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordPage() {
    return Column(
      children: [
        Text(
          "Set up your password",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w500,
            fontSize: 25,
          ),
        ),
        const SizedBox(height: 40),
        CustomTextForm(
          hinttext: "",
          mycontroller: password,
          isPassword: true,
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          height: 60,
          child: CustomButton(
            title: "Signup",
            onPressed: () {
              _registerUser();
            },
          ),
        ),
      ],
    );
  }

  void _registerUser() async {
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email.text,
        password: password.text,
      );

      // Ajoutez l'utilisateur à la collection 'users' avec des informations supplémentaires
      await FirebaseFirestore.instance
          .collection('users')
          .doc(credential.user!.uid)
          .set({
        'username': username.text,
        'email': email.text,
        'age': age.text,
      });

      FirebaseAuth.instance.currentUser!.sendEmailVerification();

      Navigator.of(context).push(PageRouteBuilder(
          transitionDuration: Duration.zero,
          pageBuilder: (context, animation, secondaryAnimation) => Login()));
      // Envoyez un e-mail de vérification à l'utilisateur
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }
}
