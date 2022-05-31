import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:app_medicine/helpers/notification_service.dart';
import 'package:app_medicine/models/medicine.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditMedicineController extends ChangeNotifier {
  Medicine? medicine;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController descController = TextEditingController();
  XFile? xFile;
  TimeOfDay? selectedTime;
  TimeOfDay? timeOfDay;
  bool loading = false;
  String listInterval = '';
  String? imageUploadedName;
  List<String>? listRecomendations;
  int? intervalSelected;
  String notificationId = '';
  Uint8List? imageFile;
  String? imageUploaded;
  FirebaseStorage get storage => FirebaseStorage.instance;
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
    final double initalTime = double.parse(
      '${selectedTime!.hour}.${selectedTime!.minute < 10 ? 0 : ''}${selectedTime!.minute}',
    );
    double aux = initalTime + intervalSelected!.toDouble();
    final double interval = intervalSelected!.toDouble();

    if (aux <= 23) {
      final a = aux.toStringAsFixed(2).split('.');

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
      listInterval = '${aux.toStringAsFixed(2)} | ';
    } else {
      aux -= 24;
      final a = aux.toStringAsFixed(2).split('.');

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
      listInterval = '${aux.toStringAsFixed(2)} | ';
    }
    while (double.parse(aux.toStringAsFixed(2)) != initalTime) {
      aux += interval;
      if (aux >= 24) {
        aux -= 24;
        final a = aux.toStringAsFixed(2).split('.');

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
        listInterval = '$listInterval${aux.toStringAsFixed(2)} | ';
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
        listInterval = '$listInterval${aux.toStringAsFixed(2)} | ';
      }
    }
    return listInterval.replaceAll('.', ':');
  }

  void getRecomendInitialTime() {
    switch (intervalSelected) {
      case 2:
        listRecomendations = [
          '06:00',
          '08:00',
          '10:00',
          '12:00',
          '14:00',
          '16:00',
          '18:00',
          '20:00',
          '22:00',
          '00:00',
          '02:00',
          '04:00',
        ];
        break;
      case 3:
        listRecomendations = [
          '06:00',
          '09:00',
          '12:00',
          '15:00',
          '18:00',
          '21:00',
          '00:00',
          '03:00',
        ];
        break;
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

  Future uploadImagetoFireBase() async {
    final File file = File(xFile!.path);
    imageUploadedName = xFile!.name;
    final Reference _reference = storage.ref('images').child(xFile!.name);
    await _reference
        .putFile(
          file,
        )
        .then(
          (element) async => imageUploaded = await element.ref.getDownloadURL(),
        );

    notifyListeners();
  }

  Future saveMedicine() async {
    final BuildContext context = scaffoldKey.currentContext!;
    loading = true;
    notifyListeners();

    if (!formKey.currentState!.validate()) {
      loading = false;
      notifyListeners();
      return;
    }
    if (formKey.currentState!.validate()) {
      if (selectedTime == null) {
        _buildSnackBar(
          context: context,
          content: 'Selecione a hora!',
          duration: 1,
        );
        loading = false;
        notifyListeners();
      } else if (intervalSelected == null) {
        _buildSnackBar(
          context: context,
          content: 'Selecione um intervalo em horas!',
          duration: 1,
        );
        loading = false;
        notifyListeners();
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
        loading = false;
        notifyListeners();
      } else {
        if (xFile != null) {
          await uploadImagetoFireBase();
        }
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
            'image': xFile == null ? medicine!.image : imageUploaded,
            'dateInitial':
                '${DateTime.now().year}/${DateTime.now().month}/${DateTime.now().day}',
            'timeInitial':
                '${selectedTime!.hour}:${selectedTime!.minute < 10 ? 0 : ''}${selectedTime!.minute}',
            'interval': intervalSelected,
            'imageName':
                xFile != null ? imageUploadedName : medicine!.imageName,
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
          loading = false;
          notifyListeners();
        } catch (e) {
          loading = false;
          notifyListeners();
          _buildSnackBar(
            context: context,
            content: 'Ocorreu um erro ao atualizar o medicamento! Erro: $e',
            duration: 3,
          );
        }
      }
    }
  }

  Future pickImageFromCamera() async {
    xFile = await ImagePicker().pickImage(source: ImageSource.camera);
    if (xFile != null) {
      imageFile = await xFile!.readAsBytes();
      notifyListeners();
    }

    notifyListeners();
  }

  Future pickImageFromGallery() async {
    xFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (xFile != null) {
      imageFile = await xFile!.readAsBytes();
      notifyListeners();
    }
    notifyListeners();
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
    final hours = medicine.timeInitial!.split(':');
    selectedTime =
        TimeOfDay(hour: int.parse(hours[0]), minute: int.parse(hours[1]));
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
    imageFile = null;
    imageUploaded = null;
    imageUploadedName = null;
    xFile = null;
    notifyListeners();
  }
}
