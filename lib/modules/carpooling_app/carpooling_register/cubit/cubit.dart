import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:carpooling/modules/carpooling_app/carpooling_register/cubit/states.dart';

import '../../../../models/carpooling_app/carpooling_user_model.dart';

class CarpoolingRegisterCubit extends Cubit<CarpoolingRegisterStates> {
  CarpoolingRegisterCubit() : super(CarpoolingRegisterInitialState());

  static CarpoolingRegisterCubit get(context) => BlocProvider.of(context);

  void userRegister({
    required String name,
    required String email,
    required String password,
    required String phone,
    required String address,
  }) {
    print('hello');

    emit(CarpoolingRegisterLoadingState());

    FirebaseAuth.instance
        .createUserWithEmailAndPassword(
      email: email,
      password: password,
    )
        .then((value) {
          emit(CarpoolingRegisterSuccessState());
          print(value.user?.email);
          print(value.user?.uid);
      userCreate(
        uId: value.user!.uid,
        phone: phone,
        email: email,
        name: name,
        address: address,
      );
    }).catchError((error) {
      emit(CarpoolingRegisterErrorState(error.toString()));
    });
  }

  void userCreate({
    required String name,
    required String email,
    required String phone,
    required String uId,
    required String address,
  }) {
    CarpoolingUserModel model = CarpoolingUserModel(
      name: name,
      email: email,
      phone: phone,
      uId: uId,
      drivertrips: 0,
      rate: 0,
      rateNumbers: 0,
      ridertrips: 0,
      address: address,
      cover: 'https://media.wired.com/photos/59269cd37034dc5f91bec0f1/191:100/w_1280,c_limit/GoogleMapTA.jpg',
      image: 'https://www.nicepng.com/png/detail/136-1366211_group-of-10-guys-login-user-icon-png.png',
      isEmailVerified: true,
    );

    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .set(model.toMap())
        .then((value)
    {
          emit(CarpoolingCreateUserSuccessState());
    })
        .catchError((error) {
          print(error.toString());
      emit(CarpoolingCreateUserErrorState(error.toString()));
    });
  }

  IconData suffix = Icons.visibility_outlined;
  bool isPassword = true;

  void changePasswordVisibility() {
    isPassword = !isPassword;
    suffix =
        isPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined;

    emit(CarpoolingRegisterChangePasswordVisibilityState());
  }
}