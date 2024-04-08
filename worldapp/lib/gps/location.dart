import 'package:geolocator/geolocator.dart';

class GetLoCationInfo {
  double lati = 0;
  double long = 0;

  getCurrentLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if(permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    try{
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
      lati = position.latitude;
      long = position.longitude;
      print('dfd : $lati');
    } catch(e) {
      print(e);
    }
  }
}