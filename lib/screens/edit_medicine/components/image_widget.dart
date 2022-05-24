import 'package:app_medicine/controller/edit_medicine_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditImage extends StatelessWidget {
  const EditImage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _controller = Provider.of<EditMedicineController>(context);
    return Hero(
      tag: _controller.medicine!.id!,
      child: SizedBox(
        height: 250,
        child: AspectRatio(
          aspectRatio: 1,
          child: Image.network(_controller.medicine!.image!),
        ),
      ),
    );
  }
}
