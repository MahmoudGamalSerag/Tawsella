import 'package:carpooling/layout/carpooling_app/admin_cubit/cubit.dart';
import 'package:carpooling/layout/carpooling_app/admin_cubit/states.dart';
import 'package:carpooling/models/carpooling_app/carpooling_user_model.dart';
import 'package:carpooling/modules/admin/admin_visit_profile_screen.dart';
import 'package:carpooling/shared/components/components.dart';
import 'package:carpooling/shared/styles/colors.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
class AdminUsersScreen extends StatelessWidget
{
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AdminCubit, AdminStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return ConditionalBuilder(
          condition: AdminCubit.get(context).activeusers.length > 0,
          builder: (context) => ListView.separated(
            physics: BouncingScrollPhysics(),
            itemBuilder: (context, index) =>
                buildUserItem(AdminCubit.get(context).activeusers[index], context),
            separatorBuilder: (context, index) => myDivider(),
            itemCount: AdminCubit.get(context).activeusers.length,
          ),
          fallback: (context) => Center(child: Text('No Users',style: TextStyle(fontSize: 40.0,color: Colors.grey),)),
        );
      },
    );
  }

  Widget buildUserItem(CarpoolingUserModel model, context) => InkWell(
    onTap: () {
      AdminCubit.get(context).profileOwner=model;
      AdminCubit.get(context).getVisitPosts();
      navigateTo(context, AdminVisitProfileScreen());
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
                style: TextStyle(color: textColor.withOpacity(0.5)),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
