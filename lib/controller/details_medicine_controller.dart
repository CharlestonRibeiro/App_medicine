import 'package:app_medicine/helpers/notification_service.dart';
import 'package:app_medicine/models/medicine.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class DetailsMedicineController extends ChangeNotifier {
  Medicine? medicine;
  FirebaseFirestore get _fireStore => FirebaseFirestore.instance;

  void setMedicine(Medicine medicine) {
    this.medicine = medicine;
    notifyListeners();
  }

  void cancelAllNotifications() {
    medicine!.notificationsId!.split(' ').forEach((element) {
      NotificationService().cancelLocalNotification(int.parse(element));
    });
  }

  Future remove(BuildContext context, String id) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Não'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _removeDocument(id);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Medicamento foi removido com sucesso!'),
                  duration: Duration(seconds: 3),
                ),
              );
              cancelAllNotifications();
            },
            child: const Text('Sim'),
          ),
        ],
        title: const Text('Deseja remover o medicamento?'),
      ),
    );
  }

  Future _removeDocument(String id) async {
    await FirebaseStorage.instance
        .ref('images')
        .child(medicine!.imageName!)
        .delete();
    await _fireStore
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.email)
        .collection('medicine')
        .doc(id)
        .delete();
  }
}
