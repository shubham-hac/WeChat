import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthServices extends ChangeNotifier {
  // instance auth
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // instance firestore
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // sign in method
  Future<UserCredential> signInWithEmailandPassword(
      String email, String password) async {
    try {
      // signin
      UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);

          // add doc for existing user if not existing
      _firestore.collection('users').doc(userCredential.user!.uid).set({
        'uid': userCredential.user!.uid,
        'email': email,
      }, SetOptions(merge: true));

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  // new user
  Future<UserCredential> signUpWithEmailandPassword(
    String email,
    String password,
  ) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      // create a document for user in users collection
      _firestore.collection('users').doc(userCredential.user!.uid).set({
        'uid': userCredential.user!.uid,
        'email': email,
      });

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  // signed out method
  Future<void> signOut() async {
    return await FirebaseAuth.instance.signOut();
  }
}
