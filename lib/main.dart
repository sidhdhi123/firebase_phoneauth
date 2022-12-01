import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fp28/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    // options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MaterialApp(
    home: login(),
  ));
}

