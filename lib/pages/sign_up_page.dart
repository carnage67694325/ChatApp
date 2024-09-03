import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:scholar_chat/constants.dart';
import 'package:scholar_chat/cubits/auth_cubit/cubit/auth_cubit.dart';
import 'package:scholar_chat/helper/show_snack_bar.dart';
import 'package:scholar_chat/pages/chat_page.dart';
import 'package:scholar_chat/widgets/custom_button.dart';
import 'package:scholar_chat/widgets/custom_form_textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({
    super.key,
  });
  static String id = 'SignUpPage';

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool? isLoading = false;
  String? email;
  String? password;
  GlobalKey<FormState> formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is SignUpLoading) {
          isLoading = true;
        } else if (state is SignUpSuccess) {
          Navigator.pushNamed(context, ChatPage.id, arguments: email);
          isLoading = false;
        } else if (state is SignUpFaliure) {
          showSnackBar(context, state.errMessage);
          isLoading = false;
        }
      },
      builder: (context, state) {
        return Scaffold(
            backgroundColor: kPriamryColor,
            body: ModalProgressHUD(
              color: Colors.black,
              progressIndicator: LoadingAnimationWidget.twistingDots(
                  leftDotColor: kPriamryColor,
                  rightDotColor: Colors.white,
                  size: 30),
              inAsyncCall: isLoading!,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 24.0),
                child: Form(
                  key: formKey,
                  child: ListView(
                    children: [
                      const SizedBox(
                        height: 150,
                      ),
                      Center(
                        child: Image.asset(kLogo),
                      ),
                      const Center(
                        child: Text(
                          'Scholar Chat',
                          style: TextStyle(
                            fontFamily: 'Pacifico',
                            color: Colors.white,
                            fontSize: 24,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24.0),
                      const Row(
                        children: [
                          Text(
                            'Sign up',
                            style: TextStyle(color: Colors.white, fontSize: 24),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16.0),
                      CustomFormTextField(
                        suffixIcon: const Icon(
                          Icons.mail,
                          color: Colors.white,
                        ),
                        onChanged: (data) {
                          email = data;
                        },
                        hintText: 'Email',
                      ),
                      const SizedBox(height: 16.0),
                      CustomFormTextField(
                        suffixIcon: const Icon(
                          Icons.lock,
                          color: Colors.white,
                        ),
                        obscureText: true,
                        onChanged: (data) {
                          password = data;
                        },
                        hintText: 'Password',
                      ),
                      const SizedBox(height: 24.0),
                      CustomButton(
                        onTap: () async {
                          if (formKey.currentState!.validate()) {
                            BlocProvider.of<AuthCubit>(context)
                                .signUpUser(email: email!, password: password!);
                          } else {}
                        },
                        buttonText: 'Sign up',
                      ),
                      const SizedBox(height: 16.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Don you have an account?",
                            style: TextStyle(color: Colors.white),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: const Text(
                              ' Sign in',
                              style: TextStyle(color: Color(0xffC7EDE6)),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ));
      },
    );
  }
}
