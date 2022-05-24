import 'dart:io';
import 'dart:math';

import 'package:app_medicine/helpers/notification_service.dart';
import 'package:app_medicine/models/medicine.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddMedicineController extends ChangeNotifier {
  Medicine medicine = Medicine(name: '', image: '');

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController descController = TextEditingController();
  double? total;
  XFile? xFile;
  String? imageUploaded;
  String? imageUploadedName;
  TimeOfDay? selectedTime;
  TimeOfDay? timeOfDay;
  bool loading = false;
  int? intervalSelected;
  List<String>? listRecomendations;
  FirebaseFirestore get firestore => FirebaseFirestore.instance;
  FirebaseStorage get storage => FirebaseStorage.instance;
  String listInterval = '';

  Future saveMedicine() async {
    final BuildContext context = scaffoldKey.currentContext!;
    final int random = Random().nextInt(1000000000);

    if (formKey.currentState!.validate()) {
      if (xFile == null || imageUploaded == null) {
        _buildSnackBar(
          context: context,
          content: 'Selecione uma imagem!',
          duration: 1,
        );
      } else if (selectedTime == null) {
        _buildSnackBar(
          context: context,
          content: 'Selecione a hora!',
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
      } else if (intervalSelected == null) {
        _buildSnackBar(
          context: context,
          content: 'Selecione um intervalo em horas!',
          duration: 1,
        );
      } else {
        try {
          await firestore
              .collection('users')
              .doc(FirebaseAuth.instance.currentUser!.email)
              .collection('medicine')
              .doc('$random')
              .set({
            'id': random,
            'name': nameController.text,
            'description': descController.text,
            'image': imageUploaded,
            'dateInitial':
                '${DateTime.now().year}/${DateTime.now().month}/${DateTime.now().day}',
            'timeInitial': '${selectedTime!.hour}:${selectedTime!.minute}',
            'interval': intervalSelected,
            'imageName': imageUploadedName,
            'listInterval': getInterval(),
          });

          _buildSnackBar(
            context: context,
            content: 'O medicamento foi salvo com sucesso!',
            duration: 3,
          );

          clean();
          closePage();

          NotificationService().showNotificationPeriodic(
            CustomNotification(
              id: random,
              title: 'Não esqueça de tomar seus remédios!',
              body: 'Acesse à lista de medicamentos!',
              payload: '/',
            ),
          );
        } catch (e) {
          _buildSnackBar(
            context: context,
            content: 'Ocorreu um erro ao salvar o medicamento!$e',
            duration: 3,
          );
        }
      }
    }
  }

  String getInterval() {
    final double initalTime =
        double.parse('${selectedTime!.hour}.${selectedTime!.minute}');
    double aux = initalTime + intervalSelected!.toDouble();
    final double interval = intervalSelected!.toDouble();

    if (aux <= 23) {
      listInterval = '${aux.toStringAsFixed(2)} ';
    } else {
      listInterval = '${(aux - 24).toStringAsFixed(2)}} ';
    }
    while (double.parse(aux.toStringAsFixed(2)) != initalTime) {
      aux += interval;
      if (aux >= 24) {
        aux -= 24;
        listInterval = '$listInterval${aux.toStringAsFixed(2)} ';
      } else {
        listInterval = '$listInterval${aux.toStringAsFixed(2)} ';
      }
    }
    return listInterval.replaceAll('.', ':');
  }

  void closePage() {
    Navigator.pop(scaffoldKey.currentContext!);
  }

  Future pickImageFromCamera() async {
    xFile = await ImagePicker().pickImage(source: ImageSource.camera);
    notifyListeners();
    uploadImage();
  }

  Future pickImageFromGallery() async {
    xFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    notifyListeners();
    uploadImage();
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

  void setIntervalSelected(int interval) {
    intervalSelected = interval;
    getRecomendInitialTime();
    notifyListeners();
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

  Future uploadImage() async {
    final BuildContext context = scaffoldKey.currentContext!;
    if (xFile != null) {
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          actions: [
            TextButton(
              onPressed: () {
                notifyListeners();
                Navigator.pop(context);
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                uploadImagetoFireBase();
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
          title: const Text('Deseja enviar o arquivo?'),
        ),
      );
    }
  }

  Future uploadImagetoFireBase() async {
    loading = true;
    notifyListeners();
    final File file = File(xFile!.path);
    final Reference _reference = storage.ref('images').child(xFile!.name);
    final UploadTask task = _reference.putFile(
      file,
    );
    task.snapshotEvents.listen((snapshot) async {
      if (snapshot.state == TaskState.running) {
        total = snapshot.bytesTransferred / snapshot.totalBytes;
        notifyListeners();
      } else if (snapshot.state == TaskState.success) {
        imageUploaded = await snapshot.ref.getDownloadURL();
        imageUploadedName = xFile!.name;
        medicine.copyWith(image: imageUploaded);
        notifyListeners();
      }
    });
    loading = false;
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

  void clean() {
    nameController.clear();
    descController.clear();
    xFile = null;
    imageUploaded = null;
    total = 0;
    selectedTime = null;
    timeOfDay = null;
    intervalSelected = null;
    listInterval = '';
    listRecomendations = null;
    notifyListeners();
  }
}
