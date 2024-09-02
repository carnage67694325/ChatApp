import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

part 'sign_up_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  SignUpCubit() : super(SignUpInitial());
  Future<void> signUpUser(
      {required String email, required String password}) async {
    emit(SignUpLoading());
    try {
      UserCredential user = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      emit(SignUpSuccess());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        emit(SignUpFaliure(errMessage: 'weak password'));
      } else if (e.code == 'email-already-in-use') {
        emit(SignUpFaliure(errMessage: 'email-already-in-use'));
      }
    } catch (e) {
      emit(SignUpFaliure(errMessage: 'something went wrong'));
    }
  }
}
