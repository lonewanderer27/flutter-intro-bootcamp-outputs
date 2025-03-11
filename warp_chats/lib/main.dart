import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:warp_chats/screens/signin_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:warp_chats/screens/splash_screen.dart';
import 'package:warp_chats/widgets/main_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // load env file
  // by default, it already loads the .env file
  // so we ommited the fileName argument.
  await dotenv.load();

  // init firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // finally run our app
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Warp Chats',
        theme: ThemeData().copyWith(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
              seedColor: const Color.fromARGB(255, 63, 17, 177)),
        ),
        home: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (ctx, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SplashScreen();
              }

              if (snapshot.hasData) {
                // this screen only serves as the container
                // for the activePage state container
                return const MainScreen();
              }
              return const SigninScreen();
            }));
  }
}
