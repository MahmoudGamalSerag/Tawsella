import 'package:carpooling/assistants/assistants.dart';
import 'package:carpooling/layout/carpooling_app/cubit/cubit.dart';
import 'package:carpooling/models/carpooling_app/address_model.dart';
import 'package:carpooling/models/carpooling_app/direction_model.dart';
import 'package:carpooling/shared/components/constants.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AssistantMethods{
  static Future<String> SearchCordinateAddress(Position position,context)async
  {
    String placeAddress='';
    String url='https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=AIzaSyC_z94VM2FCMAuxACRdM_c1u3q-ycNhGjA';
    var response=await RequestAssistants.getRequest(url);
    if(response !='failed')
      {
       // placeAddress=response['results'][0]['formatted_address'];
        String s1,s2,s3,s4;
        s1=response['results'][0]['address_components'][0]['long_name'];
        s2=response['results'][0]['address_components'][1]['long_name'];
        s3=response['results'][0]['address_components'][2]['long_name'];
        s4=response['results'][0]['address_components'][3]['long_name'];
        placeAddress=s1+" "+s2+' '+s3+' '+s4;
        AddressModel userPickupAddress=new AddressModel(
            PlaceName: placeAddress,
            latitude:position.latitude,
            longitude: position.longitude,
          PlaceId: "0"
        );
        CarpoolingCubit.get(context).addressModel=userPickupAddress;
      }
    else
      {
        print('faileeeeed');
      }
    return placeAddress;
  }

  static Future<DirectionModel> obtainPlaceDirectionDetails(LatLng initialPosition,LatLng finalPosition)async
  {
    String directionUrl='https://maps.googleapis.com/maps/api/directions/json?destination=${finalPosition.latitude},${finalPosition.longitude}&origin=${initialPosition.latitude},${initialPosition.longitude}&key=$apiKey';
    var res=await RequestAssistants.getRequest(directionUrl);
    if(res=='failed')
      {
        return DirectionModel(distanceText: '0', durationText: '0', encodedPoints: '0', distanceValue: 0, durationValue: 0);
      }
    DirectionModel directionModel=new DirectionModel(
        distanceText: res['routes'][0]['legs'][0]['distance']['text'],
        durationText: res['routes'][0]['legs'][0]['duration']['text'],
        encodedPoints: res['routes'][0]['overview_polyline']['points'],
        distanceValue: res['routes'][0]['legs'][0]['distance']['value'],
        durationValue: res['routes'][0]['legs'][0]['duration']['value']
    );
    return directionModel;
  }
}