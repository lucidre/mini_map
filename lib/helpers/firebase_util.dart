import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

FirebaseFirestore sFirebaseCloud = FirebaseFirestore.instance;
FirebaseAuth sFirebaseAuth = FirebaseAuth.instance;

CollectionReference<Map<String, dynamic>> collectionRefLocations =
    sFirebaseCloud.collection('locations');
