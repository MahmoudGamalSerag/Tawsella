import 'package:carpooling/modules/carpooling_app/car/new_car_screen.dart';
import 'package:carpooling/modules/carpooling_app/chat_details/chats.dart';
import 'package:carpooling/modules/carpooling_app/notifications/notifications_screen.dart';
import 'package:carpooling/shared/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:carpooling/shared/components/components.dart';
import 'package:carpooling/shared/styles/icon_broken.dart';
import '../../modules/carpooling_app/new_post/new_post_screen.dart';
import 'cubit/cubit.dart';
import 'cubit/states.dart';

class CarpoolingLayout extends StatelessWidget
{
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  var startController = TextEditingController();
  var endController = TextEditingController();
  var seatsController = TextEditingController();
  @override
  Widget build(BuildContext context)
  {
    return BlocConsumer<CarpoolingCubit, CarpoolingStates>(
      listener: (context, state) {
        if(state is CarpoolingMakeTripSuccessStateState)
        {
          Navigator.pop(context);
          showToast(text: 'Trip Created', state: ToastStates.SUCCESS);
        }
        if (state is CarpoolingNewPostState) {
          navigateTo(
            context,
            NewPostScreen(),
          );

        }
        else if(state is CarpoolingNewCarState)
        {
          navigateTo(
            context,
            NewCarScreen(),
          );
        }
      },
      builder: (context, state)
      {
        var cubit = CarpoolingCubit.get(context);
        try{
          cubit.getRequests();
        }
        catch(ex){}
        return Scaffold(
          key: scaffoldKey,
          appBar: AppBar(
            title: Text(
              cubit.titles[cubit.currentIndex],
            ),
            actions: [
                IconButton(
                  icon: Icon(
                    IconBroken.Chat,
                    size: 28,
                  ),
                  onPressed: () {
                    navigateTo(context, ChatsScreen());
                  },
                ),
              Padding(
                padding: const EdgeInsets.only(right: 10,top: 8,bottom: 8),
                child: Stack(
                  alignment: Alignment.topRight,
                  children: [
                    IconButton(
                      icon: Icon(
                        IconBroken.Notification,
                        size: 28,
                      ),
                      onPressed: () {
                        navigateTo(context, NotificationsScreen());
                      },
                    ),
                    if(cubit.notifications>0)
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.red,
                          radius: 10,
                        ),
                        Text('${cubit.notifications}')
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          body: cubit.screens[cubit.currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: cubit.currentIndex,
            onTap: (index)
            {
              cubit.changeBottomNav(index);
            },
            items: [
              BottomNavigationBarItem(
                icon: Icon(
                  IconBroken.Home,
                ),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.people_alt_sharp,
                ),
                label: 'Users',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.search,
                ),
                label: 'Find Trip',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.local_taxi,
                ),
                label: 'Car',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.person,
                ),
                label: 'Profile',
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: ()
            {
              try{
                if(cubit.carModel==null)
                  {
                    showToast(text: 'you should have car to make trip', state: ToastStates.WARNING);
                    return;
                  }
              }
              catch(ex)
              {
                showToast(text: 'you should have car to make trip', state: ToastStates.WARNING);
                return;
              }
              if(CarpoolingCubit.get(context).dest==false&&cubit.tripId==null)
              {
                showToast(text: 'please put destination', state: ToastStates.WARNING);
                return;
              }
              if(cubit.isButtonSheetShown&&cubit.tripId==null)
              {
                if (formKey.currentState!.validate())
                {
                  CarpoolingCubit.get(context).tripCreate(
                    startName: CarpoolingCubit.get(context).addressModel.PlaceName,
                    startLatitude: CarpoolingCubit.get(context).addressModel.latitude,
                    startLongitude: CarpoolingCubit.get(context).addressModel.longitude,
                    finishName: CarpoolingCubit.get(context).dropoff.PlaceName,
                    finishLatitude: CarpoolingCubit.get(context).dropoff.latitude,
                    finishLongitude: CarpoolingCubit.get(context).dropoff.longitude,
                    dateTime:DateTime.now().toString(),
                    freeSeats:int.parse(seatsController.text),
                  );
                  var userModel=cubit.userModel;
                  cubit.userModel.drivertrips++;
                  cubit.updateUser(name: userModel.name, phone: userModel.phone, address: userModel.address);
                  cubit.getMyTrip();
                }

              }
              else if(cubit.tripId!=null)
              {
                startController.text=CarpoolingCubit.get(context).tripModel.startName;
                endController.text=CarpoolingCubit.get(context).tripModel.finishName;
                seatsController.text=CarpoolingCubit.get(context).tripModel.freeSeats.toString();
                scaffoldKey.currentState?.showBottomSheet((context) => Padding(
                  padding: const EdgeInsets.all(.20),
                  child: Form(
                    key: formKey,
                    child: Container(
                      color: backColor,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          defaultFormField(
                            controller: startController,
                            type: TextInputType.text,
                            validate: (String value) {
                              if (value.isEmpty) {
                                return 'Start point must not be empty';
                              }

                              return null;
                            },
                            label: 'Start point',
                            prefix: IconBroken.Location,
                          ),
                          SizedBox(height: 15.0,),
                          defaultFormField(
                            controller: endController,
                            type: TextInputType.text,
                            validate: (String value) {
                              if (value.isEmpty) {
                                return 'Destination must not be empty';
                              }

                              return null;
                            },
                            label: 'Destination',
                            prefix: IconBroken.Location,
                          ),
                          SizedBox(height: 15.0,),
                          defaultFormField(
                            controller: seatsController,
                            type: TextInputType.number,
                            validate: (String value) {
                              if (value.isEmpty) {
                                return 'Free Seats must not be empty';
                              }

                              return null;
                            },
                            label: 'Free Seats',
                            prefix: Icons.chair,
                          ),
                          SizedBox(height: 15.0,),
                          defaultButton(function: (){
                            cubit.endTrip();
                            cubit.ChangeBottomSheetState(isShow: false, icon: Icons.add);
                            seatsController.clear();
                            endController.clear();
                            startController.clear();
                            showToast(text: 'trip finished', state: ToastStates.WARNING);
                            }, text: 'end trip',background: Colors.red)
                        ],
                      ),
                    ),
                  ),
                ))
                    .closed.then((value) {
                  cubit.ChangeBottomSheetState(
                      isShow: false,
                      icon: Icons.add
                  );

                });
                cubit.ChangeBottomSheetState(
                    isShow: true,
                    icon: Icons.lock_clock);
              }
              else {
                startController.text=CarpoolingCubit.get(context).addressModel.PlaceName;
                endController.text=CarpoolingCubit.get(context).dropoff.PlaceName;
                scaffoldKey.currentState?.showBottomSheet((context) => Padding(
                  padding: const EdgeInsets.all(.20),
                  child: Form(
                    key: formKey,
                    child: Container(
                      color: backColor,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          defaultFormField(
                            controller: startController,
                            type: TextInputType.text,
                            validate: (String value) {
                              if (value.isEmpty) {
                                return 'Start point must not be empty';
                              }

                              return null;
                            },
                            label: 'Start point',
                            prefix: IconBroken.Location,
                          ),
                          SizedBox(height: 15.0,),
                          defaultFormField(
                            controller: endController,
                            type: TextInputType.text,
                            validate: (String value) {
                              if (value.isEmpty) {
                                return 'Destination must not be empty';
                              }

                              return null;
                            },
                            label: 'Destination',
                            prefix: IconBroken.Location,
                          ),
                          SizedBox(height: 15.0,),
                          defaultFormField(
                            controller: seatsController,
                            type: TextInputType.number,
                            validate: (String value) {
                              if (value.isEmpty) {
                                return 'Free Seats must not be empty';
                              }

                              return null;
                            },
                            label: 'Free Seats',
                            prefix: Icons.chair,
                          ),
                          SizedBox(height: 15.0,)
                        ],
                      ),
                    ),
                  ),
                ))
                    .closed.then((value) {
                  cubit.ChangeBottomSheetState(
                      isShow: false,
                      icon: Icons.add
                  );

                });
                cubit.ChangeBottomSheetState(
                    isShow: true,
                    icon: Icons.check);
              }

            },
            child: Icon(cubit.fabIcon),
          ),

        );
      },
    );
  }
}