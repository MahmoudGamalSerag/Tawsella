import 'package:carpooling/assistants/assistantMethods.dart';
import 'package:carpooling/assistants/assistants.dart';
import 'package:carpooling/layout/carpooling_app/cubit/cubit.dart';
import 'package:carpooling/models/carpooling_app/address_model.dart';
import 'package:carpooling/models/carpooling_app/place_pridictions_model.dart';
import 'package:carpooling/shared/components/constants.dart';
import 'package:carpooling/shared/styles/colors.dart';
import 'package:flutter/material.dart';
class SearchScreen extends StatefulWidget {
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  var pickController = TextEditingController();
  var dropController = TextEditingController();
  List<PlacePredictionsModel> placePredictionlist=[];
  @override
  Widget build(BuildContext context) {
    String placeAddress=CarpoolingCubit.get(context).addressModel.PlaceName;
    pickController.text=placeAddress;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 215.0,
              decoration: BoxDecoration(
                color: backColor,
                boxShadow: [
                  BoxShadow(
                    color: defaultColor.withOpacity(0.3),
                    blurRadius: 6.0,
                    spreadRadius: 0.5,
                    offset: Offset(0.7,0.7),
                  ),
                ]
              ),
              child:Padding(
                padding: const EdgeInsets.only(left: 25.0,right: 25.0,top: 20.0,bottom: 20.0),
                child: Column(
                  children: [
                    SizedBox(height: 5.0,),
                    Stack(
                      children: [
                        IconButton(icon: Icon(Icons.arrow_back_ios),onPressed: (){
                          Navigator.pop(context);
                        },),
                        Center(
                          child: Text('Set your desitnation',style: TextStyle(fontSize: 18.0,fontWeight: FontWeight.bold,color: textColor),),
                        )
                      ],
                    ),
                    SizedBox(height: 15.0,),
                    Row(
                      children: [
                        Image.asset('images/pickicon.png',height: 16.0,width: 16.0,),
                        SizedBox(width: 16.0,),
                        Expanded(child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[400],
                            borderRadius: BorderRadius.circular(5.0)
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(3.0),
                            child: TextField(
                              controller: pickController,
                              style: TextStyle(color: Colors.black),
                              decoration: InputDecoration(
                                hintText: 'pickup location',
                                  hintStyle: TextStyle(color: Colors.black),
                                fillColor: Colors.grey[400],
                                filled: true,
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.only(left: 11.0,bottom: 8.0,top: 8.0),
                                isDense: true
                              ),
                            ),
                          ),
                        ),
                        ),

                      ],
                    ),
                    SizedBox(height: 10.0,),
                    Row(
                      children: [
                        Image.asset('images/desticon.png',height: 16.0,width: 16.0,),
                        SizedBox(width: 16.0,),
                        Expanded(child: Container(
                          decoration: BoxDecoration(
                              color: Colors.grey[400],
                              borderRadius: BorderRadius.circular(5.0)
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(3.0),
                            child: TextField(
                              onChanged: (val){
                                findPlace(val);
                              },
                              controller: dropController,
                              style: TextStyle(color: Colors.black),
                              decoration: InputDecoration(
                                  hintText: 'Where To?',
                                  hintStyle: TextStyle(color: Colors.black),
                                  fillColor: Colors.grey[400],
                                  filled: true,
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.only(left: 11.0,bottom: 8.0,top: 8.0),
                                  isDense: true
                              ),
                            ),
                          ),
                        ),
                        ),

                      ],
                    ),
                  ],
                ),
              ),
            ),
            (placePredictionlist.length>0)?
                Padding(padding: EdgeInsets.symmetric(vertical: 8.0,horizontal: 16.0),
                child:ListView.separated(
                    itemBuilder: (context,index)
                    {
                      return PredictionTile(placePredictionsModel: placePredictionlist[index]);
                    },
                    separatorBuilder: (context, index) => SizedBox(
                      height: 8.0,
                    ),
                    itemCount: placePredictionlist.length,
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                ) ,
                )
                :
                Container(

                ),
          ],
        ),
      ),
    );
  }
  void findPlace(String placename)async
  {
    if(placename.length>1)
      {
        String autoComplete="https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$placename&types=geocode&key=AIzaSyC_z94VM2FCMAuxACRdM_c1u3q-ycNhGjA&components=country:EG";
        var res=await RequestAssistants.getRequest(autoComplete);
        if(res=='failed')
          {
            return;
          }
        print("Placesssssssssssssssssssssss");
        print(res);
        if(res["status"]=='OK')
        {
          var predictions=res["predictions"];
          var placesList=(predictions as List).map((e) => PlacePredictionsModel.fromJson(e)).toList();
          setState(() {
            placePredictionlist=placesList;
          });
        }
      }

  }
}
class PredictionTile extends StatelessWidget {
  final PlacePredictionsModel placePredictionsModel;
   PredictionTile({Key? key, required this.placePredictionsModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        getPlaceAddressDetails(placePredictionsModel.placeId,context);
      },
      child: Container(
        child: Column(
          children: [
            SizedBox(height:10.0),
            Row(
              children: [
                Icon(Icons.add_location),
                SizedBox(width: 14.0,),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(placePredictionsModel.mainText,overflow:TextOverflow.ellipsis,style: TextStyle(fontSize: 16.0,color: textColor),),
                      SizedBox(height: 3.0,),
                      Text(placePredictionsModel.secondaryText,overflow:TextOverflow.ellipsis,style: TextStyle(fontSize: 16.0,color: textColor.withOpacity(0.5)),),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  void getPlaceAddressDetails(placeId,context)async
  {
    String placeUrl="https://maps.googleapis.com/maps/api/place/details/json?&place_id=$placeId&key=$apiKey";
    var res=await RequestAssistants.getRequest(placeUrl);
    if(res=='failed')
      {
        return;
      }
    if(res["status"]=='OK')
      {
        AddressModel addressModel=AddressModel(
            PlaceName: res['result']['name'],
            PlaceId: placeId,
            latitude: res['result']['geometry']['location']['lat'],
            longitude:res['result']['geometry']['location']['lng'],
        );
        CarpoolingCubit.get(context).dropoff=addressModel;
        CarpoolingCubit.get(context).dest=true;
        Navigator.pop(context,'obtainedDirections');
      }
  }
}

