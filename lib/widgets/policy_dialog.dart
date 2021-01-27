/*import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';

*/
/*class PolicyDialog extends StatelessWidget {
  PolicyDialog({
    Key key,
    this.radius = 8,
    @required this.mdFileName,
  })  : assert(mdFileName.contains('.md'),
            'The file must contain the .md extension'),
        super(key: key);

  final double radius;
  final String mdFileName;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius)),
      child: Column(
        children: [
          Expanded(
            child: FutureBuilder(
              future: Future.delayed(Duration(milliseconds: 150)).then((value) {
                return rootBundle.loadString('assets/$mdFileName');
              }),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  var style = MarkdownStyleSheet(
                    textAlign: WrapAlignment.start,
                    p: TextStyle(
                      fontSize: 16,
                      color: /*isDark ? Colors.white :*/ Colors.black,
                    ),
                    h2: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: /*isDark ? Colors.white :*/ Colors.red,
                    ),
                    h1: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                      color: /*isDark ? Colors.white :*/ Colors.red,
                    ),
                  );
                  return Markdown(
                    styleSheet: style,
                    data: snapshot.data,
                    selectable: true,
                    onTapLink: (String text, String href, String title) {
                      launch(href);
                      // setState((){});
                    },
                  );
                }
                return Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ),
          /* InkWell(
            child: Text(
              'My Hyperlink',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.blue,
                decoration: TextDecoration.underline
              ),
            ),
            onTap: () => launch('https://stackoverflow.com'),
          ),*/
          TextButton(
           /* padding: EdgeInsets.all(0),
            color: Theme.of(context).buttonColor,*/
            onPressed: () => Navigator.of(context).pop(),
            style: TextButton.styleFrom(
               backgroundColor: Theme.of(context).buttonColor,
               primary: Colors.white,
	
              shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(radius),
                        bottomRight: Radius.circular(radius),
                      ),
                    ),
               ),
            /*shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(radius),
                bottomRight: Radius.circular(radius),
              ),
            ),*/
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(radius),
                  bottomRight: Radius.circular(radius),
                ),
              ),
              alignment: Alignment.center,
              height: 50,
              width: double.infinity,
              child: Text(
                "Schliessen",
                style: TextStyle( fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).textTheme.button.color,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}*/
