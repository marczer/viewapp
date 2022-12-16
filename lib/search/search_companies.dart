import 'package:flutter/material.dart';
import 'package:viewapp/Widgets/bottom_nav_bar.dart';

class AllWorkersScreen extends StatefulWidget {

  @override
  State<AllWorkersScreen> createState() => _AllWorkersScreenState();
}

class _AllWorkersScreenState extends State<AllWorkersScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
                decoration: BoxDecoration(
                gradient: LinearGradient(
                colors: [ Colors.deepOrange.shade300, Colors.blueAccent ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                stops: const [0.2 , 0.9]
                    ),
                  ),
              child: Scaffold(
                bottomNavigationBar: BottomNavigationBarForApp(indexNum: 1),
                backgroundColor: Colors.transparent,
                 appBar: AppBar(
                    title: const Text("la page des travailler"),
                    centerTitle: true,
                    flexibleSpace: Container(
                    decoration: BoxDecoration(
                    gradient: LinearGradient(
                    colors: [ Colors.deepOrange.shade300, Colors.blueAccent ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    stops: const [0.2 , 0.9]
                        ),
                      ),
                    ),
                  )
                 ),
              );
  }
}