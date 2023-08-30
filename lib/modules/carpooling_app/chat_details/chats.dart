import 'package:carpooling/layout/carpooling_app/cubit/cubit.dart';
import 'package:carpooling/layout/carpooling_app/cubit/states.dart';
import 'package:carpooling/models/carpooling_app/carpooling_user_model.dart';
import 'package:carpooling/models/carpooling_app/chatobject.dart';
import 'package:carpooling/modules/carpooling_app/chat_details/chat_details_screen.dart';
import 'package:carpooling/shared/components/components.dart';
import 'package:carpooling/shared/styles/colors.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
class ChatsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: defaultAppBar(
          context: context,
          title: 'Chats'
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              ConditionalBuilder(
                condition: CarpoolingCubit.get(context).chats.length > 0  ,
                builder: (context) => SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    children:
                    [
                      ListView.separated(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) => buildUserItem(CarpoolingCubit.get(context).chats[index],CarpoolingCubit.get(context).chatsobj[index],context),
                        separatorBuilder: (context, index) => SizedBox(
                          height: 8.0,
                        ),
                        itemCount: CarpoolingCubit.get(context).chats.length,
                      ),
                      SizedBox(
                        height: 8.0,
                      ),
                    ],
                  ),
                ),
                fallback: (context) => Center(child: Text('No Chats Yet',style: TextStyle(fontSize: 40.0,color: Colors.grey),)),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildUserItem(CarpoolingUserModel model,CarpoolingChatObjectModel obj, context) => InkWell(
    onTap: () {
      navigateTo(context, ChatDetailsScreen(userModel: model));
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
              Expanded(
                child: Text(
                  '${model.name}',
                  style: TextStyle(
                    height: 1.4,
                    fontSize: 20.0,
                    color: textColor
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Text('Last message on ',style: TextStyle(
                fontSize: 12.0,
                color: Colors.grey,
              ),
              ),
              Text('${obj.dateTime.substring(0,16)}',style: TextStyle(
                fontSize: 11.0,
                color: textColor,
              ),)
            ],
          )
        ],
      ),
    ),
  );
}
