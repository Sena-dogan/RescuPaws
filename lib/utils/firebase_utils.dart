import 'package:firebase_auth/firebase_auth.dart';

/// Firebase Utils 
/// Contains all the firebase related functions, types and extensions

String get currentUserUid => FirebaseAuth.instance.currentUser!.uid;
FirebaseUser get currentUser => FirebaseAuth.instance.currentUser!;

typedef FirebaseUser = User;
