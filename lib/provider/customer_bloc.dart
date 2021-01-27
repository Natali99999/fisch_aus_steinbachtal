import 'package:fisch_aus_steinbachtal/models/product.dart';
import 'package:fisch_aus_steinbachtal/services/firestore_services.dart';

class CustomerBloc {
  final db = FirestoreService();

  Stream<List<Product>> get fetchAvailableProducts =>
      db.fetchAvailableProducts();

  dispose() {}
}
