import 'package:carpooling/layout/carpooling_app/cubit/cubit.dart';
import 'package:carpooling/layout/carpooling_app/cubit/states.dart';
import 'package:carpooling/models/carpooling_app/carpooling_user_model.dart';
import 'package:carpooling/modules/carpooling_app/visit_profile/visit_profile_screen.dart';
import 'package:carpooling/shared/components/components.dart';
import 'package:carpooling/shared/styles/colors.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
class UsersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CarpoolingCubit, CarpoolingStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return ConditionalBuilder(
          condition: CarpoolingCubit.get(context).users.length > 0,
          builder: (context) => ListView.separated(
            physics: BouncingScrollPhysics(),
            itemBuilder: (context, index) =>
                buildUserItem(CarpoolingCubit.get(context).users[index], context),
            separatorBuilder: (context, index) => myDivider(),
            itemCount: CarpoolingCubit.get(context).users.length,
          ),
          fallback: (context) => Center(child: CircularProgressIndicator()),
        );
      },
    );
  }

  Widget buildUserItem(CarpoolingUserModel model, context) => InkWell(
        onTap: () {
          CarpoolingCubit.get(context).profileOwner=model;
          CarpoolingCubit.get(context).getVisitPosts();
          CarpoolingCubit.get(context).visitprofile(context,
              VisitProfileScreen());
        },
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 25.0,
                    backgroundImage: NetworkImage(
                      '${model.image}',
                    ),
                  ),
                  SizedBox(
                    width: 15.0,
                  ),
                  Text(
                    '${model.name}',
                    style: TextStyle(
                      height: 3.4,
                      fontSize: 18.0,
                      color: textColor
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.0,),
              Row(
                children: [
                  Icon(Icons.location_on_sharp),
                  Text(
                      'lives in ${model.address}',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
}
