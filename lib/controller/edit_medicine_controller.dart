import 'dart:math';

import 'package:app_medicine/helpers/notification_service.dart';
import 'package:app_medicine/models/medicine.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EditMedicineController extends ChangeNotifier {
  Medicine? medicine;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController descController = TextEditingController();

  TimeOfDay? selectedTime;
  TimeOfDay? timeOfDay;
  bool loading = false;
  String listInterval = '';
  List<String>? listRecomendations;
  int? intervalSelected;
  String notificationId = '';
  FirebaseFirestore get firestore => FirebaseFirestore.instance;

  void setMedicine(Medicine medicine) {
    this.medicine = medicine;
    notifyListeners();
  }

  Future selectTime() async {
    timeOfDay = await showTimePicker(
      context: scaffoldKey.currentContext!,
      initialTime: TimeOfDay.now(),
    );
    if (timeOfDay != null && timeOfDay != selectedTime) {
      selectedTime = timeOfDay;
      notifyListeners();
    }
  }

  String getInterval() {
    final double initalTime =
        double.parse('${selectedTime!.hour}.${selectedTime!.minute}');
    double aux = initalTime + intervalSelected!.toDouble();
    final double interval = intervalSelected!.toDouble();

    if (aux <= 23) {
      final a =
          aux.toStringAsFixed(selectedTime!.minute > 9 ? 2 : 1).split('.');

      final random = Random().nextInt(100000);
      NotificationService().scheduleAtTimeNotification(
        CustomNotification(
          id: random,
          title: 'Não esqueça de tomar o ${nameController.text} agora!',
          body: 'Acesse à lista de medicamentos!',
          payload: '/',
        ),
        int.parse(a[0]),
        int.parse(a[1]),
      );
      notificationId = random.toString();
      listInterval = '${aux.toStringAsFixed(2)} ';
    } else {
      final a =
          aux.toStringAsFixed(selectedTime!.minute > 9 ? 2 : 1).split('.');

      final random = Random().nextInt(100000);
      NotificationService().scheduleAtTimeNotification(
        CustomNotification(
          id: random,
          title: 'Não esqueça de tomar o ${nameController.text} agora!',
          body: 'Acesse à lista de medicamentos!',
          payload: '/',
        ),
        int.parse(a[0]),
        int.parse(a[1]),
      );
      notificationId = random.toString();
      listInterval =
          '${(aux - 24).toStringAsFixed(selectedTime!.minute > 9 ? 2 : 1)} ';
    }
    while (double.parse(aux.toStringAsFixed(2)) != initalTime) {
      aux += interval;
      if (aux >= 24) {
        aux -= 24;
        final a =
            aux.toStringAsFixed(selectedTime!.minute > 9 ? 2 : 1).split('.');

        final random = Random().nextInt(100000);
        NotificationService().scheduleAtTimeNotification(
          CustomNotification(
            id: random,
            title: 'Não esqueça de tomar o ${nameController.text} agora!',
            body: 'Acesse à lista de medicamentos!',
            payload: '/',
          ),
          int.parse(a[0]),
          int.parse(a[1]),
        );
        notificationId = '$notificationId $random';
        listInterval =
            '$listInterval${aux.toStringAsFixed(selectedTime!.minute > 9 ? 2 : 1)} ';
      } else {
        final a = selectedTime!.minute > 9
            ? aux.toStringAsFixed(2).split('.')
            : aux.toStringAsFixed(1).split('.');
        final random = Random().nextInt(100000);
        NotificationService().scheduleAtTimeNotification(
          CustomNotification(
            id: random,
            title: 'Não esqueça de tomar o ${nameController.text} agora!',
            body: 'Acesse à lista de medicamentos!',
            payload: '/',
          ),
          int.parse(a[0]),
          int.parse(a[1]),
        );
        notificationId = '$notificationId $random';
        listInterval =
            '$listInterval${aux.toStringAsFixed(selectedTime!.minute > 9 ? 2 : 1)} ';
      }
    }
    return listInterval.replaceAll('.', ':');
  }

  void getRecomendInitialTime() {
    switch (intervalSelected) {
      case 4:
        listRecomendations = [
          '06:00',
          '10:00',
          '14:00',
          '18:00',
          '22:00',
          '02:00',
        ];
        break;
      case 6:
        listRecomendations = [
          '06:00',
          '12:00',
          '18:00',
          '00:00',
        ];
        break;
      case 8:
        listRecomendations = [
          '07:00',
          '15:00',
          '22:00',
        ];
        break;
      case 12:
        listRecomendations = [
          '08:00',
          '20:00',
        ];
        break;
      case 24:
        listRecomendations = [
          '08:00',
        ];
        break;
      default:
    }
    notifyListeners();
  }

  void setIntervalSelected(int interval) {
    intervalSelected = interval;
    getRecomendInitialTime();
    notifyListeners();
  }

  Future saveMedicine() async {
    final BuildContext context = scaffoldKey.currentContext!;

    if (formKey.currentState!.validate()) {
      if (selectedTime == null) {
        _buildSnackBar(
          context: context,
          content: 'Selecione a hora!',
          duration: 1,
        );
      } else if (intervalSelected == null) {
        _buildSnackBar(
          context: context,
          content: 'Selecione um intervalo em horas!',
          duration: 1,
        );
      } else if (FirebaseAuth.instance.currentUser == null) {
        _buildSnackBar(
          context: context,
          content: 'Faça login para adicionar medicamentos!',
          duration: 1,
          action: SnackBarAction(
            label: 'Fazer Login',
            onPressed: () => Navigator.pushNamed(context, '/'),
          ),
        );
      } else {
        try {
          cancelAllNotifications();
          await firestore
              .collection('users')
              .doc(FirebaseAuth.instance.currentUser!.email)
              .collection('medicine')
              .doc(medicine!.id)
              .update({
            'id': medicine!.id,
            'name': nameController.text,
            'description': descController.text,
            'image': medicine!.image,
            'dateInitial':
                '${DateTime.now().year}/${DateTime.now().month}/${DateTime.now().day}',
            'timeInitial': '${selectedTime!.hour}:${selectedTime!.minute}',
            'interval': intervalSelected,
            'listInterval': getInterval(),
            'notificationsId': notificationId,
          });

          _buildSnackBar(
            context: context,
            content: 'O medicamento foi atualizado com sucesso!',
            duration: 3,
          );

          clean();
          _navigatorPushNamed();
        } catch (e) {
          _buildSnackBar(
            context: context,
            content: 'Ocorreu um erro ao atualizar o medicamento! Erro: $e',
            duration: 3,
          );
        }
      }
    }
  }

  void cancelAllNotifications() {
    medicine!.notificationsId!.split(' ').forEach((element) {
      NotificationService().cancelLocalNotification(int.parse(element));
    });
  }

  void _navigatorPushNamed() {
    Navigator.pushReplacementNamed(scaffoldKey.currentContext!, '/home');
  }

  void openEditPage(Medicine medicine) {
    setMedicine(medicine);
    nameController.text = medicine.name!;
    descController.text = medicine.description!;
    intervalSelected = int.parse(medicine.interval!);
    getRecomendInitialTime();
    notifyListeners();
  }

  void _buildSnackBar({
    required BuildContext context,
    required String content,
    required int duration,
    SnackBarAction? action,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          content,
        ),
        action: action,
        duration: Duration(seconds: duration),
      ),
    );
  }

  void closePage() {
    Navigator.pop(scaffoldKey.currentContext!);
  }

  void clean() {
    nameController.clear();
    descController.clear();
    selectedTime = null;
    timeOfDay = null;
    intervalSelected = null;
    listRecomendations = null;
    listInterval = '';
    notifyListeners();
  }
}
