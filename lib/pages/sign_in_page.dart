import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:scholar_chat/constants.dart';
import 'package:scholar_chat/helper/show_snack_bar.dart';
import 'package:scholar_chat/pages/chat_page.dart';
import 'package:scholar_chat/pages/sign_up_page.dart';
import 'package:scholar_chat/widgets/custom_button.dart';
import 'package:scholar_chat/widgets/custom_form_textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignInPage extends StatefulWidget {
  SignInPage({super.key, this.email, this.password});
  static String id = 'SignInPage';
  String? email;
  String? password;

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  bool? isLoading = false;

  GlobalKey<FormState> formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
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
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
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
                        'Sign in',
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
                      widget.email = data;
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
                      widget.password = data;
                    },
                    hintText: 'Password',
                  ),
                  const SizedBox(height: 24.0),
                  CustomButton(
                    onTap: () async {
                      if (formKey.currentState!.validate()) {
                        isLoading = true;
                        setState(() {});
                        try {
                          await signInUser();
                          Navigator.pushNamed(context, ChatPage.id,
                              arguments: widget.email);
                        } on FirebaseAuthException catch (e) {
                          if (e.code == 'user-not-found') {
                            showSnackBar(
                                context, 'No user found for that email.');
                          } else if (e.code == 'wrong-password') {
                            showSnackBar(context, 'Wrong password provided.');
                          }
                          print(e);
                        } catch (e) {
                          print(e);
                          showSnackBar(context, 'there was an error');
                        }
                        isLoading = false;
                        setState(() {});
                      } else {}
                    },
                    buttonText: 'Sign in',
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
                          Navigator.pushNamed(
                            context,
                            SignUpPage.id,
                          );
                        },
                        child: const Text(
                          ' Sign Up',
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
  }

  Future<void> signInUser() async {
    UserCredential user = await FirebaseAuth.instance
        .signInWithEmailAndPassword(
            email: widget.email!, password: widget.password!);
  }
}
