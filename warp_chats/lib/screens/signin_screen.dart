import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:warp_chats/constants/assets.dart';
import 'package:warp_chats/screens/signup_screen.dart';

// Setup firebase modules
final fa = FirebaseAuth.instance;
final fs = FirebaseFirestore.instance;

class SigninScreen extends StatefulWidget {
  const SigninScreen({super.key});

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  final _formKey = GlobalKey<FormState>();
  String _enteredEmail = '';
  String _enteredPassword = '';
  bool _isLoading = false;

  void _handleSignUp() {
    Navigator.of(context).push(MaterialPageRoute(builder: (builder) => SignupScreen()));
  }

  Future<void> _submit() async {
    // if we're currently loading, then we return
    if (_isLoading == true) return;

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
      // sign in user
      UserCredential userCreds = await fa.signInWithEmailAndPassword(email: _enteredEmail, password: _enteredPassword);

      debugPrint('User creds: $userCreds');

      setState(() {
        _isLoading = false;
      });
    } on FirebaseAuthException catch (error) {
      debugPrint('Auth error: ${error.message}');

      if (mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('There has been an error. Try again.')));
      }

      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: SingleChildScrollView(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Hero(
                tag: 'header-image',
                child:
                    Container(margin: const EdgeInsets.only(top: 30, bottom: 20, left: 20, right: 20), width: 200, child: Image.asset(Assets.chat))),
            Hero(
              tag: 'header-text',
              child: Column(
                children: [
                  Text(
                    'Welcome back!',
                    style: Theme.of(context).textTheme.headlineSmall!.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Please enter your credentials to continue",
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.white),
                  )
                ],
              ),
            ),
            Card(
              margin: const EdgeInsets.all(20),
              child: Padding(
                padding: const EdgeInsets.all(16),
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
                            if (!_isLoading) TextButton(onPressed: _submit, child: Text('Sign In'))
                          ],
                        ),
                      ],
                    )),
              ),
            ),
            Text(
              'Or continue using',
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Colors.white),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    shape: CircleBorder(),
                    padding: const EdgeInsets.all(20),
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.red,
                  ),
                  child: Image.asset(
                    'assets/images/google.png',
                    scale: 1.2,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Don't have an account?",
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Colors.white),
                ),
                SizedBox(
                  width: 5,
                ),
                GestureDetector(
                  onTap: _handleSignUp,
                  child: Text(
                    "Sign Up",
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
