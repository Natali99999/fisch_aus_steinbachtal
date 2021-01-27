import 'dart:io';
import 'package:fisch_aus_steinbachtal/models/product.dart';
import 'package:fisch_aus_steinbachtal/services/firebase_storage_service.dart';
import 'package:fisch_aus_steinbachtal/services/firestore_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:image_picker/image_picker.dart';
//import 'package:permission_handler/permission_handler.dart';
import 'package:uuid/uuid.dart';

class ProductProvider with ChangeNotifier {
  final db = FirestoreService();
  var uuid = Uuid();
  final _picker = ImagePicker();
  final storageService = FirebaseStorageService();

  final List<String> itemsCategory = <String>['Produkt', 'Gericht', 'anders'];

  List<String> imageUrl = [];
  List<ProductUnit> units = [];
  String vendorId;
  String productCategory;
  String availableUnits;
  String productName;
  String description;
  bool saved = false;
  bool isUploading = false;
  Product product;
  String productId;

 /*dispose() {
    setUploading(false);
    setSaved(false);
  }*/

  Future<void> saveProduct() async {
    var _product = Product(
        approved: true,
        availableUnits: int.parse(availableUnits),
        productId: (product == null) ? uuid.v4() : product.productId,
        productName: productName,
        description: description,
        productCategory: itemsCategory[0] /*productCategory*/,
        vendorId: vendorId,
        imageUrl: imageUrl ?? [],
        units: units);

    return await db
        .setProduct(_product)
        .then((value) => setSaved(true))
        .catchError((error) => setSaved(false));
  }

  void setSaved(bool value) {
    saved = value;
    notifyListeners();
  }

  pickImage() async {
    PickedFile image;
    File croppedFile;

    //await Permission.photos.request();

   /* var permissionStatus = await Permission.photos.status;
    if (permissionStatus.isGranted) {*/
      //Get Image From Device
      image = await _picker.getImage(source: ImageSource.gallery);

      //Upload to Firebase
      if (image != null) {
        setUploading(true);

        //Get Image Properties
        ImageProperties properties =
            await FlutterNativeImage.getImageProperties(image.path);

        //CropImage
        if (properties.height > properties.width) {
          var yoffset = (properties.height - properties.width) / 2;
          croppedFile = await FlutterNativeImage.cropImage(image.path, 0,
              yoffset.toInt(), properties.width, properties.width);
        } else if (properties.width > properties.height) {
          var xoffset = (properties.width - properties.height) / 2;
          croppedFile = await FlutterNativeImage.cropImage(image.path,
              xoffset.toInt(), 0, properties.height, properties.height);
        } else {
          croppedFile = File(image.path);
        }

        //Resize
        File compressedFile = await FlutterNativeImage.compressImage(
            croppedFile.path,
            quality: 100,
            targetHeight: 600,
            targetWidth: 600);

        var imageUrl = await storageService.uploadProductImage(
            compressedFile, uuid.v4(), vendorId, productId);
        print(imageUrl);
        changeImageUrl(imageUrl);
        setUploading(false);
      } else {
        print('No Path Received');
      }
   /* } else {
      print('Grant Permissions and try again');
    }*/
  }

  void changeImageUrl(String _imageUrl) {
    if (_imageUrl != null) {
      imageUrl.add(_imageUrl);
      notifyListeners();
    } else
      imageUrl = [];
  }

  void changeUnit(ProductUnit _unit) {
    if (_unit != null) {
      units.add(_unit);
      //notifyListeners();
    } else
      units = [];
  }

  void removeUnit(ProductUnit _unit) {
    if (_unit != null) {
      units.remove(_unit);
      notifyListeners();
    } else
      units = [];
  }

  void setUploading(bool value) {
    isUploading = value;
    notifyListeners();
  }

  void changeProduct(Product value) {
    product = value;
    //notifyListeners();
  }

  /*void changeProductCategory(String value) {
    productCategory = value;
    //notifyListeners();
  }*/

  void changeProductName(String value) {
    productName = value;
    // notifyListeners();
  }

  void changeProductDescription(String value) {
    description = value;
    // notifyListeners();
  }

  void changeAvailableUnits(String value) {
    availableUnits = value;
    // notifyListeners();
  }

  Future<Product> fetchProduct(String productId) => db.fetchProduct(productId);
  Stream<List<Product>> productByVendorId(String vendorId) =>
      db.fetchProductsByVendorId(vendorId);

  loadValues(Product product, String _vendorId) {
    changeProduct(product);
    vendorId = _vendorId;

    if (product != null) {
      //Edit
      productId = product.productId;
      changeProductName(product.productName);
      changeProductDescription(product.description);
      // changeProductCategory(product.productCategory);
      changeAvailableUnits(product.availableUnits.toString());
      imageUrl = product.imageUrl ?? [];
      units = product.units ?? [];
    } else {
      //Add
      productId = uuid.v4();
      changeProductName('');
      changeProductDescription('');
      //  changeProductCategory('');
      changeAvailableUnits('');
      changeImageUrl(null);
      units = [];
     
      changeUnit(ProductUnit(price: 0.00, name: '100 g', text: 'pro 100 g'));
    }
  }

  double _val = 0;
  void setVal(double value) {
    _val = value;
    notifyListeners();
  }

  double get val => _val;

  Future uploadFile(List<File> _images) async {
    _val = 0;
   // await Permission.photos.request();

 /*   var permissionStatus = await Permission.photos.status;
    if (permissionStatus.isGranted) {*/
      int i = 1;
      File croppedFile;

      for (var img in _images) {
        setVal(i.toDouble());

        //Get Image Properties
        ImageProperties properties =
            await FlutterNativeImage.getImageProperties(img.path);

        if (properties.height > properties.width) {
          var yoffset = (properties.height - properties.width) / 2;
          croppedFile = await FlutterNativeImage.cropImage(
              img.path, 0, yoffset.toInt(), properties.width, properties.width);
        } else if (properties.width > properties.height) {
          var xoffset = (properties.width - properties.height) / 2;
          croppedFile = await FlutterNativeImage.cropImage(img.path,
              xoffset.toInt(), 0, properties.height, properties.height);
        } else {
          croppedFile = File(img.path);
        }

        //Resize
        File compressedFile = await FlutterNativeImage.compressImage(
            croppedFile.path,
            quality: 100,
            targetHeight: 600,
            targetWidth: 600);

        var _pathUrl = await storageService.uploadProductImage(
            compressedFile, uuid.v4(), vendorId, productId);
        print(imageUrl);
        if (_pathUrl.isNotEmpty) {
          imageUrl.add(_pathUrl);

          i++;
        }
     // }

      notifyListeners();
    }
  }

  void deleteImage(int index) async {
    if (index < imageUrl.length) {
      // Bild aus Pruduct/imageUrls löschen
      String removePath = imageUrl[index];
      imageUrl.removeAt(index);
      bool result = product != null
          ? await db.removeProductImage(productId, imageUrl)
          : true;
      if (result) {
        // Bild aus Firestore storage löschen
        await storageService.delete(removePath);

        print("tile number#$index is deleted");
      } else {}

      notifyListeners();
    }
  }

  deleteProductImages() async {
    for (var img in imageUrl) {
      if (img != null) {
        await storageService.delete(img);
      }
    }
  }

  Future<void> removeProduct(String productId) async {
    await deleteProductImages();
    return db.removeProduct(productId);
  }
}
