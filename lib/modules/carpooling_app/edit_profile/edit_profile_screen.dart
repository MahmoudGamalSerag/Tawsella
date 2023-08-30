import 'dart:io';

import 'package:carpooling/layout/carpooling_app/cubit/cubit.dart';
import 'package:carpooling/layout/carpooling_app/cubit/states.dart';
import 'package:carpooling/modules/carpooling_app/carpooling_login/carpooling_login_screen.dart';
import 'package:carpooling/shared/components/components.dart';
import 'package:carpooling/shared/components/constants.dart';
import 'package:carpooling/shared/styles/icon_broken.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
class EditProfileScreen extends StatelessWidget {
  var nameController = TextEditingController();
  var phoneController = TextEditingController();
  var addressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CarpoolingCubit, CarpoolingStates>(
      listener: (context, state) {
        if(state is CarpoolingUserUpdateSuccessState)
        {
          showToast(text: "Updated", state: ToastStates.SUCCESS);
        }
      },
      builder: (context, state) {
         var userModel = CarpoolingCubit.get(context).userModel;
         var profileImage = CarpoolingCubit.get(context).profileImage;
         var coverImage = CarpoolingCubit.get(context).coverImage;

        nameController.text = userModel.name;
        phoneController.text = userModel.phone;
        addressController.text = userModel.address;

        return Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(60),
            child: defaultAppBar(
              context: context,
              title: 'Edit Profile',
              actions: [
                defaultTextButton(
                  function: () {
                    if(nameController.text.length==0)
                    {
                      showToast(text: "name cant be empty", state: ToastStates.ERROR);
                    }
                    else if(phoneController.text.length==0)
                    {
                      showToast(text: "phone cant be empty", state: ToastStates.ERROR);
                    }
                    else if(addressController.text.length==0)
                    {
                      showToast(text: "address cant be empty", state: ToastStates.ERROR);
                    }
                    else
                    {
                      CarpoolingCubit.get(context).updateUser(
                          name: nameController.text,
                          phone: phoneController.text,
                          address: addressController.text);}
                  },
                  text: 'Update',
                ),
                SizedBox(
                  width: 15.0,
                ),
              ],
            ),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  if (state is CarpoolingUserUpdateLoadingState)
                    LinearProgressIndicator(),
                  if (state is CarpoolingUserUpdateLoadingState)
                    SizedBox(
                      height: 10.0,
                    ),
                  Container(
                    height: 190.0,
                    child: Stack(
                      alignment: AlignmentDirectional.bottomCenter,
                      children: [
                        Align(
                          child: Stack(
                            alignment: AlignmentDirectional.topEnd,
                            children: [
                              Container(
                                height: 140.0,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(
                                      4.0,
                                    ),
                                    topRight: Radius.circular(
                                      4.0,
                                    ),
                                  ),
                                 image: DecorationImage(
                                    image: NetworkImage(
                                            '${userModel.cover}',
                                          )
                                        ,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          alignment: AlignmentDirectional.topCenter,
                        ),
                        Stack(
                          alignment: AlignmentDirectional.bottomEnd,
                          children: [
                            CircleAvatar(
                              radius: 64.0,
                              backgroundColor:
                                  Theme.of(context).scaffoldBackgroundColor,
                              child: CircleAvatar(
                                radius: 60.0,
                                backgroundImage:  NetworkImage(
                                        '${userModel.image}',
                                      ),

                              ),
                            ),
                            IconButton(
                              icon: CircleAvatar(
                                radius: 20.0,
                                child: Icon(
                                  IconBroken.Camera,
                                  size: 16.0,
                                ),
                              ),
                              onPressed: () {
                                CarpoolingCubit.get(context).getProfileImage();
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  if (CarpoolingCubit.get(context).profileImage != null ||
                      CarpoolingCubit.get(context).coverImage != null)
                    Row(
                      children: [
                        if (CarpoolingCubit.get(context).profileImage != null)
                          Expanded(
                            child: Column(
                              children: [
                                defaultButton(
                                  function: () {
                                    if(nameController.text.length==0)
                                      {
                                        showToast(text: "name cant be empty", state: ToastStates.ERROR);
                                      }
                                    else if(phoneController.text.length==0)
                                    {
                                      showToast(text: "phone cant be empty", state: ToastStates.ERROR);
                                    }
                                    else if(addressController.text.length==0)
                                    {
                                      showToast(text: "address cant be empty", state: ToastStates.ERROR);
                                    }
                                    else
                                      {
                                    CarpoolingCubit.get(context).uploadProfileImage(
                                      name: nameController.text,
                                      phone: phoneController.text,
                                      address: addressController.text,
                                    );}
                                  },
                                  text: 'Update Profile',
                                ),
                                if (state is CarpoolingUserUpdateLoadingState)
                                  SizedBox(
                                  height: 5.0,
                                ),
                                if (state is CarpoolingUserUpdateLoadingState)
                                  LinearProgressIndicator(),
                              ],
                            ),
                          ),
                        SizedBox(
                          width: 5.0,
                        ),
                        if (CarpoolingCubit.get(context).coverImage != null)
                          Expanded(
                            child: Column(
                              children: [
                                defaultButton(
                                  function: ()
                                  {
                                    CarpoolingCubit.get(context).uploadCoverImage(
                                      name: nameController.text,
                                      phone: phoneController.text,
                                      address: addressController.text,
                                    );
                                  },
                                  text: 'upload cover',
                                ),
                                if (state is CarpoolingUserUpdateLoadingState)
                                  SizedBox(
                                  height: 5.0,
                                ),
                                if (state is CarpoolingUserUpdateLoadingState)
                                  LinearProgressIndicator(),
                              ],
                            ),
                          ),
                      ],
                    ),
                  if (CarpoolingCubit.get(context).profileImage != null ||
                      CarpoolingCubit.get(context).coverImage != null)
                    SizedBox(
                      height: 20.0,
                    ),
                  defaultFormField(
                    controller: nameController,
                    type: TextInputType.name,
                    validate: (String value) {
                      if (value.isEmpty) {
                        return 'name must not be empty';
                      }

                      return null;
                    },
                    label: 'Name',
                    prefix: IconBroken.User,
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  defaultFormField(
                    controller: addressController,
                    type: TextInputType.text,
                    validate: (String value) {
                      if (value.isEmpty) {
                        return 'address must not be empty';
                      }

                      return null;
                    },
                    label: 'Address',
                    prefix: IconBroken.Home,
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  defaultFormField(
                    controller: phoneController,
                    type: TextInputType.phone,
                    validate: (String value) {
                      if (value.isEmpty) {
                        return 'phone number must not be empty';
                      }

                      return null;
                    },
                    label: 'Phone',
                    prefix: IconBroken.Call,
                  ),
                  SizedBox(height:30,),
                  defaultButton(function: ()
                  {
                    signOut(context);
                   // navigateAndFinish(context, CarpoolingLoginScreen());
                  },
                      text: "Logout",
                      background: Colors.grey),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
