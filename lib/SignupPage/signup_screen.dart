import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:viewapp/Services/global_methods.dart';
import 'package:viewapp/Services/global_variable.dart';

class SignUp extends StatefulWidget {
  

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> with TickerProviderStateMixin {

  final _SignUpFormKey = GlobalKey<FormState>();

  final TextEditingController _fullNameController = TextEditingController(text: '');
  final TextEditingController _emailTextController = TextEditingController(text: '');
  final TextEditingController _passTextController = TextEditingController(text: '');
  final TextEditingController _phoneNumberController = TextEditingController(text: '');
  final TextEditingController _locationController = TextEditingController(text: '');

  final FirebaseAuth _auth = FirebaseAuth.instance;

  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passFocusNode = FocusNode();
  final FocusNode _phoneNumberFocusNode = FocusNode();
  final FocusNode _positonCPFocusNode = FocusNode();

  File? imageFile;



  bool _obscureText = true;

  bool _isLoading = false;

  String? imageUrl;

  // le code d'animation commence ici avec le with TickerProviderStateMixin

  late Animation<double> _animation;
  late AnimationController _animationController;

    @override
  void dispose() {
    _animationController.dispose();
    _fullNameController.dispose();
    _emailTextController.dispose();
    _passTextController.dispose();
    _phoneNumberController.dispose();
    _emailFocusNode.dispose();
    _passFocusNode.dispose();
    _positonCPFocusNode.dispose();
    _phoneNumberFocusNode.dispose();
    super.dispose();
  }

    @override
  void initState() {
    _animationController = AnimationController(vsync: this, duration: const Duration(seconds: 20));
    _animation = CurvedAnimation(parent: _animationController, curve: Curves.linear)..addListener(() { setState(() {
      
    }); })
    ..addStatusListener((animationStatus) { 
      if (animationStatus == AnimationStatus.completed){
        _animationController.reset();
        _animationController.forward();
      }
    });
    _animationController.forward();
    super.initState(); 
  }

  // fin animation

  void _showImageDialog(){
    showDialog(
      context: context, 
      builder: (context)
      {
        return AlertDialog(
          title: const Text("choisir une option"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                onTap: () {
                  _getFromCamera();
                },
                child: Row(
                  children: const [
                    Padding(
                      padding: EdgeInsets.all(4.0),
                      child: Icon(Icons.camera,color: Colors.purple,),
                      ),
                      Text("camera",style: TextStyle(color: Colors.purple),)
                  ],
                ),
              ),
              const SizedBox(height: 10,),
              InkWell(
                onTap: () {
                  _getFromGallery();
                },
                child: Row(
                  children: const [
                    Padding(
                      padding: EdgeInsets.all(4.0),
                      child: Icon(Icons.image,color: Colors.purple,),
                      ),
                      Text("Galeri",style: TextStyle(color: Colors.purple),)
                  ],
                ),
              )
            ],
          ),
        );
      }
      );
  }

  void _getFromCamera() async {
    XFile? pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);
    _cropImage(pickedFile!.path);
    Navigator.pop(context);
  }

  void _getFromGallery() async {
    XFile? pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    _cropImage(pickedFile!.path);
    Navigator.pop(context);
  }
  
  void _cropImage(filePath) async {
    CroppedFile? croppedImage = await ImageCropper().cropImage(
      sourcePath: filePath, maxHeight: 1080,maxWidth: 1080 );
      if(croppedImage != null){
         setState(() {
           imageFile = File(croppedImage.path);
         });
      }
  }


  void _submitFormOnSignUp() async
  {
    final isValid =  _SignUpFormKey.currentState!.validate();
    if(isValid){
      if(imageFile == null){
        GlobalMethod.showErrorDialog(
          error: 'mettre une photo svp !', 
          ctx: context,
          );
          return;
      }
      setState(() {
        _isLoading = true;
      });

      try{
        await _auth.createUserWithEmailAndPassword(
          email: _emailTextController.text.trim().toLowerCase(), 
          password: _passTextController.text.trim(),
          );

          final User? user = _auth.currentUser;
          final _uid = user!.uid;
          final ref = FirebaseStorage.instance.ref().child('userImage').child(_uid+'.jpg');
          await ref.putFile(imageFile!);
          imageUrl = await ref.getDownloadURL();
          FirebaseFirestore.instance.collection('users').doc(_uid).set({
            'id': _uid,
            'name': _fullNameController.text,
            'email': _emailTextController.text,
            'userImage': imageUrl,
            'phoneNumber': _phoneNumberController.text,
            'location': _locationController.text,
            'createdAt': Timestamp.now(),
          });
          Navigator.canPop(context) ? Navigator.pop(context) : null;
      } catch (error) 
      {
        setState(() {
          _isLoading = false;
        });
        GlobalMethod.showErrorDialog(error: error.toString(), ctx: context);
      }
       setState(() {
          _isLoading = false;
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
           CachedNetworkImage(
            imageUrl: signUpUrlimage,
            placeholder: (context, url) => Image.asset('assets/images/wallpaper.jpg',fit: BoxFit.fill,),
            errorWidget: (context, url, error) => const Icon(Icons.error),
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
            // utiliser l'animation grace au code alignment: FractionalOffset(_animation.value, 0),
            alignment: FractionalOffset(_animation.value, 0),
            ),
            Container(
              color: Colors.black54,
              child:  Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 80),
                child: ListView(
                  children: [
                    // Padding(padding: const EdgeInsets.only(left: 80,right: 80),child: Image.asset('assets/images/login.png'),),
                    // const SizedBox(height: 15,),
                    Form(
                    key: _SignUpFormKey,
                    child: Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                _showImageDialog();
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  width: size.width * 0.24,
                                  height: size.width * 0.24,
                                  decoration: BoxDecoration(
                                    border: Border.all(width: 1,color: Colors.cyanAccent,),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(16),
                                    child: imageFile == null? const Icon(Icons.camera_enhance_sharp, color: Colors.cyan,size: 30,)
                                           : Image.file(imageFile!,fit: BoxFit.fill,)
                                     ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20,),
                             TextFormField(
                            textInputAction: TextInputAction.next,
                            onEditingComplete: () => FocusScope.of(context).requestFocus(_emailFocusNode),
                            keyboardType: TextInputType.name,
                            controller: _fullNameController,
                            validator: (value) {
                              if(value!.isEmpty ){
                                return  ' veulliez remplie ce champ ';
                              } else {
                                return null;
                              }
                                },
                                style: const TextStyle(color: Colors.white),
                                decoration: const InputDecoration(
                                  hintText: 'Nom',
                                  hintStyle: TextStyle(color: Colors.white),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white)
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white)
                                  ),
                                  errorBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red)
                                  ),
                                ),
                          ),
                          const SizedBox(height: 20,),
                            TextFormField(
                            textInputAction: TextInputAction.next,
                            onEditingComplete: () => FocusScope.of(context).requestFocus(_passFocusNode),
                            keyboardType: TextInputType.emailAddress,
                            controller: _emailTextController,
                            validator: (value) {
                              if(value!.isEmpty || !value.contains('@') ){
                                return  ' votre email est invalide ';
                              } else {
                                return null;
                              }
                                },
                                style: const TextStyle(color: Colors.white),
                                decoration: const InputDecoration(
                                  hintText: 'Email',
                                  hintStyle: TextStyle(color: Colors.white),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white)
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white)
                                  ),
                                  errorBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red)
                                  ),
                                ),
                           ),
                            const SizedBox(height: 20,),
                             TextFormField(
                            textInputAction: TextInputAction.next,
                            onEditingComplete: () => FocusScope.of(context).requestFocus(_phoneNumberFocusNode),
                            keyboardType: TextInputType.visiblePassword,
                            controller: _passTextController,
                            obscureText: !_obscureText,
                            validator: (value) {
                              if(value!.isEmpty || value.length < 7 ){
                                return  ' votre mot de passe est invalide  ';
                              } else {
                                return null;
                              }
                              },
                                style: const TextStyle(color: Colors.white),
                                decoration:  InputDecoration(
                                   suffix: GestureDetector(
                                     onTap: () {
                                      setState(() {
                                        _obscureText = !_obscureText;
                                      });
                                    },
                                    child: Icon(
                                      _obscureText? Icons.visibility:Icons.visibility_off,
                                      color: Colors.white,
                                    ),
                                   ),
                                  hintText: 'Cree un mot de passe',
                                  hintStyle: const TextStyle(color: Colors.white),
                                  enabledBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white)
                                  ),
                                  focusedBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white)
                                  ),
                                  errorBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red)
                                  ),
                                ),
                           ),
                           const SizedBox(height: 20,),
                            TextFormField(
                            textInputAction: TextInputAction.next,
                            onEditingComplete: () => FocusScope.of(context).requestFocus(_positonCPFocusNode),
                            keyboardType: TextInputType.phone,
                            controller: _phoneNumberController,
                            validator: (value) {
                              if(value!.isEmpty ){
                                return  ' votre email est invalide ';
                              } else {
                                return null;
                              }
                                },
                                style: const TextStyle(color: Colors.white),
                                decoration: const InputDecoration(
                                  hintText: 'Numero de telephone',
                                  hintStyle: TextStyle(color: Colors.white),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white)
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white)
                                  ),
                                  errorBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red)
                                  ),
                                ),
                           ),
                           const SizedBox(height: 20,),
                            TextFormField(
                            textInputAction: TextInputAction.next,
                            onEditingComplete: () => FocusScope.of(context).requestFocus(_positonCPFocusNode),
                            keyboardType: TextInputType.text,
                            controller: _locationController,
                            validator: (value) {
                              if(value!.isEmpty){
                                return  ' veulliez remplie ce champ ';
                              } else {
                                return null;
                              }
                                },
                                style: const TextStyle(color: Colors.white),
                                decoration: const InputDecoration(
                                  hintText: 'Lieux de residance',
                                  hintStyle: TextStyle(color: Colors.white),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white)
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white)
                                  ),
                                  errorBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red)
                                  ),
                                ),
                           ),
                            const SizedBox(height: 25,),
                            _isLoading?Center(
                              child: Container(
                                height: 70,
                                width: 70,
                                child: const CircularProgressIndicator(),
                              ),
                            ):
                            MaterialButton(
                              onPressed: () {
                                _submitFormOnSignUp();
                              },
                              color: Colors.cyan,
                              elevation: 8,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(13)
                              ),
                              child:  Padding(
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: 
                                  const [
                                    Text("Enregistre",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 19,
                                    ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                             const SizedBox(height: 40,),
                             Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text('vous avez deja un complet?',
                                     style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),),
                                    const Text('   '),
                                    GestureDetector(
                                      onTap: () => null,
                                      child: const Text('Connexion',
                                      style: TextStyle(
                                        color: Colors.cyan,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold
                                        )
                                      ),
                                    )
                                  ],
                                ),
                              )
                    ],
              )
              ), 

                  ],
                )
                 ),
            ),
        ],
      ),
    );
  }
}