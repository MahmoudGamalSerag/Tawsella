import 'package:carpooling/layout/carpooling_app/cubit/cubit.dart';
import 'package:carpooling/shared/components/components.dart';
import 'package:carpooling/shared/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
class RateScreen extends StatefulWidget{
  @override
  _RateScreenState createState()=>_RateScreenState();

}

class _RateScreenState extends State<RateScreen>{
  double rating=0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: AppBar(
          backgroundColor: defaultColor,
          title:Text('Rate user',style: TextStyle(color: textColor,fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
        ),
      ),
      body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Rating: $rating',style: TextStyle(
                fontSize: 40.0,
                color: textColor,
                fontWeight: FontWeight.bold
              ),
              ),
              SizedBox(height: 30,),
              RatingBar.builder(
                minRating: 1,
                itemSize: 45,
                itemBuilder: (context,_)=>Icon(Icons.star,color: Colors.amber,),
                updateOnDrag: true,
                onRatingUpdate: (rating)=>setState(() {
                  this.rating=rating;
                }),
              ),
              SizedBox(height: 30,),
              defaultButton(function: (){
                CarpoolingCubit.get(context).rate(rating.toInt());
               // print(rating.toInt());
                Navigator.pop(context);
              }, text: 'Ok',width: 100),
            ],
          ),

      ),
    );
  }
  
}
Widget buildStar(){
  return Card(
    color: Colors.black54,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0,vertical: 10.0),
      child: Row(
        children:<Widget> [
          Icon(Icons.star,
            size: 50,
            color: Colors.amber,),
          SizedBox(width: 15,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children:<Widget> [
              Text('Rate',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 8,),
              Text('3.5',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}