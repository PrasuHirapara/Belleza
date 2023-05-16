import 'package:firebase_auth/firebase_auth.dart';


final String adminId = "ieDmUFNqFMWmZmCLoNldGQqNDcI3";
final bool isAdmin = FirebaseAuth.instance.currentUser!.uid == adminId;