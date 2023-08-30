import 'package:carpooling/layout/carpooling_app/admin_cubit/cubit.dart';
import 'package:carpooling/layout/carpooling_app/admin_layout.dart';
import 'package:carpooling/layout/carpooling_app/carpooling_layout.dart';
import 'package:carpooling/shared/components/constants.dart';
import 'package:carpooling/shared/network/local/cache_helper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:carpooling/modules/carpooling_app/carpooling_login/carpooling_login_screen.dart';
import 'package:carpooling/shared/bloc_observer.dart';
import 'package:carpooling/shared/cubit/cubit.dart';
import 'package:carpooling/shared/cubit/states.dart';
import 'package:carpooling/shared/styles/themes.dart';

import 'layout/carpooling_app/cubit/cubit.dart';
import 'modules/carpooling_app/carpooling_register/carpooling_register_screen.dart';

void main() async
{
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  Bloc.observer = MyBlocObserver();
   await CacheHelper.init();
  // bool isDark = CacheHelper.getData(key: 'isDark');

  Widget widget;


 try{ uId = CacheHelper.getData(key: 'uId')!;}
 catch(ex){}


  if(uId != null)
  {
    widget = CarpoolingLayout();
  } else
  {
    widget = CarpoolingLoginScreen();
  }

  runApp(MyApp(
    // isDark: isDark,
     startWidget: widget,
  ));
}
late String userid;
bool loged=false;

// Stateless
// Stateful

// class MyApp

class MyApp extends StatelessWidget
{
  // constructor
  // build
  // bool? isDark;
   Widget? startWidget;

  MyApp(
           {
      //   this.isDark,
         this.startWidget,
       }
      );

  @override
  Widget build(BuildContext context)
  {
    return MultiBlocProvider(
      providers: [

        BlocProvider(
            create: (BuildContext context) => AppCubit()
        ),
        BlocProvider(
            create: (BuildContext context) => AdminCubit()..adminGetUsers()..adminGetTrips()
        ),

        BlocProvider(
            create: (BuildContext context) => CarpoolingCubit()..prelogin()
        ),
      ],
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: ThemeMode.dark,
            home: startWidget,
          );
        },
      ),
    );
  }
}