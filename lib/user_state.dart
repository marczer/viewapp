import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:viewapp/jobs/jobs_screen.dart';
import 'package:viewapp/loginPage/login_screen.dart';

class UserState extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (ctx ,userSnapshot)
      {
          if(userSnapshot.data == null ){
             print("l'utilisateurr n'est pas encore connecte");
             return Login();
          }
          else if(userSnapshot.hasData){
            print("l'utilisateur est deja connecte");
            return jobScreen();
          }
          else if(userSnapshot.hasError){
            return const Scaffold(
              body: Center(
                child: Text("Une erreur s'est produite. Reessayez plus tard"),
              ),
            );
          }

          else if(userSnapshot.connectionState == ConnectionState.waiting){
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          return const Scaffold(
              body: Center(
                child: Text("Quelque chose s'est mal passe"),
              ),
            );
      }
    );
  }
}