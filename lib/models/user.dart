import 'package:cloud_firestore/cloud_firestore.dart';

class UserApp {
  UserApp({
    this.id,
    this.name,
    this.email,
    this.password,
    this.confirmPassword,
  });

  String? id;
  String? name;
  String? email;
  String? password;
  String? confirmPassword;

  DocumentReference get firestoreRef =>
      FirebaseFirestore.instance.collection('users').doc(id);

  Future<void> saveData() async {
    await firestoreRef.set(toMap());
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
    };
  }
}
