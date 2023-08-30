import 'dart:io';
import 'package:carpooling/models/carpooling_app/address_model.dart';
import 'package:carpooling/models/carpooling_app/carpooling_car_model.dart';
import 'package:carpooling/models/carpooling_app/chatobject.dart';
import 'package:carpooling/models/carpooling_app/message_model.dart';
import 'package:carpooling/models/carpooling_app/post_model.dart';
import 'package:carpooling/models/carpooling_app/request_model.dart';
import 'package:carpooling/models/carpooling_app/trip_model.dart';
import 'package:carpooling/modules/carpooling_app/car/new_car_screen.dart';
import 'package:carpooling/modules/carpooling_app/car/update_car_screen.dart';
import 'package:carpooling/modules/carpooling_app/chat_details/chats.dart';
import 'package:carpooling/modules/carpooling_app/find_trip/find_trip_screen.dart';
import 'package:carpooling/modules/carpooling_app/main/mainscreen.dart';
import 'package:carpooling/shared/components/components.dart';
import 'package:carpooling/shared/components/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:carpooling/layout/carpooling_app/cubit/states.dart';
import 'package:carpooling/modules/carpooling_app/users/users_screen.dart';
import 'package:carpooling/modules/carpooling_app/new_post/new_post_screen.dart';
import 'package:carpooling/modules/carpooling_app/profile/profile_screen.dart';
import '../../../main.dart';
import '../../../models/carpooling_app/carpooling_user_model.dart';
import '../../../shared/network/local/cache_helper.dart';
import 'package:firebase_storage/firebase_storage.dart'as firebase_storage;

class CarpoolingCubit extends Cubit<CarpoolingStates>
{
  CarpoolingCubit() : super(CarpoolingInitialState());

  static CarpoolingCubit get(context) => BlocProvider.of(context);

  late CarpoolingUserModel userModel;
  late AddressModel addressModel;
  late AddressModel dropoff;
  bool dest=false;
  int notifications=0;

  void getUserData() {
    emit(CarpoolingGetUserLoadingState());

    FirebaseFirestore.instance.collection('users').doc( CacheHelper.getData(key: 'uId')).get().then((value) {
      print(value.data());
      userModel = CarpoolingUserModel.fromJson(value.data()!);
      emit(CarpoolingGetUserSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(CarpoolingGetUserErrorState(error.toString()));
    });
  }


  int currentIndex = 0;

  List<Widget> screens = [
    mainscreen(),
    UsersScreen(),
    FindTripScreen(),
    UpdateCarScreen(),
    ProfileScreen(),
  ];

  List<String> titles = [
    'Home',
    'Users',
    'Find Trip',
    'Update Car',
    'Profile',
  ];

  void changeBottomNav(int index) {
    if(index==1)
      getUsers();

     if(index==3&&carModel==null)
      {
        emit(CarpoolingNewCarState());
      }
    else
      {
      currentIndex = index;
      emit(CarpoolingChangeBottomNavState());
      }
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
      emit(CarpoolingProfileImagePickedSuccessState());
    } else {
      print('No image selected.');
      emit(CarpoolingProfileImagePickedErrorState());
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
      emit(CarpoolingCoverImagePickedSuccessState());
    } else {
      print('No image selected.');
      emit(CarpoolingCoverImagePickedErrorState());
    }
  }

  void uploadProfileImage({
    required String name,
    required String phone,
    required String address,
  }) {
    emit(CarpoolingUserUpdateLoadingState());

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
          phone: phone,
          address: address,
          image: value,
        );
      }).catchError((error) {
        emit(CarpoolingUploadProfileImageErrorState());
      });
    }).catchError((error) {
      emit(CarpoolingUploadProfileImageErrorState());
    });
  }

  void uploadCoverImage({
    required String name,
    required String phone,
    required String address,
  }) {
    emit(CarpoolingUserUpdateLoadingState());

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
          phone: phone,
          cover: value,
          address: address,
        );
      }).catchError((error) {
        emit(CarpoolingUploadCoverImageErrorState());
      });
    }).catchError((error) {
      emit(CarpoolingUploadCoverImageErrorState());
    });
  }

  void updateUserImages({
  required String name,
  required String phone,
  required String address,
})
  {
    emit(CarpoolingUserUpdateLoadingState());

    if(coverImage != null)
    {
      uploadCoverImage(name: name,phone: phone,address: address);
    } else if(profileImage != null)
    {
      uploadProfileImage(name: name,phone: phone,address: address);
    } else if (coverImage != null && profileImage != null)
    {

    } else
      {
        updateUser(
          name: name,
          phone: phone,
          address:address,
        );
      }
  }

  void updateUser({
    required String name,
    required String phone,
    required String address,
    String? cover,
    String? image,
  }) {
    emit(CarpoolingUserUpdateLoadingState());
    CarpoolingUserModel model = CarpoolingUserModel(
      name: name,
      phone: phone,
      address: address,
      email: userModel.email,
      cover: cover ?? userModel.cover,
      image: image ?? userModel.image,
      uId: userModel.uId,
      ridertrips: userModel.ridertrips,
      rate: userModel.rate,
      rateNumbers: userModel.rateNumbers,
      drivertrips: userModel.drivertrips,
      isEmailVerified: userModel.isEmailVerified,
    );

    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel.uId)
        .update(model.toMap())
        .then((value) {
      getUserData();
      emit(CarpoolingUserUpdateSuccessState());
    }).catchError((error) {
      emit(CarpoolingUserUpdateErrorState());
    });
  }



  //Car Methods
  CarpoolingCarModel? carModel;
  void getCarData() {
    emit(CarpoolingGetCarLoadingState());
    FirebaseFirestore.instance.collection('cars').doc( CacheHelper.getData(key: 'uId')).get().then((value) {
      print(value.data());
      carModel = CarpoolingCarModel.fromJson(value.data()!);
      emit(CarpoolingGetCarSuccessState());
    }).catchError((error) {
      print("Carrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrr");
      print(error.toString());
      print("Carrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrr");
      emit(CarpoolingGetCarErrorState(error.toString()));
    });
  }

  void createCar({
    required String model,
    required String brand,
    required String license,
    required String userlicense,
  }) {
    emit(CarpoolingCarLoadingState());

    CarpoolingCarModel carmodel = CarpoolingCarModel(
      model:model,
      brand:brand,
      license:license,
      userlicense:userlicense,
      uId:userModel.uId,
      image:'https://iheartcraftythings.com/wp-content/uploads/2021/04/Car-DRAWING-%E2%80%93-STEP-9.jpg',
    );
    FirebaseFirestore.instance
        .collection('cars')
        .doc(userModel.uId)
        .set(carmodel.toMap())
        .then((value) {
      emit(CarpoolingCarSuccessState());
      showToast(text: "Car Added Successfully", state: ToastStates.SUCCESS);
      carModel=carmodel;
    }).catchError((error) {
      emit(CarpoolingCarErrorState());
    });
  }
  void updateCar({
    required String license,
    required String userlicense,
    required String model,
    required String brand,
  }) {
    emit(CarpoolingCarUpdateLoadingState());
    CarpoolingCarModel carmodel = CarpoolingCarModel(
      model: model,
      license: license,
      userlicense: userlicense,
      brand: brand,
      uId: userModel!.uId,
      image: carModel!.image,
    );

    FirebaseFirestore.instance
        .collection('cars')
        .doc(userModel.uId)
        .update(carmodel.toMap())
        .then((value) {
      getCarData();
      emit(CarpoolingCarUpdateSuccessState());
    }).catchError((error) {
      emit(CarpoolingCarUpdateErrorState());
    });
  }

  // Visit Profile Methods
  late CarpoolingUserModel profileOwner;
  void visitprofile(context,widget)
  {
    navigateTo(context, widget);
  }

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
      emit(CarpoolingGetVisitPostsSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(CarpoolingGetVisitPostsErrorState(error.toString()));
    });
  }




  // Post methods


  File ?postImage;

  Future<void> getPostImage() async {
    final pickedFile = await picker.getImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      postImage = File(pickedFile.path);
      emit(CarpoolingPostImagePickedSuccessState());
    } else {
      print('No image selected.');
      emit(CarpoolingPostImagePickedErrorState());
    }
  }

  void removePostImage() {
    postImage = null;
    emit(CarpoolingRemovePostImageState());
  }

  void uploadPostImage({
    required String dateTime,
    required String text,
  }) {
    emit(CarpoolingCreatePostLoadingState());

    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('posts/${Uri.file(postImage!.path).pathSegments.last}')
        .putFile(postImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        print(value);
        createPost(
          text: text,
          dateTime: dateTime,
          postImage: value,
        );
      }).catchError((error) {
        emit(CarpoolingCreatePostErrorState());
      });
    }).catchError((error) {
      emit(CarpoolingCreatePostErrorState());
    });
  }

  void createPost({
    required String dateTime,
    required String text,
    String? postImage,
  }) {
    emit(CarpoolingCreatePostLoadingState());

    PostModel model = PostModel(
      name: userModel.name,
      image: userModel.image,
      uId: userModel.uId,
      dateTime: dateTime,
      text: text,
      postImage: postImage ?? '',
    );

    FirebaseFirestore.instance
        .collection('posts')
        .add(model.toMap())
        .then((value) {
      emit(CarpoolingCreatePostSuccessState());
    }).catchError((error) {
      emit(CarpoolingCreatePostErrorState());
    });
  }

  List<PostModel> posts = [];
  List<PostModel> postsrev = [];
  List<int> likes = [];

  void getPosts() {
    posts=[];
    postsrev=[];
    FirebaseFirestore.instance.collection('posts').orderBy('dateTime').get().then((value) {
      value.docs.forEach((element) {
        if (element.data()['uId'] == userModel.uId)
        postsrev.add(PostModel.fromJson(element.data()));
      });
      posts=postsrev.reversed.toList();
      emit(CarpoolingGetPostsSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(CarpoolingGetPostsErrorState(error.toString()));
    });
  }



  // Get users

  List<CarpoolingUserModel> users = [];

  void getUsers() {
    users=[];
    if (users.length == 0)
      FirebaseFirestore.instance.collection('users').get().then((value) {
        value.docs.forEach((element) {
          if (element.data()['uId'] != userModel.uId)
            users.add(CarpoolingUserModel.fromJson(element.data()));
        });

        emit(CarpoolingGetAllUsersSuccessState());
      }).catchError((error) {
        print(error.toString());
        emit(CarpoolingGetAllUsersErrorState(error.toString()));
      });
  }





  //Messages mothods
  List<CarpoolingUserModel> chats = [];
  List<CarpoolingChatObjectModel> chatsobj = [];
  List<CarpoolingUserModel> chatsrev = [];
  List<CarpoolingChatObjectModel> chatsrevobj = [];

  void getChats()
  {
   //if (chats.length == 0)
    chats =[];
    chatsobj =[];
    chatsrev=[];
    chatsrevobj=[];
    FirebaseFirestore.instance
        .collection('users')
        .doc(CacheHelper.getData(key: 'uId'))
        .collection('chats')
        .orderBy('dateTime')
        .get()
        .then((value) {
      value.docs.forEach((element) {
        chatsrevobj.add(CarpoolingChatObjectModel.fromJson(element.data()!));
        FirebaseFirestore.instance
            .collection('users')
            .doc(element.data()['uId'])
            .snapshots()
            .listen((value) {
       //   print(value.data());
          chatsrev.add( CarpoolingUserModel.fromJson(value.data()!));

          chats=chatsrev.reversed.toList();
          chatsobj=chatsrevobj.reversed.toList();
        });
      });

      emit(CarpoolingGetChatersSuccessState());
    }).catchError((error) {
      emit(CarpoolingGetChatersErrorState());
    });
  }

  void sendMessage({
    required String receiverId, required String dateTime, required String text,
  }) {
    MessageModel model = MessageModel(
      text: text,
      senderId: userModel.uId,
      receiverId: receiverId,
      dateTime: dateTime,
    );
    makechatobject(receiverId: receiverId,dateTime: dateTime);
    // set my chats
    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel.uId)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .add(model.toMap())
        .then((value) {
      emit(CarpoolingSendMessageSuccessState());
      getChats();
    }).catchError((error) {
      emit(CarpoolingSendMessageErrorState());
    });

    // set receiver chats

    FirebaseFirestore.instance
        .collection('users')
        .doc(receiverId)
        .collection('chats')
        .doc(userModel.uId)
        .collection('messages')
        .add(model.toMap())
        .then((value) {
      emit(CarpoolingSendMessageSuccessState());
    }).catchError((error) {
      emit(CarpoolingSendMessageErrorState());
    });
  }
  void makechatobject({
    required String receiverId,
    required String dateTime,
})
  {
    CarpoolingChatObjectModel sender=CarpoolingChatObjectModel(uId: userModel.uId,dateTime: dateTime);
    CarpoolingChatObjectModel reciver=CarpoolingChatObjectModel(uId: receiverId,dateTime:dateTime);
    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel.uId)
        .collection('chats')
        .doc(receiverId)
        .set(reciver.toMap())
        .then((value)
    {
      emit(CarpoolingSenderSuccessState());
    })
        .catchError((error) {
      print(error.toString());
      emit(CarpoolingSenderErrorState());
    });

    FirebaseFirestore.instance
        .collection('users')
        .doc(receiverId)
        .collection('chats')
        .doc(userModel.uId)
        .set(sender.toMap())
        .then((value)
    {
      emit(CarpoolingReceiverSuccessState());
    })
        .catchError((error) {
      print(error.toString());
      emit(CarpoolingReceiverErrorState());
    });
  }

  List<MessageModel> messages = [];

  void getMessages({
    required String receiverId,
  }) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel.uId)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .orderBy('dateTime')
        .snapshots()
        .listen((event) {
      messages = [];

      event.docs.forEach((element) {
        messages.add(MessageModel.fromJson(element.data()));
      });

      emit(CarpoolingGetMessagesSuccessState());
    });
 }

 //Rate Methods
void rate(int rating)
{
  profileOwner.rate+=rating;
  profileOwner.rateNumbers+=1;
  FirebaseFirestore.instance
      .collection('users')
      .doc(profileOwner.uId)
      .update(profileOwner.toMap())
      .then((value) {
    emit(CarpoolingUserUpdateSuccessState());
  }).catchError((error) {
    emit(CarpoolingUserUpdateErrorState());
  });
}
void prelogin()
{
  clearlist();
  if(users.length==0)
    {
      getUsers();
    }
  getUserData();
  if(chats.length==0)
    {
      getChats();
    }
  if(posts.length==0)
  {
    getPosts();
  }
  getCarData();
  getTrips();
  getMyTrip();
  emit(CarpoolingPreLoginSuccessState());
}
void clearlist()
{
  carModel=null;
  posts.clear();
  postsrev.clear();
  chats.clear();
  chatsobj.clear();
  chatsrev.clear();
  chatsrevobj.clear();
  users.clear();
  trips.clear();
  tripOwners.clear();
  tripCars.clear();
  requestsrev.clear();
  requests.clear();
  notifications=0;
}
//Trip Methods


late AddressModel tripInitial;
late AddressModel tripFinish;
late TripModel tripModel;
String? tripId;

void viewTrip()
{
  emit(CarpoolingViewTripState());
}


  void tripCreate({
    required String startName,
    required double startLatitude,
    required double startLongitude,
    required String finishName,
    required double finishLatitude,
    required double finishLongitude,
    required String dateTime,
    required int freeSeats,
  }) {
    TripModel model = TripModel(
        uId: userModel.uId,
        startName: startName,
        startLatitude: startLatitude,
        startLongitude: startLongitude,
        finishName: finishName,
        finishLatitude: finishLatitude,
        finishLongitude: finishLongitude,
        freeSeats: freeSeats,
        dateTime: dateTime,
        isActive: true
    );

    FirebaseFirestore.instance
        .collection('trips')
        .add(model.toMap())
        .then((value)
    {
      emit(CarpoolingMakeTripSuccessStateState());
    })
        .catchError((error) {
          emit(CarpoolingMakeTripErrorStateState());
      print(error.toString());
    });
  }

  List<TripModel> trips=[];
  List<CarpoolingUserModel> tripOwners=[];
  List<CarpoolingCarModel> tripCars=[];
  void getTrips() {
        FirebaseFirestore.instance
            .collection('trips')
            .get()
            .then((event) {
          trips = [];
          tripOwners = [];
          tripCars = [];

          event.docs.forEach((element) {

            if(element.data()['uId']!=userModel.uId&&element.data()['freeSeats']>0&&element.data()['isActive']==true) {
              trips.add(TripModel.fromJson(element.data()));
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

            }
          });
          print(trips.length);
          emit(CarpoolingGetTripsSuccessState());
        });
  }

  void getMyTrip()
  {
    tripId=null;
    FirebaseFirestore.instance.collection('trips').get().then((value) {
      value.docs.forEach((element) {
        if(element.data()['uId']==CacheHelper.getData(key: 'uId')&&element.data()['isActive']==true)
          {
            tripModel=TripModel.fromJson(element.data());
            tripId=element.id;
            print(element.data());
            print(element.id);
            print('sssssssssssssssssssssssssssssssssssssss');
          }
      });
    }).catchError((error) {
      print(error.toString());
      print('aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa');
    });
  }
  void updateTrip()
  {

    FirebaseFirestore.instance
        .collection('trips')
        .doc(tripId)
        .update(tripModel.toMap())
        .then((value) {
      getMyTrip();
      emit(CarpoolingTripUpdateSuccessState());
    }).catchError((error) {
      emit(CarpoolingTripUpdateErrorState());
    });
  }
  void endTrip()
  {
    tripModel.isActive=false;
    updateTrip();
  }

  // floatActionuttom
  bool isButtonSheetShown = false;
  IconData fabIcon = Icons.add;

  void ChangeBottomSheetState({required bool isShow , required IconData icon})
  {
    isButtonSheetShown = isShow;
    fabIcon = icon;

    emit(CarpoolingChangeBottomSheetState());
  }

  // Request Methods
  late RequestModel requestModel;
  void sendRequest({
    required String receiverId,
    required String dateTime,
    required String type,
    String senderFinish='.',
    String senderStart='.',
  })
  {
    if(type=='request')
      {
        senderStart=addressModel.PlaceName;
        senderFinish=dropoff.PlaceName;
      }
    RequestModel model = RequestModel(
        type: type,
        senderId: userModel.uId,
        receiverId: receiverId,
        dateTime: dateTime,
        read: false,
      senderImage: userModel.image,
      sendername: userModel.name,
      senderStart: senderStart,
      senderFinish: senderFinish,
    );
    FirebaseFirestore.instance
        .collection('users')
        .doc(receiverId)
        .collection('requests')
        .add(model.toMap())
        .then((value) {
      emit(CarpoolingSendRequestSuccessState());
    }).catchError((error) {
      emit(CarpoolingSendRequestErrorState());
    });
  }

  List<RequestModel>requests=[];
  List<RequestModel>requestsrev=[];
  List<String>requestsId=[];
  List<String>requestsrevId=[];

  void getRequests() {
    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel.uId)
        .collection('requests')
        .orderBy('dateTime')
        .snapshots()
        .listen((event) {
      requestsrev = [];
      event.docs.forEach((element) {
        if(element.data()['read']==false) {
          requestsrev.add(RequestModel.fromJson(element.data()));
          requestsrevId.add(element.id);
        }
      });
      if(notifications!=requestsrev.length) {
        requests=requestsrev.reversed.toList();
        requestsId=requestsrevId.reversed.toList();
        notifications = requests.length;
        emit(CarpoolingGetRequestsSuccessState());
      }

    });
  }
  void rejectRequest(int index)
  {
    requests[index].read=true;
    String recevierId=requests[index].senderId;
    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel.uId)
        .collection('requests')
        .doc(requestsId[index])
        .set(requests[index].toMap())
        .then((value)
    {
      emit(CarpoolingRejectSuccessState());
      sendRequest(receiverId: recevierId, dateTime: DateTime.now().toString(),type: 'reject');
    })
        .catchError((error) {
      print(error.toString());
      emit(CarpoolingRejectErrorState());
    });
  }
  void acceptRequest(int index)
  {
    requests[index].read=true;
    String recevierId=requests[index].senderId;
    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel.uId)
        .collection('requests')
        .doc(requestsId[index])
        .set(requests[index].toMap())
        .then((value)
    {
      emit(CarpoolingRejectSuccessState());
      sendRequest(receiverId: recevierId, dateTime: DateTime.now().toString(),type: 'accept');
      sendMessage(receiverId: recevierId, dateTime: DateTime.now().toString(), text: 'lets start the trip');
      tripModel.freeSeats--;
      updateTrip();
    })
        .catchError((error) {
      print(error.toString());
      emit(CarpoolingRejectErrorState());
    });
  }
  void seen(int index)
  {
    requests[index].read=true;
    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel.uId)
        .collection('requests')
        .doc(requestsId[index])
        .set(requests[index].toMap())
        .then((value)
    {
      emit(CarpoolingRequestSeenSuccessState());
    })
        .catchError((error) {
      print(error.toString());
      emit(CarpoolingRequestSeenErrorState());
    });
  }

}