import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/user.dart';

class AuthMethod {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Login
  Future<String> login({
    required String email,
    required String password,
  }) async {
    String res = "Some error occurred";
    try {
      if (email.isEmpty || password.isEmpty) {
        return "Please fill all the fields";
      }

      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      res = "success";
    } on FirebaseAuthException catch (e) {
      res = e.message ?? "Authentication failed";
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  // Sign Up
  Future<String> signUpUser({
    required String email,
    required String password,
    required String username,
    File? file,
  }) async {
    String res = "Some error occurred";

    try {
      if (email.isEmpty || password.isEmpty || username.isEmpty || file == null) {
        return "Please fill all the fields and choose an image";
      }

      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      String uid = userCredential.user!.uid;

      // Upload profile picture
      String photoUrl = await uploadImageToStorage('profilePics/$uid', file);

      Users user = Users(
        uid: uid,
        email: email,
        username: username,
        bio: '',
        photoUrl: photoUrl,
        followers: [],
        following: [],
        posts: [],
        saved: [],
        searchKey: username.toLowerCase(),
      );

      await _firestore.collection("users").doc(uid).set(user.toJson());

      res = "success";
    } on FirebaseAuthException catch (e) {
      res = e.message ?? "Sign up failed";
    } catch (e) {
      res = e.toString();
    }

    return res;
  }

  // Upload function
  Future<String> uploadImageToStorage(String path, File file) async {
    Reference ref = _storage.ref().child(path);
    UploadTask uploadTask = ref.putFile(file);
    TaskSnapshot snap = await uploadTask;
    return await snap.ref.getDownloadURL();
  }

  // Get current user details
  Future<Users> getUserDetails() async {
    User currentUser = _auth.currentUser!;
    DocumentSnapshot snap =
        await _firestore.collection("users").doc(currentUser.uid).get();
    return Users.fromSnap(snap);
  }
}
