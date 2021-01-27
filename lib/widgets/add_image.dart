import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fisch_aus_steinbachtal/models/product.dart';
import 'package:fisch_aus_steinbachtal/provider/product_provider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:provider/provider.dart';

class AddImage extends StatefulWidget {
  final Product product;

  AddImage({this.product});
  @override
  _AddImageState createState() => _AddImageState();
}

class _AddImageState extends State<AddImage> {
  bool uploading = false;
  CollectionReference imgRef;
  firebase_storage.Reference ref;
  List<File> _image = [];
  final picker = ImagePicker();

 @override
  void initState() {
    super.initState();
    imgRef = FirebaseFirestore.instance.collection('productImages');
  }
  
  @override
  Widget build(BuildContext context) {
    var productProvider = Provider.of<ProductProvider>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text('Bild hinzufügen'),
          actions: [
            TextButton(
                onPressed: () {
                  setState(() {
                    uploading = true;
                  });
                  productProvider
                      .uploadFile(_image)
                      .whenComplete(() => Navigator.of(context).pop());
                 },
                child: Text(
                  'Speichern',
                  style: TextStyle(color: Colors.white),
                ))
          ],
        ),
        body: Stack(
          children: [
            Container(
              padding: EdgeInsets.all(4),
              child: GridView.builder(
                  itemCount: _image.length + 1,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3),
                  itemBuilder: (context, index) {
                    return index == 0
                        ? Center(
                            child: IconButton(
                                icon: Icon(Icons.add),
                                onPressed: () =>
                                    !uploading ? chooseImage() : null),
                          )
                        : Container(
                            margin: EdgeInsets.all(3),
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: FileImage(_image[index - 1]),
                                    fit: BoxFit.cover)),
                          );
                  }),
            ),
            uploading
                ? Center(
                    child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        child: Text(
                          'uploading...',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      CircularProgressIndicator(
                        value: productProvider.val,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                      )
                    ],
                  ))
                : Container(),
          ],
        ));
  }

  chooseImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      _image.add(File(pickedFile?.path));
    });
    if (pickedFile.path == null) retrieveLostData();
  }

  Future<void> retrieveLostData() async {
    final LostData response = await picker.getLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      setState(() {
        _image.add(File(response.file.path));
      });
    } else {
      print(response.file);
    }
  }

 
}
