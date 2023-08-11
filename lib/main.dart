import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/bloc/auth_cubit.dart';
import 'package:social_media_app/screens/chat_screen.dart';
import 'package:social_media_app/screens/create_post_screen.dart';
import 'package:social_media_app/screens/posts_screen.dart';
import 'package:social_media_app/screens/sign_in_screen.dart';
import 'package:social_media_app/screens/sign_up_screen.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

Future<void> main() async {
  await SentryFlutter.init(
    (options) {
      options.dsn = 'https://sentry.io/onboarding/homespb/setup-docs/';
    },
    // Init your App.
    appRunner: () async {
      //* обращаеться к движку flutter перед Firebase
      WidgetsFlutterBinding.ensureInitialized();
 
      await Firebase.initializeApp();
      runApp(const MyApp());
    },
  );
}

class MyApp extends StatelessWidget {
  Widget _builderHomeScreen() {
    return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return const PostsScreen();
          } else {
            return const SignInScreen();
          }
        });
  }

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthCubit>(
      create: (context) => AuthCubit(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark()
            .copyWith(scaffoldBackgroundColor: const Color(0xFF31405F)),
        home: _builderHomeScreen(),
        routes: {
          SignInScreen.id: (context) => const SignInScreen(),
          SignUpScreen.id: (context) => const SignUpScreen(),
          PostsScreen.id: (context) => const PostsScreen(),
          CreatePostScreen.id: (context) => const CreatePostScreen(),
          ChatScreen.id: (context) => const ChatScreen(),
        },
      ),
    );
  }
}
