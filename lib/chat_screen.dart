import 'dart:io';

import 'package:chat/chat_message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:chat/text_composer.dart';
import 'package:google_sign_in/google_sign_in.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  User? _currentUser;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((user) {
      _currentUser = user;
     });
  }

  Future<User?> _getUser() async {

    if(_currentUser != null) return _currentUser;

    try {
      final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken
      );

      final authResult = await FirebaseAuth.instance.signInWithCredential(credential);

      final User user = authResult.user;

    } catch (e) {
      print(e);
      return null;
    }
  }

  void _sendMessage({String? text, File? imgFile}) async{

    final User? user = await _getUser();

    if(user == null){
      _scaffoldKey.currentState!.showSnackBar(
        const SnackBar(
          content: Text('Não foi possível fazer o login. Tente novamente!'),
          backgroundColor: Colors.red,
          )
      );
    }
    

    Map<String, dynamic> data = {
      "uid" : user!.uid,
      "senderName" : user.displayName,
      "senderPhotoUrl" : user.photoURL
    };
    

    if (imgFile != null) {
      TaskSnapshot task = await FirebaseStorage.instance.ref().child(
        '${DateTime.now().millisecondsSinceEpoch.toString()}'
      ).putFile(imgFile);

      String url = await task.ref.getDownloadURL();
      
      data['urlImg'] = url;
    }

    if(text != null){
      data['texto'] = text;
    }

    FirebaseFirestore.instance.collection('messages').add(data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Olá'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Color.fromARGB(255, 17, 7, 132),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('messages').snapshots(),
              builder: (context, snapshot){
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  default:
                  List<DocumentSnapshot> documents = snapshot.data!.docs;

                    return ListView.builder(
                      itemCount: documents.length,
                      reverse: true,
                      itemBuilder: (context, index){
                        return ChatMessage(documents[index].data(), true);
                      }
                    );
                }
              }
            )
          ),
          TextComposer(_sendMessage),
        ],
      ),
    );
  }
}