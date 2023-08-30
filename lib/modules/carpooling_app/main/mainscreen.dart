import 'dart:async';
import 'package:carpooling/assistants/assistantMethods.dart';
import 'package:carpooling/layout/carpooling_app/cubit/cubit.dart';
import 'package:carpooling/modules/carpooling_app/main/search_screen.dart';
import 'package:carpooling/shared/styles/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
class mainscreen extends StatefulWidget
{
  static const String idscreen="mainscreen";
  @override
  State<StatefulWidget> createState()=>_mainscreenstate();

}
class _mainscreenstate extends State<mainscreen>{
  final Completer<GoogleMapController> _controllergoogle =
  Completer<GoogleMapController>();
  GoogleMapController? newcontroller;
  List<LatLng>plineCooredinates=[];
  Set<Polyline> polyLineSet=Set();
  Position? currentPosition;
  var geolocater=Geolocator();
  double buttomPadding=0.0;
  Set<Marker>markersSet={};
  Set<Circle>circlesSet={};
  void locatePostion()async
  {
    Position position=await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    currentPosition=position;
    LatLng latLngPosition=LatLng(position.latitude, position.longitude);
    CameraPosition cameraPosition=new CameraPosition(target: latLngPosition,zoom: 14);
    newcontroller!.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
    var address=await AssistantMethods.SearchCordinateAddress(position,context);
  }


  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
          children: [

            GoogleMap(
              padding: EdgeInsets.only(bottom: buttomPadding),
              mapType: MapType.normal,
                myLocationButtonEnabled: true,
                initialCameraPosition: _kGooglePlex,
              myLocationEnabled: true,
              zoomGesturesEnabled: true,
              zoomControlsEnabled: true,
              polylines: polyLineSet,
              markers: markersSet,
              circles: circlesSet,

              onMapCreated: (GoogleMapController controller)
              {
                _controllergoogle.complete(controller);
                newcontroller=controller;
                setState(() {
                  buttomPadding=265.0;
                });
                locatePostion();
              },
            ),
            Positioned(
              left: 0.0,
              right: 0.0,
              bottom: 0.0,
                child:Container(
                  height: 70.0,
                  decoration: BoxDecoration(
                    color: backColor,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(18.0),topRight: Radius.circular(18.0)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black,
                        blurRadius: 16.0,
                        spreadRadius: 0.5,
                        offset: Offset(0.7,0.7),
                      ),
                    ]
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0,vertical: 18.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // SizedBox(height: 6.0,),
                        // Text('Hi There',style: TextStyle(fontSize: 12.0),),
                        // Text('Where To?',style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold),),
                        // SizedBox(height:20.0),
                        InkWell(
                          onTap: ()async
                          {
                           var res=await Navigator.push(
                             context,
                             MaterialPageRoute(
                               builder: (context) => SearchScreen(),
                             ),
                           );
                           if(res=='obtainedDirections')
                             {
                               await getPlaceDirections();
                             }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: backColor,
                              borderRadius: BorderRadius.circular(5.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black45,
                                    blurRadius: 6.0,
                                    spreadRadius: 0.5,
                                    offset: Offset(0.7,0.7),
                                  ),
                                ]
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.search,color: defaultColor,),
                                SizedBox(width: 10.0,),
                                Text('Search for Destination',style: TextStyle(color: textColor),),
                              ],
                            ),
                          ),
                        ),
                        // SizedBox(height: 24.0,),
                        // Row(
                        //   children: [
                        //     Icon(Icons.home,color: Colors.grey,),
                        //     SizedBox(width: 12.0,),
                        //     Column(
                        //       crossAxisAlignment: CrossAxisAlignment.start,
                        //       children: [
                        //         Text('Home'),
                        //         SizedBox(height: 4.0,),
                        //         Text('your address',style: TextStyle(color: Colors.black54,fontSize: 12.0),),
                        //       ],
                        //     ),
                        //   ],
                        // ),
                        // SizedBox(height: 10.0,),
                        // Row(
                        //   children: [
                        //     Icon(Icons.work,color: Colors.grey,),
                        //     SizedBox(width: 12.0,),
                        //     Column(
                        //       crossAxisAlignment: CrossAxisAlignment.start,
                        //       children: [
                        //         Text('Work'),
                        //         SizedBox(height: 4.0,),
                        //         Text('your office address',style: TextStyle(color: Colors.black54,fontSize: 12.0),),
                        //       ],
                        //     ),
                        //   ],
                        // ),
                      ],
                    ),
                  ),
                ),
            ),
          ],
        ),
    );
  }
  Future<void> getPlaceDirections()async
  {
    var initialPosition=CarpoolingCubit.get(context).addressModel;
    var dropPosition=CarpoolingCubit.get(context).dropoff;
    var pickUpLtlng=LatLng(initialPosition.latitude, initialPosition.longitude);
    var dropofLtlng=LatLng(dropPosition.latitude, dropPosition.longitude);
    var details= await AssistantMethods.obtainPlaceDirectionDetails(pickUpLtlng, dropofLtlng);
   // Navigator.pop(context);
    print('This is encoded points ');
    print(details.encodedPoints);
    PolylinePoints polylinePoints=PolylinePoints();
    List<PointLatLng> decodePolyLinePointsResult=polylinePoints.decodePolyline(details.encodedPoints);
    plineCooredinates.clear();
    if(decodePolyLinePointsResult.isNotEmpty)
      {
        decodePolyLinePointsResult.forEach((PointLatLng pointLatLng) {
          plineCooredinates.add(LatLng(pointLatLng.latitude, pointLatLng.longitude));

        });
      }
    polyLineSet.clear();
   setState(() {
     Polyline polyline=Polyline(
       color: Colors.blue,
       polylineId: PolylineId('PolylineID'),
       jointType: JointType.round,
       points: plineCooredinates,
       width: 5,
       startCap: Cap.roundCap,
       endCap: Cap.roundCap,
       geodesic: true,
     );
     polyLineSet.add(polyline);
   });
   LatLngBounds latLngBounds;
   if(pickUpLtlng.latitude>dropofLtlng.latitude&&pickUpLtlng.longitude>dropofLtlng.longitude)
     {
       latLngBounds=LatLngBounds(southwest: dropofLtlng, northeast: pickUpLtlng);
     }
   else if(pickUpLtlng.longitude>dropofLtlng.longitude)
   {
     latLngBounds=LatLngBounds(southwest: LatLng(pickUpLtlng.latitude,dropofLtlng.longitude), northeast: LatLng(dropofLtlng.latitude,pickUpLtlng.longitude));
   }
   else if(pickUpLtlng.latitude>dropofLtlng.latitude)
     {
       latLngBounds=LatLngBounds(southwest: LatLng(dropofLtlng.latitude,pickUpLtlng.longitude), northeast: LatLng(pickUpLtlng.latitude,dropofLtlng.longitude));
     }
   else
     {
       latLngBounds=LatLngBounds(southwest: pickUpLtlng, northeast: dropofLtlng);
     }
   newcontroller!.animateCamera(CameraUpdate.newLatLngBounds(latLngBounds, 70));
   Marker pickUpLocationMarker=Marker(
     icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
       infoWindow: InfoWindow(title: initialPosition.PlaceName,snippet: "my location"),
       position: pickUpLtlng,
       markerId: MarkerId('pickUpId'),
   );
    Marker dropOffLocationMarker=Marker(
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
      infoWindow: InfoWindow(title:dropPosition.PlaceName,snippet: "Destination"),
      position: dropofLtlng,
      markerId: MarkerId('dropOffId'),
    );
    setState(() {
      markersSet.add(pickUpLocationMarker);
      markersSet.add(dropOffLocationMarker);
    });
    Circle pickUpCircle=Circle(
      fillColor: Colors.yellow,
        center: pickUpLtlng,
        radius: 12,
        strokeWidth: 4,
        strokeColor: Colors.yellowAccent,
        circleId: CircleId('pickUpId'),
    );
    Circle dropOffCircle=Circle(
      fillColor: Colors.red,
        center: dropofLtlng,
        radius: 12,
        strokeWidth: 4,
        strokeColor: Colors.redAccent,
        circleId: CircleId('dropOffId'),
    );
    setState(() {
      circlesSet.add(pickUpCircle);
      circlesSet.add(dropOffCircle);
    });
  }
}