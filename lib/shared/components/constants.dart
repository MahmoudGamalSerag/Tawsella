// POST
// UPDATE
// DELETE

// GET

// base url : https://newsapi.org/
// method (url) : v2/top-headlines?
// queries : country=eg&category=business&apiKey=65f7f556ec76449fa7dc7c0069f040ca

// https://newsapi.org/v2/everything?q=tesla&apiKey=65f7f556ec76449fa7dc7c0069f040ca


import 'package:carpooling/layout/carpooling_app/cubit/cubit.dart';
import 'package:carpooling/modules/carpooling_app/carpooling_login/carpooling_login_screen.dart';
import 'package:carpooling/shared/network/local/cache_helper.dart';

import 'components.dart';

void signOut(context)
{
  CacheHelper.removeData(
    key: 'uId',
  ).then((value)
  {
    if (value)
    {
      CarpoolingCubit.get(context).clearlist();
      navigateAndFinish(
        context,
        CarpoolingLoginScreen(),
      );
    }
  });
}

void printFullText(String text) {
  final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
  pattern.allMatches(text).forEach((match) => print(match.group(0)));
}

String token = '';

String? uId;
String apiKey="AIzaSyC_z94VM2FCMAuxACRdM_c1u3q-ycNhGjA";