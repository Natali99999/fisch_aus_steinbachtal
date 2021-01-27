import 'package:expandable_widget/res/expandable_text.dart';
import 'package:fisch_aus_steinbachtal/helper/base.dart';
import 'package:fisch_aus_steinbachtal/helper/colors.dart';
import 'package:fisch_aus_steinbachtal/helper/text.dart';
import 'package:fisch_aus_steinbachtal/models/contact.dart';
import 'package:fisch_aus_steinbachtal/screens/fullscreen_image.dart';
//import 'package:fisch_aus_steinbachtal/services/contact_service.dart';
import 'package:fisch_aus_steinbachtal/services/url_launcher_service.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fisch_aus_steinbachtal/helper/screen_navigation.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class LocationPage extends StatefulWidget {
  LocationPage();

  @override
  _LocationPageState createState() => new _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  StreamSubscription<QuerySnapshot> subscription;
  List<DocumentSnapshot> locationList;
  final CollectionReference collectionReference =
      FirebaseFirestore.instance.collection("location");
  
  @override
  void initState() {
    super.initState();

    subscription = collectionReference.snapshots().listen((datasnapshot) {
      setState(() {
        locationList = datasnapshot.docs;
      });
    });
  }

  @override
  void dispose() {
    subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ContactData contactData = Provider.of<ContactData>(context);
  
    return SafeArea(
        child: SingleChildScrollView(
      child: Padding(
        padding:
            const EdgeInsets.only(top: 10, left: 15.0, right: 10, bottom: 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "Eventlocation mit Grillplatz",
              style: TextStyles.pageTitleStyle,
              textAlign: TextAlign.left,
            ),

            SizedBox(height: 20),
            ExpandableText.lines(
              contactData.pageCelebrationText,
              lines: 2,
              textStyle: TextStyles.pageNormalStyle,
              arrowWidgetBuilder: (expanded) => Base.buildArrow(expanded),
            ),

            // Unsere Leistungen
            Text(
              'Unsere Leistungen',
              style: TextStyles.pageSubtitleStyle,
              textAlign: TextAlign.left,
            ),
            Divider(color: Colors.black38),
            SizedBox(height: 10),
            ExpandableText.lines(
              contactData.pageCelebrationText2,
              lines: 2,
              textStyle: TextStyles.pageNormalStyle,
              arrowWidgetBuilder: (expanded) => Base.buildArrow(expanded),
            ),
            // Kontakt
            Divider(color: Colors.black38),

            Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              Text(
                'Infos direkt anfragen',
                style: TextStyle(
                    fontFamily: 'Avenir', fontSize: 17, color: AppColors.red),
                textAlign: TextAlign.left,
              ),
              IconButton(
                icon: FaIcon(Icons.phone, color: AppColors.lightblue),
                onPressed: () {
                  launchCALL(contactData.whatsApp);
                },
              ),
              IconButton(
                icon: FaIcon(FontAwesomeIcons.whatsappSquare,
                    color: Colors.green),
                onPressed: () {
                  launchWhatsApp(number: contactData.whatsApp, message: '');
                },
              ),
              IconButton(
                icon: FaIcon(Icons.email, color: AppColors.lightblue),
                onPressed: () {
                  launchEMAIL(contactData.email, 'Fischplatten', '');
                },
              ),
            ]),

            Divider(color: Colors.black38),

            // Galerie
            Text(
              'Galerie',
              style: TextStyles.pageSubtitleStyle,
              textAlign: TextAlign.left,
            ),

            Container(
                height: 400,
                padding: const EdgeInsets.only(left: 20.0, top: 5),
                child: locationList != null
                    ? StaggeredGridView.countBuilder(
                        //  scrollDirection: Axis.horizontal,
                        primary: false,
                        shrinkWrap: true,
                        padding: const EdgeInsets.all(8.0),
                        crossAxisCount: 4,
                        itemCount: locationList.length,
                        itemBuilder: (context, i) {
                          String imgPath = locationList[i]['url'];
                          return Material(
                            elevation: 8.0,
                            borderRadius:
                                BorderRadius.all(new Radius.circular(8.0)),
                            child: new InkWell(
                              onTap: () {
                                // das Bild einzeln anzeigen
                                changeScreen(
                                    context,
                                    GalleryPage(
                                        imageList: locationList,
                                        curentIndex: i,
                                        title: 'Eventlocation'));
                              },
                              child: Hero(
                                tag: imgPath,
                                child: FadeInImage(
                                  image: NetworkImage(imgPath),
                                  fit: BoxFit.cover,
                                  placeholder:
                                      AssetImage(Base.placeholderImage),
                                ),
                              ),
                            ),
                          );
                        },
                        staggeredTileBuilder: (i) =>
                            StaggeredTile.count(2, i.isEven ? 2 : 3),
                        mainAxisSpacing: 8.0,
                        crossAxisSpacing: 8.0,
                      )
                    : Center(
                        child: new CircularProgressIndicator(),
                      )),
          ],
        ),
      ),
    ));
  }
}
