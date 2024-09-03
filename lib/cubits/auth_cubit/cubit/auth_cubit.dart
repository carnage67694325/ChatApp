import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());
  Future<void> signInUser(
      {required String email, required String password}) async {
    emit(LoginLoading());
    try {
      UserCredential user = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      emit(LoginSuccess());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        emit(LoginFailure(errMessage: 'user not found'));
      } else if (e.code == 'wrong-password') {
        emit(LoginFailure(errMessage: 'wrong password'));
      }
    } catch (e) {
      print(e);
      emit(LoginFailure(errMessage: 'something went wrong'));
    }
  }

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
