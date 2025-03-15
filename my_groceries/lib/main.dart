import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_groceries/features/authentication/presentation/screens/providers/auth_providers.dart';
import 'package:my_groceries/features/authentication/presentation/screens/signup_screen.dart';
import 'package:my_groceries/features/groceries/presentation/screens/groceries_screen.dart';
import 'package:my_groceries/features/splash/presentation/screens/splash_screen.dart';
import 'package:my_groceries/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // initialize firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userStream = ref.watch(userStreamProvider);

    return MaterialApp(
      title: 'My Groceries',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: userStream.when(
          data: (user) {
            if (user == null) {
              return const SignupScreen();
            }

            return const GroceriesScreen();
          },
          loading: () => const SplashScreen(),
          error: (Object error, StackTrace stackTrace) =>
              // TODO: Return NoInternetScreen
              Center(child: Text('Error: $error'))),
    );
  }
}
