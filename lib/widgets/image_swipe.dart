import 'package:flutter/material.dart';

class ImageSwipe extends StatefulWidget {
  final List imageList;
  ImageSwipe({this.imageList});

  @override
  _ImageSwipeState createState() => _ImageSwipeState();
}

class _ImageSwipeState extends State<ImageSwipe> {
  int _selectedPage = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 300,
        child: Stack(
          children: [
            PageView(
              onPageChanged: (num) {
                setState(() {
                  _selectedPage = num;
                });
              },
              children: [
                if (widget.imageList.length == 0)
                  Placeholder(
                      fallbackHeight: 100.0, fallbackWidth: double.infinity)
                else
                  for (var i = 0; i < widget.imageList.length; i++)
                    Container(
                        child: Image.network("${widget.imageList[i]}",
                            fit: BoxFit.cover )),
               
              ],
            ),
            Positioned(
              bottom: 50,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (var i = 0; i < widget.imageList.length; i++)
                    AnimatedContainer(
                      duration: Duration(
                        milliseconds: 300,
                      ),
                      curve: Curves.easeOutCubic,
                      margin: EdgeInsets.symmetric(
                        horizontal: 5,
                      ),
                      width: _selectedPage == i ? 35 : 10,
                      height: 10,
                      decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.4),
                          borderRadius: BorderRadius.circular(12)),
                    ),
                ],
              ),
            ),
          ],
        ));
  }
}
