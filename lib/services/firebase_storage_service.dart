import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as Path;

class FirebaseStorageService {
  final storage = FirebaseStorage.instance;

  Future<String> uploadProductImage(
      File file, String fileName, String vendorId, String productId) async {
    Reference reference =
        storage.ref().child('productImages/$vendorId/$productId/$fileName');
    UploadTask uploadTask = reference.putFile(file);

    var snapshot = await uploadTask.whenComplete(() {});

    return await snapshot.ref.getDownloadURL();
  }

  Future<String> uploadVendorImage(File file, String fileName) async {
    Reference reference = storage.ref().child('vendorImages/$fileName');
    UploadTask uploadTask = reference.putFile(file);

    var snapshot = await uploadTask.whenComplete(() {});

    return await snapshot.ref.getDownloadURL();
  }

  Future<void> delete(String imageFileUrl) async {
    var fileUrl = Uri.decodeFull(Path.basename(imageFileUrl))
        .replaceAll(new RegExp(r'(\?alt).*'), '');

    final Reference firebaseStorageRef = storage.ref().child(fileUrl);
    if (firebaseStorageRef != null) {
      await firebaseStorageRef.delete().then((_) {
        print('Successfully deleted $fileUrl storage item');
      });
    }
  }

  static Future<dynamic> loadFromStorage(String image) async {
    return await FirebaseStorage.instance.ref().child(image).getDownloadURL();
  }
}
