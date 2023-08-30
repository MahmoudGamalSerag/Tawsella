import 'package:carpooling/layout/carpooling_app/admin_cubit/cubit.dart';
import 'package:carpooling/layout/carpooling_app/admin_cubit/states.dart';
import 'package:carpooling/models/carpooling_app/carpooling_user_model.dart';
import 'package:carpooling/models/carpooling_app/trip_model.dart';
import 'package:carpooling/shared/styles/colors.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
class AdminHomeScreen extends StatelessWidget
{
  @override
  Widget build(BuildContext context)
  {
    return BlocConsumer<AdminCubit, AdminStates>(
      listener: (context, state) {
      },
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: ConditionalBuilder(
            condition: AdminCubit.get(context).adminTrips.length > 0,
            builder: (context) =>
                ListView.separated(
                    physics: BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      if(AdminCubit.get(context).adminTrips[index].isActive==true)
                        {
                          return buildActiveTripItem(context,AdminCubit.get(context).adminTrips[index],AdminCubit.get(context).tripOwners[index]);
                        }
                      else
                        {
                          return buildEndTripItem(context,AdminCubit.get(context).adminTrips[index],AdminCubit.get(context).tripOwners[index]);
                        }
                    },
                    separatorBuilder: (context, index) => SizedBox(height: 20,),
                    itemCount: AdminCubit.get(context).adminTrips.length
                ),
            fallback: (context) => Center(child: CircularProgressIndicator()),
          ),
        );
      },
    );
  }
}
Widget buildActiveTripItem(context,TripModel tripModel,CarpoolingUserModel userModel) => InkWell(
  onTap: (){},
  child:Card(
    shape: RoundedRectangleBorder(
      side: BorderSide(
        color: defaultColor.withOpacity(0.6),
      ),
      borderRadius: const BorderRadius.all(Radius.circular(12)),
    ),
    color: backColor.withOpacity(0.5),
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

                        Expanded(
                          child: Text(

                            '${userModel.name}',

                            style: TextStyle(

                                height: 1.4,

                                fontSize: 18.0,
                                color: textColor

                            ),

                          ),
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

              IconButton(

                icon: Icon(

                    Icons.more_horiz,

                    size: 16.0,
                    color: textColor

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
          Row(

            children: [

              Text('Active',style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold
              ),),

            ],

          ),

          Row(

            children: [

              Text('Start Point: ',style: TextStyle(color:textColor),),

              Expanded(child: Text('${tripModel.startName}',overflow:TextOverflow.ellipsis,style: TextStyle(color:textColor),)),

            ],

          ),

          Row(

            children: [

              Text('End Point: ',style: TextStyle(color:textColor),),

              Expanded(child: Text('${tripModel.finishName}',style: TextStyle(color:textColor),)),

            ],

          ),

          Row(

            children: [

              Text('Free Seats: ',style: TextStyle(color:textColor),),

              Text('${tripModel.freeSeats}',style: TextStyle(color:textColor),),

            ],

          ),

          Row(

            children: [

              Text('Date : ',style: TextStyle(color:textColor),),

              Text('${tripModel.dateTime.substring(0,16)}',style: TextStyle(color:textColor),),

            ],

          ),
        ],

      ),

    ),

  ),
);
Widget buildEndTripItem(context,TripModel tripModel,CarpoolingUserModel userModel) => InkWell(
  onTap: (){},
  child:Card(
    shape: RoundedRectangleBorder(
      side: BorderSide(
        color: defaultColor.withOpacity(0.6),
      ),
      borderRadius: const BorderRadius.all(Radius.circular(12)),
    ),
    color: backColor.withOpacity(0.5),
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

                        Expanded(
                          child: Text(

                            '${userModel.name}',

                            style: TextStyle(

                                height: 1.4,

                                fontSize: 18.0,
                                color: textColor

                            ),

                          ),
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

              IconButton(

                icon: Icon(

                    Icons.more_horiz,

                    size: 16.0,
                    color: textColor

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
          Row(

            children: [

              Text('Finised',style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold
              ),),

            ],

          ),

          Row(

            children: [

              Text('Start Point: ',style: TextStyle(color:textColor),),

              Expanded(child: Text('${tripModel.startName}',overflow:TextOverflow.ellipsis,style: TextStyle(color:textColor),)),

            ],

          ),

          Row(

            children: [

              Text('End Point: ',style: TextStyle(color:textColor),),

              Expanded(child: Text('${tripModel.finishName}',style: TextStyle(color:textColor),)),

            ],

          ),

          Row(

            children: [

              Text('Free Seats: ',style: TextStyle(color:textColor),),

              Text('${tripModel.freeSeats}',style: TextStyle(color:textColor),),

            ],

          ),

          Row(

            children: [

              Text('Date : ',style: TextStyle(color:textColor),),

              Text('${tripModel.dateTime.substring(0,16)}',style: TextStyle(color:textColor),),

            ],

          ),
        ],

      ),

    ),

  ),
);