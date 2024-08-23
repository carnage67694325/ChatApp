import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:scholar_chat/constants.dart';
import 'package:scholar_chat/helper/show_snack_bar.dart';
import 'package:scholar_chat/pages/chat_page.dart';
import 'package:scholar_chat/widgets/custom_button.dart';
import 'package:scholar_chat/widgets/custom_form_textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignUpPage extends StatefulWidget {
  SignUpPage({super.key, this.email, this.password});
  static String id = 'SignUpPage';
  String? email;
  String? password;

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
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
                          await signUpUser();
                          Navigator.pushNamed(context, ChatPage.id,
                              arguments: widget.email);
                        } on FirebaseAuthException catch (e) {
                          if (e.code == 'weak-password') {
                            showSnackBar(
                                context, 'The password provided is too weak.');
                          } else if (e.code == 'email-already-in-use') {
                            showSnackBar(context,
                                'The account already exists for that email.');
                          }
                        } catch (e) {
                          showSnackBar(context, 'there was an error');
                        }
                        isLoading = false;
                        setState(() {});
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
  }

  Future<void> signUpUser() async {
    UserCredential user = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(
            email: widget.email!, password: widget.password!);
  }
}
