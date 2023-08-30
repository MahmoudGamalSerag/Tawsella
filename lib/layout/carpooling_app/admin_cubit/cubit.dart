import 'dart:io';

import 'package:carpooling/layout/carpooling_app/admin_cubit/states.dart';
import 'package:carpooling/models/carpooling_app/carpooling_car_model.dart';
import 'package:carpooling/models/carpooling_app/carpooling_user_model.dart';
import 'package:carpooling/models/carpooling_app/post_model.dart';
import 'package:carpooling/models/carpooling_app/trip_model.dart';
import 'package:carpooling/modules/admin/admin_adduser_screen.dart';
import 'package:carpooling/modules/admin/admin_blockedusers_screen.dart';
import 'package:carpooling/modules/admin/admin_home_screen.dart';
import 'package:carpooling/modules/admin/admin_users_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_storage/firebase_storage.dart'as firebase_storage;
import 'package:image_picker/image_picker.dart';

class AdminCubit extends Cubit<AdminStates>
{
  AdminCubit() : super(AdminInitialState());

  static AdminCubit get(context) => BlocProvider.of(context);


  int currentIndex = 0;

  List<Widget> screens = [
    AdminUsersScreen(),
    AdminHomeScreen(),
    AdminAddUserScreen(),
    AdminBlockedUsersScreen()
  ];

  List<String> titles = [
    'Users',
    'Home',
    'Add User',
    'Blocked Users',
  ];

  void adminchangeBottomNav(int index) {
    if(index==2)
      {
        emit(AdminAddUserState());
      }
    else {
      currentIndex = index;
      emit(AdminChangeBottomNavState());
    }
  }

  void updateUser({
    required String name,
    required String phone,
    required String address,
    required String email,
    String? cover,
    String? image,
  }) {
    emit(AdminUserUpdateLoadingState());
    CarpoolingUserModel model = CarpoolingUserModel(
      name: name,
      phone: phone,
      address: address,
      email: email,
      cover: cover ?? profileOwner.cover,
      image: image ?? profileOwner.image,
      uId: profileOwner.uId,
      ridertrips: profileOwner.ridertrips,
      rate: profileOwner.rate,
      rateNumbers: profileOwner.rateNumbers,
      drivertrips: profileOwner.drivertrips,
      isEmailVerified: profileOwner.isEmailVerified,
    );

    FirebaseFirestore.instance
        .collection('users')
        .doc(profileOwner.uId)
        .update(model.toMap())
        .then((value) {
      getUserData();
      adminGetUsers();
      emit(AdminUserUpdateSuccessState());
    }).catchError((error) {
      emit(AdminUserUpdateErrorState());
    });
  }

  File? profileImage;
  var picker = ImagePicker();

  Future<void> getProfileImage() async {
    final pickedFile = await picker.getImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      profileImage = File(pickedFile.path);
      print(pickedFile.path);
      emit(AdminProfileImagePickedSuccessState());
    } else {
      print('No image selected.');
      emit(AdminProfileImagePickedErrorState());
    }
  }

  // image_picker7901250412914563370.jpg

  File? coverImage;

  Future<void> getCoverImage() async {
    final pickedFile = await picker.getImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      coverImage = File(pickedFile.path);
      emit(AdminCoverImagePickedSuccessState());
    } else {
      print('No image selected.');
      emit(AdminCoverImagePickedErrorState());
    }
  }

  void uploadProfileImage({
    required String name,
    required String phone,
    required String address,
    required String email,
  }) {
    emit(AdminUserUpdateLoadingState());

    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('users/${Uri.file(profileImage!.path).pathSegments.last}')
        .putFile(profileImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        //emit(CarpoolingUploadProfileImageSuccessState());
        print(value);
        updateUser(
          name: name,
          email: email,
          phone: phone,
          address: address,
          image: value,
        );
      }).catchError((error) {
        emit(AdminUploadProfileImageErrorState());
      });
    }).catchError((error) {
      emit(AdminUploadProfileImageErrorState());
    });
  }

  void uploadCoverImage({
    required String name,
    required String phone,
    required String address,
    required String email,
  }) {
    emit(AdminUserUpdateLoadingState());

    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('users/${Uri.file(coverImage!.path).pathSegments.last}')
        .putFile(coverImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        //emit(CarpoolingUploadCoverImageSuccessState());
        print(value);
        updateUser(
          name: name,
          email: email,
          phone: phone,
          cover: value,
          address: address,
        );
      }).catchError((error) {
        emit(AdminUploadCoverImageErrorState());
      });
    }).catchError((error) {
      emit(AdminUploadCoverImageErrorState());
    });
  }

  void updateUserImages({
    required String name,
    required String phone,
    required String address,
    required String email,
  })
  {
    emit(AdminUserUpdateLoadingState());

    if(coverImage != null)
    {
      uploadCoverImage(name: name,phone: phone,address: address,email: email,);
    } else if(profileImage != null)
    {
      uploadProfileImage(name: name,phone: phone,address: address,email: email,);
    } else if (coverImage != null && profileImage != null)
    {

    } else
    {
      updateUser(
        name: name,
        email: email,
        phone: phone,
        address:address,
      );
    }
  }
  void getUserData() {
    emit(AdminGetUserLoadingState());
    FirebaseFirestore.instance.collection('users').doc(profileOwner.uId).get().then((value) {
      print(value.data());
      profileOwner = CarpoolingUserModel.fromJson(value.data()!);
      emit(AdminGetUserSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(AdminGetUserErrorState(error.toString()));
    });
  }

  // Blocking
  void blocking()
  {
    profileOwner.isEmailVerified=!(profileOwner.isEmailVerified);
    updateUser(name: profileOwner.name, phone: profileOwner.phone, address: profileOwner.address, email: profileOwner.email);
  }
  //
  //
  //
  // //Car Methods
  // AdminCarModel? carModel;
  // void getCarData() {
  //   emit(AdminGetCarLoadingState());
  //   FirebaseFirestore.instance.collection('cars').doc( CacheHelper.getData(key: 'uId')).get().then((value) {
  //     print(value.data());
  //     carModel = AdminCarModel.fromJson(value.data()!);
  //     emit(AdminGetCarSuccessState());
  //   }).catchError((error) {
  //     print("Carrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrr");
  //     print(error.toString());
  //     print("Carrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrr");
  //     emit(AdminGetCarErrorState(error.toString()));
  //   });
  // }
  //
  // void createCar({
  //   required String model,
  //   required String brand,
  //   required String license,
  //   required String userlicense,
  // }) {
  //   emit(AdminCarLoadingState());
  //
  //   AdminCarModel carmodel = AdminCarModel(
  //     model:model,
  //     brand:brand,
  //     license:license,
  //     userlicense:userlicense,
  //     uId:userModel.uId,
  //     image:'https://iheartcraftythings.com/wp-content/uploads/2021/04/Car-DRAWING-%E2%80%93-STEP-9.jpg',
  //   );
  //   // print(carmodel.brand);
  //   // print(carmodel.uId);
  //   // print(carmodel.license);
  //   // print(carmodel.model);
  //   FirebaseFirestore.instance
  //       .collection('cars')
  //       .doc(userModel.uId)
  //       .set(carmodel.toMap())
  //       .then((value) {
  //     emit(AdminCarSuccessState());
  //     showToast(text: "Car Added Successfully", state: ToastStates.SUCCESS);
  //     carModel=carmodel;
  //   }).catchError((error) {
  //     emit(AdminCarErrorState());
  //   });
  // }
  // void updateCar({
  //   required String license,
  //   required String userlicense,
  //   required String model,
  //   required String brand,
  // }) {
  //   emit(AdminCarUpdateLoadingState());
  //   AdminCarModel carmodel = AdminCarModel(
  //     model: model,
  //     license: license,
  //     userlicense: userlicense,
  //     brand: brand,
  //     uId: userModel!.uId,
  //     image: carModel!.image,
  //   );
  //
  //   FirebaseFirestore.instance
  //       .collection('cars')
  //       .doc(userModel.uId)
  //       .update(carmodel.toMap())
  //       .then((value) {
  //     getCarData();
  //     emit(AdminCarUpdateSuccessState());
  //   }).catchError((error) {
  //     emit(AdminCarUpdateErrorState());
  //   });
  // }
  //
  // Visit Profile Methods
  late CarpoolingUserModel profileOwner;
  List<PostModel> visitposts = [];


  void getVisitPosts() {
    visitposts.clear();
    FirebaseFirestore.instance.collection('posts').get().then((value) {
      value.docs.forEach((element) {
        if (element.data()['uId'] == profileOwner.uId)
        {
          visitposts.add(PostModel.fromJson(element.data()));
          print(visitposts.length);
        }
      });
      emit(AdminGetVisitPostsSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(AdminGetVisitPostsErrorState(error.toString()));
    });
  }
  //
  //
  //
  // Get users

  List<CarpoolingUserModel> activeusers = [];
  List<CarpoolingUserModel> blockedusers = [];

  void adminGetUsers() {
    activeusers=[];
    blockedusers=[];
      FirebaseFirestore.instance.collection('users').get().then((value) {
        value.docs.forEach((element) {
          if (element.data()['isEmailVerified'] == true)
            activeusers.add(CarpoolingUserModel.fromJson(element.data()));
          else
            blockedusers.add(CarpoolingUserModel.fromJson(element.data()));
        });

        emit(AdminGetAllUsersSuccessState());
      }).catchError((error) {
        print(error.toString());
        emit(AdminGetAllUsersErrorState(error.toString()));
      });
  }
  List<TripModel>adminTrips=[];
  List<CarpoolingUserModel> tripOwners=[];
  List<CarpoolingCarModel> tripCars=[];
  void adminGetTrips() {
    FirebaseFirestore.instance
        .collection('trips')
        .get()
        .then((event) {
      adminTrips = [];
      tripOwners = [];
      tripCars = [];

      event.docs.forEach((element) {
          adminTrips.add(TripModel.fromJson(element.data()));
          FirebaseFirestore.instance.collection('users').doc( element.data()['uId']).get().then((value) {
            tripOwners.add(CarpoolingUserModel.fromJson(value.data()!));
          }).catchError((error) {
            print(error.toString());
          });


          FirebaseFirestore.instance.collection('cars').doc( element.data()['uId']).get().then((value) {
            tripCars.add(CarpoolingCarModel.fromJson(value.data()!));
          }).catchError((error) {
            print(error.toString());
          });
      });
      emit(AdminGetAllTripsSuccessState());
    });
  }



}