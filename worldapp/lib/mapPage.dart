import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/route_manager.dart';
import 'package:latlong2/latlong.dart' as latlng;

class ShowMapPage extends StatefulWidget {
  const ShowMapPage({super.key});

  @override
  State<ShowMapPage> createState() => _ShowMapPageState();
}

class _ShowMapPageState extends State<ShowMapPage> {

  var value = Get.arguments ?? "__";
  late MapController mapController;
  late double longData;
  late double latData;
  late String sname;

  @override
  void initState() {
    super.initState();
    mapController = MapController();

    latData = double.parse(value[0]);
    longData = double.parse(value[1]);
    sname = value[2];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('맛집 위치'),
        backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
        foregroundColor: Theme.of(context).colorScheme.onTertiaryContainer,
      ),
      body: flutterMap(),
    );
  }


  Widget flutterMap() {
    return FlutterMap(
      mapController: mapController,
      options: MapOptions(
        initialCenter: latlng.LatLng(latData,longData),
        initialZoom: 17
      ), 
      children: [

        //지도 그리기
        TileLayer(
          urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
        ),

        //GPS 표시
        MarkerLayer(
          markers: [
            Marker(
              width: 80,
              height: 80,
              point: latlng.LatLng(latData, longData), 
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      sname.length < 5
                      ? Text(
                        sname,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      )
                      :Text(
                        sname
                        .replaceRange(4, sname.toString().length, "..."),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  
                  Icon(
                    Icons.pin_drop,
                    size: 50,
                    color: Theme.of(context).colorScheme.error,
                  )
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}