
import 'package:circle_guide/provider/guide/guide_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';

import 'package:circle_guide/page/map/map_page.dart';
import 'package:circle_guide/provider/chat/chat_provider.dart';

import '../../provider/guide/guid_pro.dart';

bool isLoding = true;
ScrollController _scrollController = ScrollController();
TextEditingController _controller = TextEditingController();
MainAxisAlignment align = MainAxisAlignment.start;

class ScreenChatPage extends StatefulWidget {
  const ScreenChatPage({
    Key? key,
    required this.data,
  }) : super(key: key);
  final Map<String, dynamic> data;

  @override
  State<ScreenChatPage> createState() => _ScreenChatPageState();
}

class _ScreenChatPageState extends State<ScreenChatPage> {
  Widget? guideInfoWidget, iAmGuide;
  double? locx, locy;
  @override
  void initState() {
    getData();
    checkYourGuide();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    context.read<ChatProvider>().getMassages(widget.data["chatId"]);
    return Consumer<ChatProvider>(builder: (context, value, _) {
        return StreamBuilder(
          stream: value.currentScreenMassage,
          builder: (context, snapshot) {
            if (widget.data["revicerId"] == firebaseAuth.currentUser!.uid) {
        value.removeSeenData(widget.data);
      }
            if (snapshot.hasData) {
              return Scaffold(
                appBar: AppBar(
                  title: Text(widget.data['fName'].toString()),
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  actions: [
                    IconButton(
                        onPressed: () async {
                          bottomShet(context);
                        },
                        icon: const Icon(Icons.more_vert))
                  ],
                ),
                body: Column(
                  children: [
                    Expanded(
                      child: ListView(
                        reverse: true,
                        controller: _scrollController,
                        children: [
                          value.currentScreenMassage != null
                              ? Align(
                                  alignment: Alignment.topLeft,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: List.generate(
                                        snapshot.data!.length, (index) {
                                      if (snapshot.data![index].senderid ==
                                          firebaseAuth.currentUser!.uid) {
                                        align = MainAxisAlignment.end;
                                      } else {
                                        align = MainAxisAlignment.start;
                                      }
                                      return snapshot.data![index].locx != null
                                          ? LocationCard(
                                              data: snapshot.data![index],
                                              newData: index ==
                                                      snapshot.data!.length - 1
                                                  ? true
                                                  : false,
                                            )
                                          : ChatWidget(
                                              massage: snapshot.data![index]);
                                    }),
                                  ),
                                )
                              : const SizedBox(),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: TextFormField(
                          controller: _controller,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20)),
                            hintText: "Send Massage",
                            suffixIcon: IconButton(
                                onPressed: () {
                                  context.read<ChatProvider>().sendMassages(
                                      widget.data["fId"],
                                      widget.data["ftoken"],
                                      widget.data["chatId"],
                                      firebaseAuth.currentUser!.uid,
                                      _controller
                                          .text); //SendMassage(data["fId"], firebaseAuth.currentUser!.uid,_controller.text);
                                  _controller.clear();
                                },
                                icon: const Icon(Icons.send_rounded)),
                          )),
                    )
                  ],
                ),
              );
            } else {
              return const CupertinoActivityIndicator(
                radius: 10,
              );
            }
          },
        );
    });
  }

  bottomShet(BuildContext context) {
    return showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return Container(
            color: Colors.blueGrey,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const CircleAvatar(
                      radius: 55,
                      backgroundColor: Colors.black54,
                      child: CircleAvatar(radius: 50)),
                  const SizedBox(height: 17),
                  Text(
                    '${widget.data['fName']}',
                    style: const TextStyle(
                        fontWeight: FontWeight.w700, fontSize: 18),
                  ),
                  const SizedBox(height: 30),
                  guideInfoWidget != null ? guideInfoWidget! : const SizedBox(),
                  guideInfoWidget != null
                      ? const SizedBox(height: 10)
                      : const SizedBox(),
                  iAmGuide != null ? iAmGuide! : const SizedBox(),
                  iAmGuide != null
                      ? const SizedBox(height: 10)
                      : const SizedBox(),
                  ListTile(
                      splashColor: Colors.black,
                      title: const Text("Send Location"),
                      leading: const Icon(Icons.add_location_alt_outlined),
                      onTap: () async {
                        await locGetLocationUpdates();
                        if (locx != null && locy != null) {
                          context.read<ChatProvider>().sendLocation(
                              widget.data['chatId'],
                              widget.data["fId"],
                              firebaseAuth.currentUser!.uid,
                              locx!,
                              locy!);
                          Navigator.of(context).pop();
                        }
                      }),
                  const SizedBox(height: 10),
                  ListTile(
                      title: const Text("Remove Friend List"),
                      leading: const Icon(Icons.delete_outline_rounded),
                      onTap: () {
                        context.read<GuidePageProvider>().deleteFriend(
                            widget.data["fId"], widget.data["chatId"]);
                        Navigator.of(context).pop();
                      }),
                  const SizedBox(height: 10),
                  ListTile(
                    title: const Text("Close"),
                    leading: const Icon(Icons.close_rounded),
                    onTap: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
          );
        });
  }

  void getData() async {
    try {
      final guideData = await firestore
        .collection("Folders/MyGuide/${firebaseAuth.currentUser!.uid}")
        .get()
        .then((value) {
      return value.docs.map((e) {
        return e.data();
      }).toList();
    });
    for (var row in guideData) {
      if (row["gId"] == widget.data["fId"]) {
        guideInfoWidget = removeGuide();
        setState(() {});
        return;
      }
    }
    guideInfoWidget = addGuide();
    setState(() {});
    } catch (e) {
      return;
    }
    return;
  }

  void checkYourGuide() async {
    try {
      final guideData = await firestore
        .collection("Folders/MyGuide/${widget.data["fId"]}")
        .get()
        .then((value) {
      return value.docs.map((e) {
        return e.data();
      }).toList();
    });
    for (var row in guideData) {
      if (row["gId"] == firebaseAuth.currentUser!.uid) {
        iAmGuide = ListTile(
            title: const Text("Remove Guide Duty"),
            leading: const Icon(Icons.remove_moderator_rounded),
            onTap: () => context.read<GuideProvider>().deleteGuide(
                widget.data["fId"], firebaseAuth.currentUser!.uid));
        setState(() {});
        return;
      }
    }
    iAmGuide = null;
    setState(() {});
    } catch (e) {
      return;
    }
    return;
  }

  Widget removeGuide() {
    return ListTile(
        title: const Text("remove Guide"),
        leading: const Icon(Icons.add_moderator_rounded),
        onTap: () {
          context
              .read<GuideProvider>()
              .deleteGuide(firebaseAuth.currentUser!.uid, widget.data["fId"]);
          Navigator.of(context).pop();
        });
  }

  Widget addGuide() {
    return ListTile(
        title: const Text("Add Guide"),
        leading: const Icon(Icons.add_moderator_rounded),
        onTap: () {
          context.read<GuideProvider>().sendGuideRequest(
                firebaseAuth.currentUser!.uid,
                widget.data["chatId"],
                widget.data["fId"],
                firebaseAuth.currentUser!.displayName!,
                firebaseAuth.currentUser!.email!,
                widget.data["ftoken"],
              );
          Navigator.of(context).pop();
        });
  }

  Future<void> locGetLocationUpdates() async {
    Location location = Location();
    bool serviceEnabled;
    PermissionStatus permissionGranted;
    serviceEnabled = await location.serviceEnabled();
    if (serviceEnabled) {
      serviceEnabled = await location.requestService();
    } else {
      return;
    }
    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    location.getLocation().then((loccation) {
      if (loccation.latitude != null && loccation.longitude != null) {
        //x                        //y
        locx = loccation.latitude;
        locy = loccation.longitude;
      }
    });
    return;
  }
}

class ChatWidget extends StatelessWidget {
  const ChatWidget({
    Key? key,
    required this.massage,
  }) : super(key: key);
  final MassageModule massage;

  @override
  Widget build(BuildContext context) {
    final sender = massage.senderid == firebaseAuth.currentUser!.uid;
    return Row(
      mainAxisAlignment:
          !sender ? MainAxisAlignment.start : MainAxisAlignment.end,
      children: [
        FittedBox(
            alignment: Alignment.centerLeft,
            child: Container(
                padding: const EdgeInsets.only(left: 10, right: 10),
                margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        bottomLeft:
                            sender ? const Radius.circular(10) : Radius.zero,
                        bottomRight:
                            !sender ? const Radius.circular(10) : Radius.zero,
                        topLeft: const Radius.circular(10),
                        topRight: const Radius.circular(10)),
                    color: sender ? Colors.green : Theme.of(context).brightness == Brightness.light?Colors.grey.shade100:Colors.grey.shade800),
                height: 50,
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("${massage.massage}"),
                      ),
                    ),
                    Align(
                        alignment: Alignment.bottomRight,
                        child: Padding(
                          padding: const EdgeInsets.all(0.0),
                          child: Text(
                            massage.time.toString(),
                            style: TextStyle(
                                color:Theme.of(context).brightness == Brightness.light?Colors.black38: Colors.white54,
                                fontSize: 11,
                                fontWeight: FontWeight.w600),
                          ),
                        )),
                  ],
                ))),
      ],
    );
  }
}
//assets/image/mapicon.png
class LocationCard extends StatelessWidget {
  const LocationCard({
    Key? key,
    required this.data,
    required this.newData,
  }) : super(key: key);
  final MassageModule data;
  final bool newData;

  @override
  Widget build(BuildContext context) {
    final sender = data.senderid == firebaseAuth.currentUser!.uid;
    return Row(
      mainAxisAlignment:
          sender ? MainAxisAlignment.end : MainAxisAlignment.start,
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
                      position: LatLng(data.locx!, data.loxy!),
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
                color: sender ? Colors.green : Theme.of(context).brightness == Brightness.light?Colors.grey.shade100:Colors.grey.shade800,
                borderRadius: BorderRadius.only(
                    bottomLeft: data.senderid == firebaseAuth.currentUser!.uid
                        ? const Radius.circular(10)
                        : Radius.zero,
                    bottomRight: data.senderid != firebaseAuth.currentUser!.uid
                        ? const Radius.circular(10)
                        : Radius.zero,
                    topLeft: const Radius.circular(10),
                    topRight: const Radius.circular(10)),
              ),
              width: 200,
              height: 140,
              child: Stack(
                children: [
                  Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                     width: 200,
              height: 110,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10)),image: DecorationImage(image: AssetImage("assets/image/mapicon.png"),fit: BoxFit.cover)),
                // child: Image.asset(),
                  )
                  ),
                  const Align(
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.location_on,color: Colors.white,
                      size: 50,
                    ),
                  ),
                  Align(
                      alignment: Alignment.bottomRight,
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text(
                          data.time.toString(),
                          style: TextStyle(
                            color:Theme.of(context).brightness == Brightness.light?Colors.black38: Colors.white54,
                              fontSize: 12, fontWeight: FontWeight.w600),
                        ),
                      )),
                ],
              ),
            )),
      ],
    );
  }
}
