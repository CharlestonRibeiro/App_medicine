import 'package:app_medicine/controller/add_medicine_controller.dart';
import 'package:app_medicine/screens/add_medicine/components/form_fields_widgets.dart';
import 'package:app_medicine/screens/add_medicine/components/images_form.dart';
import 'package:app_medicine/screens/add_medicine/components/list_button_time.dart';
import 'package:app_medicine/screens/add_medicine/components/time_picker.dart';
import 'package:app_medicine/themes/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddMedicineScreen extends StatefulWidget {
  const AddMedicineScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<AddMedicineScreen> createState() => _AddMedicineScreenState();
}

class _AddMedicineScreenState extends State<AddMedicineScreen> {
  SnackBar? snackBar;
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    final _controller = Provider.of<AddMedicineController>(context);

    return Scaffold(
      key: _controller.scaffoldKey,
      appBar: AppBar(
        title: const Text(
          'Registrar medicamento',
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        centerTitle: true,
      ),
      backgroundColor: ColorsApp.white,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _controller.saveMedicine();
        },
        child: const Icon(Icons.save_outlined),
      ),
      body: ListView(
        children: const [
          ImageForm(),
          AddFormFields(),
          ListButtonTime(),
          TimePickerWidget(),
        ],
      ),
    );
  }
}
