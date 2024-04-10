import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import 'package:circle_guide/page/map/map_page.dart';
import 'package:circle_guide/provider/guide/guide_provider.dart';

List<Map<String, dynamic>>? _loc;
bool isLoding = true;

class ScreenChatPage extends StatelessWidget {
  const ScreenChatPage({
    Key? key,
    required this.data,
    required this.type,
  }) : super(key: key);
  final Map<String, dynamic> data;
  final bool type;

  @override
  Widget build(BuildContext context) {
    isLoding = true;
    locGetLocationUpdates(context);
    return Consumer<GuideProvider>(builder: (context, value, _) {
      if (isLoding) {
        return Scaffold(
          appBar: AppBar(),
          body: const Center(
          child: CircularProgressIndicator(),
        ),
        );
      } else {
        return Scaffold(
          appBar: AppBar(
            title: Text(data['email'].toString()),
            actions: [
              IconButton(
                  onPressed: () async{
                    isLoding = true;
                    final tmp = await context.read<GuideProvider>().deleteData(data['uid'],data['gid']);
                    if(!context.mounted)return;
                    if(tmp)
                    {
                      Navigator.pop(context);
                    }
                  },
                  icon: const Icon(Icons.delete))
            ],
          ),
          body: ListView(
            children: [
              _loc != null
                  ? Align(
                      alignment: Alignment.topLeft,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: List.generate(
                          _loc!.length,
                          (index) => LocationCard(
                            data: _loc![index],
                            newData: index == _loc!.length - 1 ? true : false,
                          ),
                        ),
                      ),
                    )
                  : const SizedBox(),
            ],
          ),
        );
      }
    });
  }

  Future<void> locGetLocationUpdates(BuildContext context) async {
    isLoding = true;
    _loc = await context.read<GuideProvider>().getLocation(data['uid'],data['gid']);
    isLoding = false;
  }
}

class LocationCard extends StatelessWidget {
  const LocationCard({
    Key? key,
    required this.data,
    required this.newData,
  }) : super(key: key);
  final Map<String, dynamic> data;
  final bool newData;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
            onTap: () {
              
              Navigator.pop(context);
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ScreenMap(
                    // sending map marker
                    targetUser: Marker(
                      markerId: const MarkerId('_uik'),
                      position: LatLng(data['locx'], data['locy']),
                      icon: BitmapDescriptor.defaultMarkerWithHue(
                        BitmapDescriptor.hueGreen,
                      ),
                    ),
                  ),
                ),
              );
            },
            child: Container(
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: newData ? Colors.red : Colors.green,
                  borderRadius: BorderRadius.circular(20)),
              width: 100,
              height: 100,
              child: const Center(
                child: Icon(
                  Icons.location_on,
                  size: 50,
                ),
              ),
            )),
        Text(data['date'].toString())
      ],
    );
  }
}
