// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';

class Medicine extends ChangeNotifier {
  final String? id;
  final String? name;
  final String? image;
  final String? description;
  final String? dateInitial;
  final String? timeInitial;
  final String? interval;
  final String? imageName;
  final String? listInterval;
  final String? notificationsId;

  Medicine({
    this.id,
    this.name,
    this.image,
    this.description,
    this.dateInitial,
    this.timeInitial,
    this.interval,
    this.imageName,
    this.listInterval,
    this.notificationsId,
  });

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;

  DocumentReference get firestoreRef =>
      firestore.collection('medicine').doc(id);
  Reference get storageRef => storage.ref().child('medicines').child(id!);

  factory Medicine.fromDocument(QueryDocumentSnapshot<dynamic> map) {
    return Medicine(
      name: map['name'].toString(),
      image: map['image'].toString(),
      id: map.id,
      description: map['description'].toString(),
      dateInitial: map['dateInitial'].toString(),
      timeInitial: map['timeInitial'].toString(),
      interval: map['interval'].toString(),
      imageName: map['imageName'].toString(),
      listInterval: map['listInterval'].toString(),
      notificationsId: map['notificationsId'].toString(),
    );
  }

  void delete() {
    firestoreRef.delete();
  }

  Medicine copyWith({
    String? id,
    String? name,
    String? image,
    String? description,
    String? dateInitial,
    String? timeInitial,
    String? interval,
    String? imageName,
    String? listInterval,
  }) {
    return Medicine(
      id: id ?? this.id,
      name: name ?? this.name,
      image: image ?? this.image,
      description: description ?? this.description,
      dateInitial: dateInitial ?? this.dateInitial,
      timeInitial: timeInitial ?? this.timeInitial,
      interval: interval ?? this.interval,
      imageName: imageName ?? this.imageName,
      listInterval: listInterval ?? this.listInterval,
    );
  }
}
