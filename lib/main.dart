import 'package:chat/firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform
    );


  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Container(
      color: Colors.amber[50],
    ),
  ));

  FirebaseFirestore.instance.collection('mensagens').doc('msg1').set({
    'texto':'Olá',
    'from' : 'Dani',
    'read' : false
    });
}