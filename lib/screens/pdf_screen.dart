import 'dart:convert';


import 'package:flutter/material.dart';
import 'dart:io';
import 'package:fisch_aus_steinbachtal/services/firebase_storage_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

//import 'package:flutter_full_pdf_viewer/full_pdf_viewer_scaffold.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
//import 'package:pdf/widgets.dart';

/*class PDFScreen extends StatelessWidget {
  final String title;
  final String pdfPath;
  final String pdfUrl;
  PDFScreen(this.title, this.pdfPath, this.pdfUrl);

  @override
  Widget build(BuildContext context) {
    return PDFViewerScaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text(title),
        ),
        path: pdfPath);
  }
}*/

class LaunchFile {
  /*static void launchPDF(
      BuildContext context, String title, String pdfPath, String pdfUrl) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PDFScreen(title, pdfPath, pdfUrl),
      ),
    );
  }*/

  
  static Future<dynamic> loadFromFirebase(
      BuildContext context, String url) async {
    return FirebaseStorageService.loadFromStorage(url);
  }

  static Future<dynamic> createFileFromPdfUrl(
      dynamic url, String filename) async {
    //print(filename);
    var request = await HttpClient().getUrl(Uri.parse(url));
    var response = await request.close();
    var bytes = await consolidateHttpClientResponseBytes(response);
    String dir = (await getApplicationDocumentsDirectory()).path;
    File file = new File('$dir/$filename');
    await file.writeAsBytes(bytes);
    return file;
  }

  static Future<dynamic> createFileDataFromUrl(dynamic url) async {
    var request = await HttpClient().getUrl(Uri.parse(url));
    var response = await request.close();
    var bytes = await consolidateHttpClientResponseBytes(response);
   
    return bytes;
  }
}

/*class PdfPage extends StatefulWidget {
  final String pageTitle;
  final String storageFilename;
  final String distFilename;

  PdfPage({this.pageTitle, this.storageFilename, this.distFilename});

  @override
  _PdfPageState createState() => _PdfPageState();
}

class _PdfPageState extends State<PdfPage> {
  String pdfPath = "";
  String pdfUrl = "";

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
      future: LaunchFile.loadFromFirebase(context, widget.storageFilename),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        String url = snapshot.data;
        return FutureBuilder<dynamic>(
            future: LaunchFile.createFileFromPdfUrl(url, widget.distFilename),
            builder: (context, snapshot) {
              if (!snapshot.hasData)
                return Center(
                  child: CircularProgressIndicator(),
                );

              dynamic f = snapshot.data;
              if (f is File) {
                // für App
                pdfPath = f.path;
              } else if (url is Uri) {
                // für Web
                pdfUrl = url.toString();
              }
              return PDFScreen(widget.pageTitle, pdfPath, pdfUrl);
             });
      },
    );
  }
}*/

class MarkdownPage extends StatefulWidget {
 
  final String storageFilename;
  MarkdownPage({this.storageFilename});

  @override
  _MarkdownPageState createState() => _MarkdownPageState();
}

class _MarkdownPageState extends State<MarkdownPage> {
 
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

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
      future: LaunchFile.loadFromFirebase(context, widget.storageFilename),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        String url = snapshot.data;
        return FutureBuilder<dynamic>(
            future: LaunchFile.createFileDataFromUrl(url),
            builder: (context, snapshot) {
              if (!snapshot.hasData)
                return Center(
                  child: CircularProgressIndicator(),
                );

               String fileData = Utf8Decoder().convert(snapshot.data);
              
              return Dialog(
                shape:
                    RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                child: Column(
                  children: [
                    Expanded(
                      child: Markdown(
                          styleSheet: style,
                          data: fileData,
                          selectable: true,
                          onTapLink: (String text, String href, String title) {
                            launch(href);
                            // setState((){});
                          },
                        ),
                      ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: TextButton.styleFrom(
                        backgroundColor: Theme.of(context).buttonColor,
                        primary: Colors.white,
            
                        shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(8),
                                  bottomRight: Radius.circular(8),
                                ),
                              ),
                        ),
                     
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(8),
                              bottomRight: Radius.circular(8),
                            ),
                          ),
                          alignment: Alignment.center,
                          height: 45,
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
          );
      },
    );
  }
}
