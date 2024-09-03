import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scholar_chat/cubits/auth_cubit/cubit/auth_cubit.dart';
import 'package:scholar_chat/cubits/chat_cubit/cubit/chat_cubit.dart';
import 'package:scholar_chat/firebase_options.dart';
import 'package:scholar_chat/pages/chat_page.dart';
import 'package:scholar_chat/pages/sign_in_page.dart';
import 'package:scholar_chat/pages/sign_up_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ScholarChat());
}

class ScholarChat extends StatelessWidget {
  const ScholarChat({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthCubit()),
        BlocProvider(create: (context) => ChatCubit())
      ],
      child: MaterialApp(
        routes: {
          SignInPage.id: (context) => SignInPage(),
          SignUpPage.id: (context) => SignUpPage(),
          ChatPage.id: (context) => ChatPage(),
        },
        initialRoute: SignInPage.id,
      ),
    );
  }
}
