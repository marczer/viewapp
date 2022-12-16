// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:viewapp/Services/global_methods.dart';

class jobWidget extends StatefulWidget {
  
  final String jobTitle;
  final String jobDescription;
  final String jobId;
  final String telechargerpar;
  final String userImage;
  final String name;
  final bool recruitment;
  final String email;
  final String location;

  const jobWidget({
     required this.jobTitle,
     required this.jobDescription,
     required this.jobId,
     required this.telechargerpar,
     required this.userImage,
     required this.name,
     required this.recruitment,
     required this.email,
     required this.location,
  });


  @override
  State<jobWidget> createState() => _jobWidgetState();
}

class _jobWidgetState extends State<jobWidget> {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  _deleteDialog()
  {
     User? user = _auth.currentUser;
     final _uid = user!.uid;
     showDialog(
      context: context, 
      builder: (ctx)
      {
        return AlertDialog(
          actions: [
            TextButton(
              onPressed: () async {
                 try
                 {
                   if(widget.telechargerpar == _uid)
                   {
                    await FirebaseFirestore.instance.collection('jobs')
                     .doc(widget.jobId)
                     .delete();
                    await Fluttertoast.showToast(
                      msg: 'le travail a ete supprime',
                      toastLength: Toast.LENGTH_LONG,
                      backgroundColor: Colors.grey,
                      fontSize: 18.0,
                      );
                    Navigator.canPop(context) ? Navigator.pop(context): null;
                   }
                   else 
                   {
                    GlobalMethod.showErrorDialog(
                      error: 'Vous ne pouvez pas effectuer cette action', 
                      ctx: ctx
                      );
                   }
                 } catch (error) {
                  GlobalMethod.showErrorDialog(error: 'Cette tache ne peut pas etre supprimee reessayer plus tard', ctx: ctx);
                 }
              }, 
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                   Icon(Icons.delete,color: Colors.red,),
                   Text("supprimer",style: TextStyle(color: Colors.red),)
                ],
              ),
              )
          ],
        );
      }
    );
  }


  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white24,
      elevation: 8,
      margin: const EdgeInsets.symmetric(horizontal: 10,vertical: 8),
      child: ListTile(
        onTap: (){},
        onLongPress: (){ _deleteDialog(); },
        contentPadding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
        leading: Container(
          padding: const EdgeInsets.only(right: 12),
          decoration: const BoxDecoration(
            border: Border(
              right: BorderSide(width: 1)
            )
          ),
          child: Image.network(widget.userImage),
         ),
        title: Text(
          widget.jobTitle,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(color: Colors.amber,
                  fontWeight: FontWeight.
                  bold,fontSize: 18),
          ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              widget.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.
                  bold,fontSize: 13,
              ),
            ),
            const SizedBox(height: 8,),
            Text(
              widget.jobDescription,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.
                  bold,fontSize: 15,
              ),
            ),
          ],
        ),
        trailing: const Icon(Icons.keyboard_arrow_right,size: 30,color: Colors.black,),
      ),
    );
  }
}