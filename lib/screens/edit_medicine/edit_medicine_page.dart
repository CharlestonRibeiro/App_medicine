import 'package:app_medicine/controller/edit_medicine_controller.dart';
import 'package:app_medicine/screens/edit_medicine/components/edit_formfields_widgets.dart';
import 'package:app_medicine/screens/edit_medicine/components/image_widget.dart';
import 'package:app_medicine/screens/edit_medicine/components/list_button_time.dart';
import 'package:app_medicine/screens/edit_medicine/components/time_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditMedicinePage extends StatelessWidget {
  const EditMedicinePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _controller = Provider.of<EditMedicineController>(context);
    return Scaffold(
      key: _controller.scaffoldKey,
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          _controller.saveMedicine();
        },
        child: _controller.loading
            ? const CircularProgressIndicator(
                backgroundColor: Colors.white,
              )
            : const Icon(Icons.save_outlined),
      ),
      appBar: AppBar(
        title: const Text('Editar Medicamento'),
      ),
      body: ListView(
        children: const [
          EditImage(),
          EditFormFields(),
          EditListButtonTime(),
          EditTimePickerWidget(),
        ],
      ),
    );
  }
}
