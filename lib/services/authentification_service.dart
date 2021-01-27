import 'package:firebase_auth/firebase_auth.dart';
//import 'package:fisch_aus_steinbachtal/models/cart_item.dart';
//import 'package:fisch_aus_steinbachtal/models/product.dart';
import 'package:fisch_aus_steinbachtal/models/user_model.dart';
import 'package:fisch_aus_steinbachtal/services/firestore_services.dart';
import 'package:fisch_aus_steinbachtal/services/user_secure_storage.dart';
import 'package:flutter/material.dart';

class AuthenticationService with ChangeNotifier {
  String errorMessage = '';
  String get getErrorMessage => errorMessage;

  final FirebaseAuth _firebaseAuth;
  final FirestoreService _firestoreService = FirestoreService();

  AuthenticationService(this._firebaseAuth);

  /// Changed to idTokenChanges as it updates depending on more cases.
  Stream<User> get authStateChanges => _firebaseAuth.idTokenChanges();
  Stream<User> get user => _firebaseAuth.authStateChanges();
  String get userId => _firebaseAuth.currentUser.uid ?? '';
  String get email => _firebaseAuth.currentUser.isAnonymous
      ? ''
      : _firebaseAuth.currentUser.email ?? '';
  String get name =>
      _firebaseAuth.currentUser.isAnonymous ? 'Gast' : appUser.name ?? '';
  String get phone =>
      _firebaseAuth.currentUser.isAnonymous ? '' : appUser.phone ?? '';

  UserModel appUser;
  // List<CartItemModel> get cart => appUser != null ? appUser.cart : [];
  // double get cartTotal => appUser != null ? appUser.totalCartPrice : 0.0;
  bool get isAdmin =>
      !isGuest && appUser != null ? appUser.role == 'admin' : false;
  bool get isVendor =>
      !isGuest && appUser != null ? appUser.role == 'vendor' : false;
  bool get isCustomer =>
      !isGuest && appUser != null ? appUser.role == 'customer' : true;
  bool get isGuest =>
      _firebaseAuth.currentUser != null &&
      _firebaseAuth.currentUser.isAnonymous;

  bool orderInProgress = false;

  Future<String> signOut() async {
    try {
      // GoogleSignIn().signOut();
      await _firebaseAuth.signOut();
      appUser = null;
      SecureStorage().empty();
      notifyListeners();
      return "Signed out";
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      rethrow;
    }
  }

  Future<String> doAnonymousLogin() async {
    try {
      UserCredential authResult = await _firebaseAuth.signInAnonymously();
      print(authResult.user.uid);
      notifyListeners();
      return "Gast ist angemeldet";
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      rethrow;
    }
  }

  /* static signInWithGoogle() async {
    GoogleSignIn googleSignIn = GoogleSignIn();
    final acc = await googleSignIn.signIn();
    final auth = await acc.authentication;
    final credential = GoogleAuthProvider.credential(
        accessToken: auth.accessToken, idToken: auth.idToken);
    final res = await _firebaseAuth.signInWithCredential(credential);
    return res.user;
  }*/

  Future<String> signIn({String email, String password}) async {
    try {
      UserCredential authResult = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);

      appUser = await _firestoreService.fetchUser(authResult.user.uid);

      notifyListeners();
      return "Benutzer '$email' ist angemeldet";
    } /* on FirebaseAuthException catch (e) {
      errorMessage = e.message;
      return e.message;
    } */
    catch (e) {
      switch (e.code) {
        case "user-not-found":
          errorMessage = "Benutzer wurde nicht gefunden";
          print(errorMessage);
          break;
        case "wrong-password":
          errorMessage = "falsches Passwort";
          print(errorMessage);
          break;
        case "invalid-email":
          errorMessage = "ungültige E-Mail";
          print(errorMessage);
          break;
        default:
          errorMessage = "Die Anmeldedaten sind falsch";
      }
      return errorMessage;
      //rethrow;
    }
  }

  Future<String> createAccount(
      {String name, String email, String password, String phone}) async {
    try {
      UserCredential authResult = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      print('Konto ' + email + ' wurde erstellt');

      int createdAt =
          authResult.user.metadata.creationTime.millisecondsSinceEpoch;

      appUser = UserModel(
          userId: authResult.user.uid,
          email: email,
          name: name,
          phone: phone,
          createdAt: createdAt);

      //ApplicationUser(userId: authResult.user.uid, email: _email.value.trim());

      await _firestoreService.addUser(appUser);

      return "Signed up";
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      switch (e.code) {
        case "account-exist-with-different-credential":
          errorMessage = "Das Konto ist bereits registriert.";
          print(errorMessage);
          break;

        case "invalid-email":
          errorMessage = "ungültige E-Mail";
          print(errorMessage);
          break;
        default:
          errorMessage = "Die Registrierung hat fehlgeschlagen";
      }
      return errorMessage;
      //rethrow;
    }
  }

  Future<String> sendPasswordResetEmail({String email}) async {
    try {
      await _firebaseAuth
          .sendPasswordResetEmail(email: email)
          .then((value) => print("Check your mails"));
      return "Check Ihre Emails";
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      rethrow;
    }
  }

  /* Future<bool> removeFromCart(CartItemModel cartItem) async {
    try {
      cart.remove(cartItem);
      _firestoreService.removeFromCart(userId, cartItem);
      notifyListeners();
      return true;
    } catch (e) {
      print("THE ERROR ${e.toString()}");
      return false;
    }
  }*/

  /*Future<bool> emptyCart() async {
    try {
      _firestoreService.emptyCart(userId);
      cart.clear();
      notifyListeners();
      return true;
    } catch (e) {
      print("THE ERROR ${e.toString()}");
      return false;
    }
  }*/

  /*Future<bool> addToCart(
      Product product, int quantity, ProductUnit productUnit) async {
    try {
      //  var uuid = Uuid();
      String cartItemId = product.productId /*uuid.v4()*/;

      var cartItem = CartItemModel(
          id: cartItemId,
          image: product.imageUrl[0],
          name: product.productName,
          productId: product.productId,
          vendorId: product.vendorId,
          quantity: quantity,
          productUnit: productUnit);

      cart.add(cartItem);
      _firestoreService.addToCart(userId, cartItem);
      notifyListeners();
      return true;
    } catch (e) {
      print("THE ERROR ${e.toString()}");
      return false;
    }
  }*/

  /*Future<bool> reloadUserModel(String userId) async {
    appUser = await _firestoreService.fetchUser(userId);
    if (appUser == null) return false;

    notifyListeners();
    return true;
  }*/

  /*Future<bool> reloadUserModel1(String userId) async {
    appUser = await _firestoreService.fetchUser(userId);
    if (appUser == null) return false;

    // notifyListeners();
    return true;
  }*/

  /*Future<List<CartItemModel>> shoppingBag(String userId) async {
    appUser = await _firestoreService.fetchUser(userId);

    notifyListeners();
    return appUser.cart;
  }*/
}
