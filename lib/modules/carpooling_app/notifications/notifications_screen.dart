import 'package:carpooling/layout/carpooling_app/cubit/cubit.dart';
import 'package:carpooling/layout/carpooling_app/cubit/states.dart';
import 'package:carpooling/models/carpooling_app/address_model.dart';
import 'package:carpooling/models/carpooling_app/carpooling_car_model.dart';
import 'package:carpooling/models/carpooling_app/carpooling_user_model.dart';
import 'package:carpooling/models/carpooling_app/request_model.dart';
import 'package:carpooling/models/carpooling_app/trip_model.dart';
import 'package:carpooling/modules/carpooling_app/chat_details/chats.dart';
import 'package:carpooling/modules/carpooling_app/find_trip/view_trip_screen.dart';
import 'package:carpooling/shared/components/components.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotificationsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CarpoolingCubit, CarpoolingStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(60),
            child: defaultAppBar(
              context: context,
              title: 'Notifications',
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: ConditionalBuilder(
              condition: CarpoolingCubit.get(context).requests.length > 0,
              builder: (context) => ListView.separated(
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    if(CarpoolingCubit.get(context).requests[index].type=='request')
                      {
                        return buildRequestItem(
                          context,
                          CarpoolingCubit.get(context).requests[index],index);
                      }
                    else if(CarpoolingCubit.get(context).requests[index].type=='reject')
                      {
                        return buildRejectedItem(
                            context,
                            CarpoolingCubit.get(context).requests[index],index);
                      }
                    else if(CarpoolingCubit.get(context).requests[index].type=='accept')
                    {
                      return buildAcceptedItem(
                          context,
                          CarpoolingCubit.get(context).requests[index],index);
                    }
                    else
                      return Text('.');
                  },
                  separatorBuilder: (context, index) => SizedBox(
                    height: 20,
                  ),
                  itemCount: CarpoolingCubit.get(context).requests.length),
              fallback: (context) => Center(child: CircularProgressIndicator()),
            ),
          ),
        );
      },
    );
  }
}

Widget buildRequestItem(context, RequestModel requestModel,int index) => Card(
      color: Colors.blue[200],
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
                  radius: 23.0,
                  backgroundImage: NetworkImage(
                    '${requestModel.senderImage}',
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
                            '${requestModel.sendername}',
                            style: TextStyle(height: 1.4, fontSize: 17.0),
                          ),
                          SizedBox(
                            width: 5.0,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 15.0,
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${requestModel.sendername} Asks to join your trip.....',style: TextStyle(color: Colors.black54),),
                Row(
                  children: [
                    Text('Start Point: '),

                    Expanded(child: Text('${requestModel.senderStart}',overflow:TextOverflow.ellipsis,)),
                  ],
                ),
                Row(

                  children: [

                    Text('End Point: '),

                    Expanded(child: Text('${requestModel.senderFinish}')),

                  ],

                ),
                Row(
                  children: [
                    OutlinedButton(onPressed: (){CarpoolingCubit.get(context).acceptRequest(index);}, child: Text('Accept',style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.bold),)),
                    SizedBox(width: 50,),
                    OutlinedButton(onPressed: (){CarpoolingCubit.get(context).rejectRequest(index);}, child: Text('Reject',style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.bold),))
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
Widget buildRejectedItem(context, RequestModel requestModel,int index) => InkWell(
  onTap: (){
    CarpoolingCubit.get(context).seen(index);
  },
  child:   Card(

        color: Colors.blueGrey[200],

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

                    radius: 23.0,

                    backgroundImage: NetworkImage(

                      '${requestModel.senderImage}',

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

                              '${requestModel.sendername}',

                              style: TextStyle(height: 1.4, fontSize: 17.0),

                            ),

                            SizedBox(

                              width: 5.0,

                            ),

                          ],

                        ),

                      ],

                    ),

                  ),

                  SizedBox(

                    width: 15.0,

                  ),

                ],

              ),

              Column(

                crossAxisAlignment: CrossAxisAlignment.start,

                children: [

                  Text('${requestModel.sendername} Rejected your request to join the trip',style: TextStyle(color: Colors.black54),),

                ],

              ),

            ],

          ),

        ),

      ),
);
Widget buildAcceptedItem(context, RequestModel requestModel,int index) => InkWell(
  onTap: (){
    CarpoolingCubit.get(context).seen(index);
    CarpoolingCubit.get(context).userModel.ridertrips++;
    CarpoolingCubit.get(context).updateUser(name: CarpoolingCubit.get(context).userModel.name,
        phone: CarpoolingCubit.get(context).userModel.phone,
        address: CarpoolingCubit.get(context).userModel.address);
    navigateTo(context, ChatsScreen());
  },
  child:   Card(

        color: Colors.green[200],

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

                    radius: 23.0,

                    backgroundImage: NetworkImage(

                      '${requestModel.senderImage}',

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

                              '${requestModel.sendername}',

                              style: TextStyle(height: 1.4, fontSize: 17.0),

                            ),

                            SizedBox(

                              width: 5.0,

                            ),

                          ],

                        ),

                      ],

                    ),

                  ),

                  SizedBox(

                    width: 15.0,

                  ),

                ],

              ),

              Column(

                crossAxisAlignment: CrossAxisAlignment.start,

                children: [

                  Text('${requestModel.sendername} Accepted your request to join the trip check your chats',style: TextStyle(color: Colors.black54),),

                ],

              ),

            ],

          ),

        ),

      ),
);
