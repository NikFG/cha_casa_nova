import 'package:flutter/material.dart';

import 'pages/my_home_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chá de casa nova Nikollas + Laís',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color.fromARGB(255, 112, 89, 83),
        fontFamily: "BlackMango",
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}
