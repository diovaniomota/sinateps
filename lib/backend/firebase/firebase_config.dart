import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

Future initFirebase() async {
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "AIzaSyB2YQlCtI5BRYAuII2l9Xg_kmzvs020asU",
            authDomain: "sinatep-d1f72.firebaseapp.com",
            projectId: "sinatep-d1f72",
            storageBucket: "sinatep-d1f72.appspot.com",
            messagingSenderId: "83524075646",
            appId: "1:83524075646:web:0b34eba436b6877f68582f",
            measurementId: "G-P0WTY62JX7"));
  } else {
    await Firebase.initializeApp();
  }
}
