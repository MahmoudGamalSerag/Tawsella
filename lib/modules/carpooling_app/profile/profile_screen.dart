import 'package:carpooling/models/carpooling_app/carpooling_user_model.dart';
import 'package:carpooling/models/carpooling_app/post_model.dart';
import 'package:carpooling/modules/carpooling_app/new_post/new_post_screen.dart';
import 'package:carpooling/shared/styles/colors.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../layout/carpooling_app/cubit/cubit.dart';
import '../../../layout/carpooling_app/cubit/states.dart';
import '../../../shared/components/components.dart';
import '../../../shared/styles/icon_broken.dart';
import '../edit_profile/edit_profile_screen.dart';


class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CarpoolingCubit, CarpoolingStates>(
      listener: (context, state) {},
      builder: (context, state) {
        double rating=0;
        var userModel = CarpoolingCubit.get(context).userModel;
        if(userModel.rateNumbers>0)
        {
          rating=userModel.rate.toDouble()/userModel.rateNumbers.toDouble();
        }
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Container(
                  height: 190.0,
                  child: Stack(
                    alignment: AlignmentDirectional.bottomCenter,
                    children: [
                      Align(
                        child: Container(
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
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        alignment: AlignmentDirectional.topCenter,
                      ),
                      CircleAvatar(
                        radius: 64.0,
                        backgroundColor:
                        Colors.white,
                        child: CircleAvatar(
                          radius: 60.0,
                          backgroundImage: NetworkImage(
                            '${userModel.image}',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 5.0,
                ),
                Text(
                  '${userModel.name}',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 20.0,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          child: Column(
                            children: [
                              Text(
                                '${userModel.drivertrips}',
                                style: Theme.of(context).textTheme.subtitle2,
                              ),
                              Text(
                                'Driver trips',
                                style: Theme.of(context).textTheme.caption,
                              ),
                            ],
                          ),
                          onTap: () {},
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          child: Column(
                            children: [
                              Text(
                                '${userModel.ridertrips}',
                                style: Theme.of(context).textTheme.subtitle2,
                              ),
                              Text(
                                'Rider Trips',
                                style: Theme.of(context).textTheme.caption,
                              ),
                            ],
                          ),
                          onTap: () {},
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '${rating}',
                                    style: Theme.of(context).textTheme.subtitle2,
                                  ),
                                  Icon(Icons.star,color: Colors.amber,),
                                ],
                              ),
                              Text(
                                'Rate',
                                style: Theme.of(context).textTheme.caption,
                              ),
                            ],
                          ),
                          onTap: () {},
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: defaultColor)
                        ),
                        onPressed: () {
                          navigateTo(
                            context,
                            NewPostScreen(),
                          );
                        },
                        child: Text(
                          'Add post',
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    OutlinedButton(
                      onPressed: () {
                        navigateTo(
                          context,
                          EditProfileScreen(),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                          side: BorderSide(color: defaultColor)
                      ),
                      child: Icon(
                        IconBroken.Edit,
                        size: 16.0,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 50.0),
                ConditionalBuilder(
                  condition: CarpoolingCubit.get(context).posts.length > 0 && CarpoolingCubit.get(context).userModel != null,
                  builder: (context) => SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Column(
                      children:
                      [
                        ListView.separated(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) => buildPostItem(CarpoolingCubit.get(context).posts[index],userModel,context, index),
                          separatorBuilder: (context, index) => SizedBox(
                            height: 8.0,
                          ),
                          itemCount: CarpoolingCubit.get(context).posts.length,
                        ),
                        SizedBox(
                          height: 8.0,
                        ),
                      ],
                    ),
                  ),
                  fallback: (context) => Center(child: Text('No Posts Yet',style: TextStyle(fontSize: 40.0,color: Colors.grey),)),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
Widget buildPostItem(PostModel model,CarpoolingUserModel userModel, context, index) => Card(
  shape: RoundedRectangleBorder(
    side: BorderSide(
      color: Colors.white10,
    ),
    borderRadius: const BorderRadius.all(Radius.circular(12)),
  ),
  color: backColor,
  clipBehavior: Clip.antiAliasWithSaveLayer,
  elevation: 5.0,
  margin: EdgeInsets.symmetric(
    horizontal: 8.0,
  ),
  child: Padding(
    padding: const EdgeInsets.all(10.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 25.0,
              backgroundImage: NetworkImage(
                '${userModel.image}',
              ),
            ),
            SizedBox(
              width: 15.0,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        '${userModel.name}',
                        style: TextStyle(
                          height: 1.4,
                          color: textColor
                        ),
                      ),
                      SizedBox(
                        width: 5.0,
                      ),
                      // Icon(
                      //   Icons.check_circle,
                      //   color: defaultColor,
                      //   size: 16.0,
                      // ),
                    ],
                  ),
                  Text(
                    '${model.dateTime.substring(0,10)}',
                    style: Theme.of(context).textTheme.caption!.copyWith(
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 15.0,
            ),
            IconButton(
              icon: Icon(
                Icons.more_horiz,
                size: 16.0,
                color: textColor,
              ),
              onPressed: () {},
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 15.0,
          ),
          child: Container(
            width: double.infinity,
            height: 1.0,
            color: Colors.grey[300],
          ),
        ),
        Text(
          '${model.text}',
          style: Theme.of(context).textTheme.subtitle1,
        ),

        if(model.postImage != '')
          Padding(
            padding: const EdgeInsetsDirectional.only(
                top: 15.0
            ),
            child: Container(
              height: 140.0,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  4.0,
                ),
                image: DecorationImage(
                  image: NetworkImage(
                    '${model.postImage}',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
      ],
    ),
  ),
);