import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:viewapp/loginPage/login_screen.dart';
import 'package:viewapp/user_state.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
       title: 'view app',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            scaffoldBackgroundColor: Colors.black,
            primarySwatch: Colors.blue,
            // fontFamily: 'Signatra'
          ),
      home: UserState(),
    );
  }
}

// void main() {
//   WidgetsFlutterBinding.ensureInitialized;
//   runApp( MyApp());
// }

// class MyApp extends StatelessWidget {

//   final WidgetsBinding _initialization = WidgetsFlutterBinding.ensureInitialized();

//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder(
//        initialData: _initialization,
//       builder: (context, snapshot) {
//         if(snapshot.connectionState == ConnectionState.waiting){
//           return const MaterialApp(
//             home: Scaffold(
//               body: Center(
//                 child: Text('viewapp clone app is being initialized',
//                 style: TextStyle(
//                   color: Colors.red,
//                   fontSize: 40,
//                   fontWeight: FontWeight.bold,
//                   fontFamily: 'Signatra'
//                 ),
//                 ),
//               ),
//             ),
//           );
//         } else if (snapshot.hasError){
//           return const MaterialApp(
//             home: Scaffold(
//                body: Center(
//                 child: Text('an error has been occurred',
//                 style: TextStyle(
//                   color: Colors.red,
//                   fontSize: 40,
//                 ),
//                 ),
//               ),
//             ),
//           ); 
//         }
//         return MaterialApp(
//           title: 'view app',
//           debugShowCheckedModeBanner: false,
//           theme: ThemeData(
//             scaffoldBackgroundColor: Colors.black,
//             primarySwatch: Colors.blue,
//           ),
//           home: Login(),
//         );
//       }
//       );
//     // MaterialApp(
//     //   title: 'Flutter Demo',
//     //   theme: ThemeData(
//     //     primarySwatch: Colors.blue,
//     //   ),
//     //   home: ,
//     // );
//   }
// }
