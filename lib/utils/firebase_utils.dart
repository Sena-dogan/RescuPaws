import 'package:firebase_auth/firebase_auth.dart';

/// Firebase Utils 
/// Contains all the firebase related functions, types and extensions

String get currentUserUid => FirebaseAuth.instance.currentUser!.uid;

typedef FirebaseUser = User;
