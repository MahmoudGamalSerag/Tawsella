import 'package:carpooling/layout/carpooling_app/admin_cubit/cubit.dart';
import 'package:carpooling/layout/carpooling_app/admin_cubit/states.dart';
import 'package:carpooling/modules/admin/admin_adduser_screen.dart';
import 'package:carpooling/modules/carpooling_app/car/new_car_screen.dart';
import 'package:carpooling/modules/carpooling_app/carpooling_login/carpooling_login_screen.dart';
import 'package:carpooling/modules/carpooling_app/chat_details/chats.dart';
import 'package:carpooling/shared/components/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:carpooling/shared/components/components.dart';
import 'package:carpooling/shared/styles/icon_broken.dart';
import '../../modules/carpooling_app/new_post/new_post_screen.dart';
import 'cubit/cubit.dart';
import 'cubit/states.dart';

class AdminLayout extends StatelessWidget
{
  @override
  Widget build(BuildContext context)
  {
    return BlocConsumer<AdminCubit, AdminStates>(
      listener: (context, state) {
        if(state is AdminAddUserState)
          {
            navigateTo(context, AdminAddUserScreen());
          }
      },
      builder: (context, state)
      {
        var cubit = AdminCubit.get(context);

        return Scaffold(
          appBar: AppBar(
            title: Text(
              cubit.titles[cubit.currentIndex],
            ),
            actions: [
              IconButton(
                icon: Icon(
                  IconBroken.Logout,
                ),
                onPressed: () {
                   navigateAndFinish(context, CarpoolingLoginScreen());
                },
              ),
            ],
          ),
          body: cubit.screens[cubit.currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: cubit.currentIndex,
            onTap: (index)
            {
              cubit.adminchangeBottomNav(index);
            },
            items: [
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.people_alt_sharp,
                ),
                label: 'Users',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  IconBroken.Home,
                ),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.add,
                ),
                label: 'Add User',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.block,
                ),
                label: 'Blocekd',
              ),
            ],
          ),
        );
      },
    );
  }
}