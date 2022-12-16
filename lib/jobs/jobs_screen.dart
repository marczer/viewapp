import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:viewapp/Persistent/persistent.dart';
import 'package:viewapp/Widgets/bottom_nav_bar.dart';
import 'package:viewapp/Widgets/job_widget.dart';
import 'package:viewapp/search/search_job.dart';
import 'package:viewapp/user_state.dart';

class jobScreen extends StatefulWidget {

  @override
  State<jobScreen> createState() => _jobScreenState();
}

class _jobScreenState extends State<jobScreen> {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? jobCategoryFilter;

    _showTaskCategoriesDialog({required Size size}){

    showDialog(
      context: context, 
      builder: (ctx)
      {
        return AlertDialog(
          backgroundColor: Colors.black54,
          title: const Text('job Category',textAlign: TextAlign.center,style: TextStyle(fontSize: 20,color: Colors.white),),
          content: Container(
            width: size.width*0.9,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: Persistent.jobCategoryList.length,
              itemBuilder: (ctx,index)
              {
                return InkWell(
                  onTap: () {
                    setState(() {
                    jobCategoryFilter = Persistent.jobCategoryList[index];
                    });
                    Navigator.canPop(context) ? Navigator.pop(context):null;
                    print('jobCategoryFilter = Persistent.jobCategoryList[index] : ${jobCategoryFilter = Persistent.jobCategoryList[index]} ');
                  },
                  child: Row(
                    children: [
                      const Icon(Icons.arrow_right_alt_outlined,color: Colors.grey,),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text( Persistent.jobCategoryList[index],style: const TextStyle(color: Colors.grey,fontSize: 16), ),
                        )
                    ],
                  ),
                );
              },
             ),
          ),
          actions: [
            TextButton(
              onPressed: (){ Navigator.canPop(context) ? Navigator.pop(context) : null; },
              child: const Text('fermer', style: TextStyle(color: Colors.white,fontSize: 16),),
            ),
            TextButton(
              onPressed: (){
                setState(() {
                  jobCategoryFilter = null;
                });
                Navigator.canPop(context) ? Navigator.pop(context) : null;
                },
              child: const Text('annuler le filtre', style: TextStyle(color: Colors.white,fontSize: 16),),
            ),
          ],
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      // code de degradation avec le contenaire
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [ Colors.deepOrange.shade300, Colors.blueAccent ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          stops: const [0.2 , 0.9]
          )
      ),
      // fin du code
      child: Scaffold(
        bottomNavigationBar: BottomNavigationBarForApp(indexNum: 0),
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          // title: const Text("page principal"),
          // centerTitle: true,
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
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: const Icon(Icons.filter_list_rounded, color: Colors.black,),
            onPressed: (){  _showTaskCategoriesDialog(size: size); },
           ),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (c) => SearchScreen()  ) );
              }, 
              icon: const Icon(Icons.search_outlined, color: Colors.black,)
              )
           ],
          ),
          body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: FirebaseFirestore.instance
              .collection('jobs')
              .where('jobCategory', isEqualTo: jobCategoryFilter)
              .where('recruitment', isEqualTo: true)
              .orderBy('createdAt', descending: false)
              .snapshots(),
            builder: (context, AsyncSnapshot snapshot)
            {
                if(snapshot.connectionState == ConnectionState.waiting)
                {
                  return const Center(child: CircularProgressIndicator(),);
                }
                else if(snapshot.connectionState == ConnectionState.active)
                 {
                  if(snapshot.data?.docs.isNotEmpty == true)
                  {
                    return ListView.builder(
                      itemCount: snapshot.data?.docs.length,
                      itemBuilder: (BuildContext context, int index)
                      {
                        return jobWidget(
                          jobTitle: snapshot.data?.docs[index]['jobTitle'], 
                          jobDescription: snapshot.data?.docs[index]['jobDescription'], 
                          jobId: snapshot.data?.docs[index]['jobId'], 
                          telechargerpar: snapshot.data?.docs[index]['telechargerpar'], 
                          userImage: snapshot.data?.docs[index]['userImage'], 
                          name: snapshot.data?.docs[index]['name'], 
                          recruitment: snapshot.data?.docs[index]['recruitment'], 
                          email: snapshot.data?.docs[index]['email'], 
                          location: snapshot.data?.docs[index]['location']
                          );
                       }
                      );
                  }
                  else {
                    return const Center(
                      child: Text("il n'y a pas d'emploi"),
                    );
                  }
                 }
                 return const Center(
                  child: Text('Quelque chose a mal tourne',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 30),),
                );
            },
          ),
        )
       );
      }
}