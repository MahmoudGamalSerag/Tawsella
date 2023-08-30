import 'dart:async';
import 'package:carpooling/assistants/assistantMethods.dart';
import 'package:carpooling/layout/carpooling_app/cubit/cubit.dart';
import 'package:carpooling/modules/carpooling_app/main/search_screen.dart';
import 'package:carpooling/shared/components/components.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
class ViewTripScreen extends StatefulWidget
{
  static const String idscreen="ViewTripScreen";
  @override
  State<StatefulWidget> createState()=>_ViewTripScreenstate();

}
class _ViewTripScreenstate extends State<ViewTripScreen>{

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
    await getPlaceDirections();
    print('your addres is '+address);
  }

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );
  @override
  Widget build(BuildContext context) {
    var profileOwner=CarpoolingCubit.get(context).profileOwner;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: defaultAppBar(
          context: context,
          title: 'View Trip',
          actions: [
            defaultTextButton(
              function: ()async
              {
                var res=await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SearchScreen(),
                  ),
                );
                if(res=='obtainedDirections')
                {
                  CarpoolingCubit.get(context).sendRequest(
                      receiverId: profileOwner.uId,
                      dateTime: DateTime.now().toString(),
                    type: 'request'
                  );
                  Navigator.pop(context);
                }
              },
              text: 'Send Request',
            ),
            SizedBox(
              width: 15.0,
            ),
          ],
        ),
      ),
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
        ],
      ),
    );
  }
  Future<void> getPlaceDirections()async
  {
    var initialPosition=CarpoolingCubit.get(context).tripInitial;
    var dropPosition=CarpoolingCubit.get(context).tripFinish;
    var pickUpLtlng=LatLng(initialPosition.latitude, initialPosition.longitude);
    var dropofLtlng=LatLng(dropPosition.latitude, dropPosition.longitude);
    var details= await AssistantMethods.obtainPlaceDirectionDetails(pickUpLtlng, dropofLtlng);
    // Navigator.pop(context);
    // print('This is encoded points ');
    // print(details.encodedPoints);
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
    print(initialPosition.latitude);
    print(initialPosition.longitude);
    print(dropPosition.latitude);
    print(dropPosition.longitude);
  }
}