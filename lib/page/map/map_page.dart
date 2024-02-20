import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

ValueNotifier<LatLng?> locationUpdate = ValueNotifier(null);
Completer<GoogleMapController> _completer = Completer<GoogleMapController>();
double _zoom = 14;

class ScreenMap extends StatelessWidget {
  const ScreenMap({
    Key? key,
    this.targetUser,
  }) : super(key: key);
   final Marker? targetUser;

  @override
  Widget build(BuildContext context) {
    getLocationUpdates();
    return Scaffold(
      appBar: AppBar(
        title: const Text('map'),
      ),
      body: Container(
        color: Colors.black,
        child: ValueListenableBuilder(
          valueListenable: locationUpdate,
          builder: (context,value,_) {
            if(locationUpdate.value!=null)
            {
              return GoogleMap(
                
              onMapCreated: (controllrt)=>_completer.complete(controllrt),
              myLocationButtonEnabled: true,
              zoomControlsEnabled: true,
              
              initialCameraPosition: CameraPosition(target: const LatLng(37.42796133580664, -122.085749655962), zoom: _zoom),
              minMaxZoomPreference: const MinMaxZoomPreference(0, 100),
               markers: targetUser!=null?{
                Marker(markerId: const MarkerId('_currentLocation'),icon: BitmapDescriptor.defaultMarker,position: locationUpdate.value!,),
                targetUser!
               }:{
                Marker(markerId: const MarkerId('_currentLocation'),icon: BitmapDescriptor.defaultMarker,position: locationUpdate.value!,),
               },
               onCameraMove:(CameraPosition cameraPosition){
                _zoom = cameraPosition.zoom;
                log(cameraPosition.zoom.toString());
               },
            );
            }
            return const SizedBox();
          }
        ),
      ),
    );
  }

  Future<void> cameraToPos(LatLng pos)async{
    GoogleMapController controller = await _completer.future;
    CameraPosition newCameraPosition = CameraPosition(target: pos,zoom: _zoom);
    try {
      await controller.animateCamera(CameraUpdate.newCameraPosition(newCameraPosition));
    } catch (e) {
      _completer = Completer();
      log(e.toString());
      return;
    }
  }


  Future<void> getLocationUpdates()async{
    Location location =Location();
    bool serviceEnabled;
    PermissionStatus permissionGranted;
    serviceEnabled = await location.serviceEnabled();
    if(serviceEnabled)
    {
      serviceEnabled = await location.requestService();
    }else{
      return;
    }
    permissionGranted = await location.hasPermission();
    if(permissionGranted == PermissionStatus.denied)
    {
      permissionGranted = await location.requestPermission();
      if(permissionGranted != PermissionStatus.granted)
      {
        return;
      }
    }
     location.onLocationChanged.listen((LocationData loc) {
      if(loc.latitude!=null&&loc.longitude!=null)
      {
        locationUpdate.value = LatLng(loc.latitude!, loc.longitude!);
        if(locationUpdate.value!=null)
        {
          cameraToPos(locationUpdate.value!);
        }
      }
    });
  }
}
