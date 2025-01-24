import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:goplay_project/login.dart';

import 'authenpage.dart';

void main() async{
WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: FirebaseOptions(apiKey: 'AIzaSyAdts7592riooOumQGEaeWTd2t7MMYw5E8',
        appId: '1:787606804935:android:51be72de54e5bfaf9ce1e2',
        messagingSenderId: '787606804935',
        projectId: 'goplay-8506c'),
  );
  runApp(MaterialApp(
debugShowCheckedModeBanner: false,
    initialRoute: 'login',
    routes: {
      'login':(context)=>MyLogin(),
      'authen': (context) => AuthenPage(),
    },

  ));
}
