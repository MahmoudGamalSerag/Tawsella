import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:carpooling/modules/carpooling_app/carpooling_login/cubit/states.dart';

class CarpoolingLoginCubit extends Cubit<CarpoolingLoginStates> {
  CarpoolingLoginCubit() : super(CarpoolingLoginInitialState());

  static CarpoolingLoginCubit get(context) => BlocProvider.of(context);

   bool? userLogin({
    required String email,
    required String password,
  }) {
    emit(CarpoolingLoginLoadingState());
    if(email=='admin'&&password=='123456')
      {
        emit(CarpoolingAdminLoginState());
        return true;
      }
    FirebaseAuth.instance
        .signInWithEmailAndPassword(
          email: email,
          password: password,
        )
        .then((value) {
          print(value.user!.email);
          print(value.user!.uid);
          emit(CarpoolingLoginSuccessState(value.user!.uid));
          print("successsss");
          return true;
    })
        .catchError((error)
    {
      emit(CarpoolingLoginErrorState(error.toString()));
      return false;
    });
  }

  IconData suffix = Icons.visibility_outlined;
  bool isPassword = true;

  void changePasswordVisibility() {
    isPassword = !isPassword;
    suffix =
        isPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined;

    emit(CarpoolingChangePasswordVisibilityState());
  }
}
