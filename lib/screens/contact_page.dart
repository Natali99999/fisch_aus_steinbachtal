import 'package:fisch_aus_steinbachtal/helper/colors.dart';
import 'package:fisch_aus_steinbachtal/models/contact.dart';
//import 'package:fisch_aus_steinbachtal/services/contact_service.dart';
import 'package:fisch_aus_steinbachtal/services/url_launcher_service.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';

import 'package:provider/provider.dart';

class ContactPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  Completer<GoogleMapController> _controller = Completer();
  BitmapDescriptor customIcon;
  BitmapDescriptor icon;
  Set<Marker> markers;

  bool init = false;
 
  @override
  void initState() {
    getIcons();
    super.initState();
  
    markers = Set.from([]);
  }

  getIcons() async {
    var icon = BitmapDescriptor.defaultMarker;
    setState(() {
      this.icon = icon;
    });
  }

  Set<Marker> _createMarker(String firma, String firma2, LatLng posAddress) {
    markers.add(Marker(
      markerId: MarkerId("MarkerCurrent"),
      position: posAddress,
      icon: icon,
      infoWindow: InfoWindow(
        title: firma /*"Fischräucherei"*/,
        snippet: firma2 /*"Steinbachtal"*/,
      ),
    ));

    return markers;
  }

  Widget buildRaisedButton(String text, dynamic event) {
    return ElevatedButton(
      onPressed: event,
      child: Text(text),
    );
  }

  @override
  Widget build(BuildContext context) {
    /*return FutureBuilder<dynamic>(
        future: ContactDataServices().getContactData(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          ContactData contactData = snapshot.data;*/
          ContactData contactData = Provider.of<ContactData>(context);

          LatLng posAddress = LatLng(
              contactData.geopoint.latitude, contactData.geopoint.longitude);
          Position pos = Position(
              longitude: contactData.geopoint.longitude,
              latitude: contactData.geopoint.latitude);

          if (!init) {
            centerScreen(pos);
            init = true;
          }
          _createMarker(contactData.firma, contactData.firma2, posAddress);

          return Scaffold(
              bottomNavigationBar: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: FaIcon(
                      Icons.phone,
                      color: AppColors.lightblue,
                    ),
                    onPressed: () {
                      launchCALL(contactData.whatsApp);
                    },
                  ),
                  IconButton(
                    icon: FaIcon(
                      FontAwesomeIcons.whatsappSquare,
                      color: Colors.green,
                    ),
                    onPressed: () {
                      launchWhatsApp(number: contactData.whatsApp, message: '');
                    },
                  ),
                  IconButton(
                    icon: FaIcon(
                      FontAwesomeIcons.sms,
                      color: AppColors.lightblue,
                    ),
                    onPressed: () {
                      launchSMS(contactData.whatsApp);
                    },
                  ),
                  IconButton(
                    icon: FaIcon(
                      Icons.email,
                      color: AppColors.lightblue,
                    ),
                    onPressed: () {
                      launchEMAIL(contactData.email, 'Anfrage', '');
                    },
                  ),
                  SizedBox(width: 40),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: AppColors.lightblue,
                      onPrimary: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50.0),
                          side:
                              BorderSide(color: AppColors.lightblue, width: 2)),
                    ),
                    child: Text(
                      'Route zeigen',
                    ),
                    onPressed: () {
                      launchMapURL(contactData.mapUrl);
                    },
                  ),
                ],
              ),
              appBar: AppBar(
                // centerTitle: true,
                elevation: 0.1,
                backgroundColor: Colors.black,
                title: InkWell(
                  child: Text('Kontakt'),
                ),
              ),
              body: Stack(children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height - 50.0,
                  width: MediaQuery.of(context).size.width,
                  child: GoogleMap(
                    initialCameraPosition:
                        CameraPosition(target: posAddress /*, zoom: 7.5*/),
                    mapType: MapType.satellite,
                    // myLocationEnabled: true,
                    onMapCreated: (GoogleMapController controller) {
                      _controller.complete(controller);
                    },
                    //  myLocationButtonEnabled: true,
                    // mapToolbarEnabled: true,
                    minMaxZoomPreference: MinMaxZoomPreference(12, 20),
                    markers: markers,
                  ),
                ),
                Positioned(
                    bottom: 20.0,
                    child: Container(
                        height: 200.0,
                        width: MediaQuery.of(context).size.width,
                        child: Stack(children: [
                          Container(
                            margin: EdgeInsets.symmetric(
                              horizontal: 10.0,
                              vertical: 20.0,
                            ),
                            height: 140.0,
                            width: 275.0,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black54,
                                    offset: Offset(0.0, 4.0),
                                    blurRadius: 10.0,
                                  ),
                                ]),
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  color: Colors.white),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 5, top: 5.0),
                                            child: Container(
                                                height: 90.0,
                                                width: 90.0,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.only(
                                                          bottomLeft:
                                                              Radius.circular(
                                                                  10.0),
                                                          topLeft:
                                                              Radius.circular(
                                                                  10.0)),
                                                  image: DecorationImage(
                                                    image: NetworkImage(
                                                        contactData.visitingcartPhoto),
                                                    fit: BoxFit.cover,
                                                    /* placeholder:
                                                AssetImage(Base.placeholderImage)*/
                                                  ), /*AssetImage(
                                                            Base.visitingcardPhoto),
                                                        fit: BoxFit.cover)*/
                                                )),
                                          ),
                                        ],
                                      ),
                                      SizedBox(width: 10.0),
                                      Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              padding: EdgeInsets.only(top: 5),
                                              child: Column(
                                                children: [
                                                  Text(
                                                    '${contactData.firma}',
                                                    style: TextStyle(
                                                        color:
                                                            AppColors.lightblue,
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Text(
                                                    '${contactData.firma2}',
                                                    style: TextStyle(
                                                        color:
                                                            AppColors.lightblue,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              height: 4,
                                            ),
                                            Text(
                                              '${contactData.firstname} ${contactData.name}',
                                              style: TextStyle(
                                                  fontSize: 13.0,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            SizedBox(
                                              height: 2,
                                            ),
                                            Text(
                                              '${contactData.street} ${contactData.homeNr}',
                                              style: TextStyle(
                                                  fontSize: 12.0,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            Text(
                                              '${contactData.postCode} ${contactData.town}',
                                              style: TextStyle(
                                                  fontSize: 12.0,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            SizedBox(
                                              height: 2,
                                            ),
                                            Container(
                                              width: 170.0,
                                              child: Text(
                                                contactData.mobilePhone,
                                                style: TextStyle(
                                                    fontSize: 13.0,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                            ),
                                          ])
                                    ],
                                  ),
                                  SizedBox(
                                    height: 7,
                                  ),
                                  Container(
                                    width: 270.0,
                                    child: InkWell(
                                      onTap: () {
                                        launchFacebook(contactData.facebookUrl);
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(FontAwesomeIcons.facebook,
                                              color: Colors.blue[800]),
                                          SizedBox(width: 5),
                                          Text(
                                            contactData.facebook
                                            /* 'Fischräucherei\nSteinbachtal'*/,
                                            style: TextStyle(
                                                color: Colors.blue[800],
                                                fontSize: 13.0,
                                                fontWeight: FontWeight.w400),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ])))
              ]));
      /*   });*/
  }

  Future<void> centerScreen(Position position) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(position.latitude, position.longitude), zoom: 18.0)));
  }
}
