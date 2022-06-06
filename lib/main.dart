import 'package:chat/chat_screen.dart';
import 'package:chat/firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform
    );


  runApp(
    MaterialApp(
      title: 'Chat Flutter',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color.fromARGB(255, 17, 7, 132),
        iconTheme: IconThemeData(
          color: Color.fromARGB(255, 17, 7, 132)
        )
      ),
      home: ChatScreen()
    )
  );

  // FirebaseFirestore.instance.collection('mensagens').snapshots().listen((event) {
  //   print(event.docs);
  // });
}