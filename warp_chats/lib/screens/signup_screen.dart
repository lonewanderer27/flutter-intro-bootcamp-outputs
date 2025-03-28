import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:warp_chats/constants/assets.dart';
import 'package:warp_chats/screens/threads_screen.dart';
import 'package:warp_chats/screens/signin_screen.dart';
import 'package:warp_chats/widgets/user_image_picker.dart';
import 'package:http/http.dart' as http;

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();

  File? chosenImage;
  String _enteredUsername = '';
  String _enteredEmail = '';
  String _enteredPassword = '';
  bool _isLoading = false;

  void _handleSignIn() {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    } else {
      Navigator.of(context).push(MaterialPageRoute(builder: (builder) => SigninScreen()));
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _submit() async {
    // if we're currently loading, then we return
    if (_isLoading == true) return;

    // if the user has not submitted an image, we return
    if (chosenImage == null) {
      _showMessage('Please set your profile image.');
      return;
    }

    // if we have errors, we return
    if (_formKey.currentState!.validate() == false) {
      return;
    }

    _formKey.currentState!.save();
    debugPrint('Email: $_enteredEmail');
    debugPrint('Password: $_enteredPassword');

    setState(() {
      _isLoading = true;
    });

    try {
      // sign up user
      UserCredential userCreds = await fa.createUserWithEmailAndPassword(email: _enteredEmail, password: _enteredPassword);

      debugPrint('User creds: $userCreds');

      // Convert image into base64 string
      List<int> imageBytes = await chosenImage!.readAsBytes();
      String base64Image = base64Encode(imageBytes);

      // create our final user object
      final profile = <String, dynamic>{'username': _enteredUsername, 'avatarBase64': base64Image};

      // upload user information to firebase
      await fs.collection('users').doc(fa.currentUser!.uid).set(profile);

      // get the default local url
      String backendUrl = dotenv.env['BACKEND_URL']!;

      // otherwise if we're in release mode, replace it with the prod url
      if (kReleaseMode) {
        backendUrl = dotenv.env['PROD_BACKEND_URL']!;
      }

      // create our very own yourself chat thread
      final res = await http.post(Uri.parse('$backendUrl/users/${fa.currentUser!.uid}/create-yourself-thread'));

      debugPrint('Yourself Thread: ${res.body}');

      // go to chats screen
      if (mounted) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (builder) => ThreadsScreen()));
      }

      setState(() {
        _isLoading = false;
      });
    } on FirebaseAuthException catch (error) {
      debugPrint('Auth error: ${error.message}');
      _showMessage('There has been an error. Try again.');

      setState(() {
        _isLoading = false;
      });
    }
  }

  void handlePickImage(File imageFile) {
    setState(() {
      chosenImage = imageFile;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: SingleChildScrollView(
            child: Column(
          children: [
            Row(
              children: [
                Hero(
                  tag: 'header-image',
                  child:
                      Container(margin: const EdgeInsets.only(top: 30, bottom: 20, left: 20, right: 20), width: 100, child: Image.asset(Assets.chat)),
                ),
                Hero(
                  tag: 'header-text',
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Hi there!',
                        textAlign: TextAlign.left,
                        style: Theme.of(context).textTheme.headlineSmall!.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Create your account to get started',
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.white),
                      ),
                    ],
                  ),
                )
              ],
            ),
            Stack(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 55),
                  child: Card(
                    margin: const EdgeInsets.all(20),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 50, left: 16, right: 16, bottom: 16),
                      child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextFormField(
                                keyboardType: TextInputType.emailAddress,
                                textCapitalization: TextCapitalization.none,
                                autocorrect: false,
                                decoration: InputDecoration(icon: Icon(Icons.mail), label: Text('Email')),
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Please return a valid email';
                                  }

                                  return null;
                                },
                                onSaved: (value) {
                                  _enteredEmail = value!;
                                },
                              ),
                              SizedBox(height: 10),
                              TextFormField(
                                textCapitalization: TextCapitalization.none,
                                autocorrect: false,
                                decoration: InputDecoration(icon: Icon(Icons.person), label: Text('Username')),
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Please return a valid username';
                                  }

                                  if (value.trim().length < 4) {
                                    return 'Username must be at least 4 characters';
                                  }

                                  return null;
                                },
                                onSaved: (value) {
                                  _enteredUsername = value!;
                                },
                              ),
                              SizedBox(height: 10),
                              TextFormField(
                                obscureText: true,
                                autocorrect: false,
                                decoration: InputDecoration(icon: Icon(Icons.lock), label: Text('Password')),
                                validator: (value) {
                                  if (value == null || value.trim().length < 6) {
                                    return 'Password must be at least 6 characters long';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  _enteredPassword = value!;
                                },
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  if (_isLoading) CircularProgressIndicator(),
                                  if (!_isLoading) TextButton(onPressed: _submit, child: Text('Sign Up'))
                                ],
                              ),
                            ],
                          )),
                    ),
                  ),
                ),
                Center(
                  child: UserImagePicker(
                    onPickImage: handlePickImage,
                    currentImage: chosenImage,
                  ),
                )
              ],
            ),
            // Text(
            //   'Or continue using',
            //   style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Colors.white),
            // ),
            // const SizedBox(
            //   height: 10,
            // ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     ElevatedButton(
            //       onPressed: () {},
            //       style: ElevatedButton.styleFrom(
            //         shape: CircleBorder(),
            //         padding: const EdgeInsets.all(20),
            //         backgroundColor: Colors.blue,
            //         foregroundColor: Colors.red,
            //       ),
            //       child: Image.asset(
            //         'assets/images/google.png',
            //         scale: 1.2,
            //       ),
            //     ),
            //   ],
            // ),
            SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Already have an account?",
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Colors.white),
                ),
                SizedBox(
                  width: 5,
                ),
                GestureDetector(
                  onTap: _handleSignIn,
                  child: Text(
                    "Sign In",
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                )
              ],
            )
          ],
        )),
      ),
    );
  }
}
