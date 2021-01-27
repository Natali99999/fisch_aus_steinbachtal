import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fisch_aus_steinbachtal/helper/base.dart';
import 'package:fisch_aus_steinbachtal/helper/colors.dart';
import 'package:fisch_aus_steinbachtal/helper/text.dart';
import 'package:flutter/material.dart';

/*class FullScreenImagePage extends StatelessWidget {
  final String imgPath;
  FullScreenImagePage(this.imgPath);

  final LinearGradient backgroundGradient = new LinearGradient(
      colors: [Color(0x10000000),  Color(0x30000000)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  SizedBox.expand(
        child:  Container(
          decoration:  BoxDecoration(gradient: backgroundGradient),
          child: Stack(
            children: <Widget>[
              new Align(
                alignment: Alignment.center,
                child:  Hero(
                  tag: imgPath,
                  child:  Image.network(imgPath),
                ),
              ),
              new Align(
                alignment: Alignment.topCenter,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                     AppBar(
                      elevation: 0.0,
                      backgroundColor: Colors.transparent,
                      leading: IconButton(
                        icon:  Icon(
                          Icons.close,
                          color: Colors.black,
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}*/

class GalleryPage extends StatefulWidget {
  final List<DocumentSnapshot> imageList;
  final int curentIndex;
  final String title;
  GalleryPage({this.imageList, this.curentIndex, this.title});
  @override
  _GalleryPageState createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {
  //String _currentImage =
  //widget.imageList[widget.curentIndex]['url'];

  final TransformationController _controller = TransformationController();
  int curentIndex;


  @override
  void initState() {
    curentIndex = widget.curentIndex;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title, style: TextStyles.pageTitleStyle),
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(
            Icons.close,
            color: Colors.black,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
             /* Text(
                'Galerie',
                style: TextStyle(
                    fontSize: 32,
                    fontFamily: 'avenir',
                    fontWeight: FontWeight.bold),
              ),*/
              /* Text(
                'Canon 250D',
                style: TextStyle(fontSize: 18, fontFamily: 'avenir'),
              ),*/
              Expanded(
                child: InteractiveViewer(
                  transformationController: _controller,
                  maxScale: 5.0,
                  child: FadeInImage(
                      image: NetworkImage(widget.imageList[curentIndex]['url']),
                      fit: BoxFit.cover,
                      placeholder:
                          AssetImage(Base.placeholderImage),
                    ),
                  
                 // Image.network(widget.imageList[curentIndex]['url']),
                  //Image.asset(_currentImage),
                ),
              ),
              Container(
                height: 80,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: widget.imageList.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          setState(() {
                            curentIndex = index;
                            _controller.value = Matrix4.identity();
                          });
                        },
                        child: Container(
                          margin: const EdgeInsets.all(8),
                          padding: const EdgeInsets.all(3),
                          color: AppColors.lightblue,
                          child: Image.network(widget.imageList[index]['url']),
                          // Image.asset(images[index]),
                        ),
                      );
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
