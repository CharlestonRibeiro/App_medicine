import 'package:app_medicine/controller/edit_medicine_controller.dart';
import 'package:app_medicine/helpers/validators.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditFormFields extends StatelessWidget {
  const EditFormFields({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _controller = Provider.of<EditMedicineController>(context);
    return Form(
      key: _controller.formKey,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _controller.nameController,
              decoration: const InputDecoration(
                labelText: 'Nome do Medicamento*',
              ),
              validator: (name) {
                return nameMedicineValid(name!);
              },
            ),
            TextFormField(
              controller: _controller.descController,
              decoration: const InputDecoration(
                labelText: 'Descrição',
                // border: InputBorder.none
              ),
              maxLines: null,
              validator: (description) {
                return descValid(description!);
              },
            ),
          ],
        ),
      ),
    );
  }
}
