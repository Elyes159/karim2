import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quran_app/features/home/pages/home_screen.dart';
import 'package:quran_app/languages/languages.dart';
import 'package:quran_app/languages/languages_constants.dart';
import 'package:quran_app/main_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  final double initialFontSize;

  SettingsPage({required this.initialFontSize});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  TextEditingController _fontSizeController = TextEditingController();

  late double _fontSize;

  @override
  void initState() {
    super.initState();
    _fontSize = widget.initialFontSize;
  }

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth _auth = FirebaseAuth.instance;

    String? getUserUID() {
      User? user = _auth.currentUser;
      if (user != null) {
        return user.uid;
      } else {
        return null;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Paramètres'),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButton<Language>(
              underline: const SizedBox(),
              icon: const Icon(
                Icons.language,
                color: Colors.black,
              ),
              onChanged: (Language? language) async {
                if (language != null) {
                  Locale _locale = await setLocale(language.languageCode);
                  // ignore: use_build_context_synchronously
                  MyApp.setLocale(context, _locale);
                }
              },
              items: Language.languageList()
                  .map<DropdownMenuItem<Language>>(
                    (e) => DropdownMenuItem<Language>(
                      value: e,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Text(
                            e.name,
                            style: const TextStyle(fontSize: 15),
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Taille de la police',
              style: Theme.of(context).textTheme.headline6,
            ),
            TextFormField(
              controller: _fontSizeController, // Utilisez le contrôleur ici
              keyboardType: TextInputType.numberWithOptions(decimal: true),

              decoration: InputDecoration(
                labelText: 'Taille de la police',
                border: OutlineInputBorder(),
              ),
            ),
            Text(
              '$_fontSize',
              style: TextStyle(fontSize: 20),
            ),
            ElevatedButton(
              onPressed: () async {
                String? userUID = await getUserUID();
                if (userUID != null) {
                  // Ajouter la valeur à Firestore avec le userUID comme identifiant de document
                  // FirebaseFirestore.instance
                  //     .collection('settings')
                  //     .doc(userUID)
                  //     .set({
                  //   'fontSize': _fontSizeController.text,
                  // });
                  print("font size ajoutééééé");
                } else {
                  print(
                      "FUIEZOIFEZEZNEZOINCOIEZNCOIEZNCOIENOIENOIECOIEZNCOIEZNOIEZCOIENOIENCOIEZNOIEZNCOIEZNCEZNOCIEZNC");
                }
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => HomeScreenNew()));
              },
              child: Text('Enregistrer'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _loadFontSize(double fontSize) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _fontSize = fontSize; // Utiliser la valeur passée comme argument
      prefs.setDouble('fontSize', fontSize);
    });
  }
}
