import 'package:app_medicine/controller/add_medicine_controller.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ImageForm extends StatelessWidget {
  const ImageForm();

  @override
  Widget build(BuildContext context) {
    final _controller = Provider.of<AddMedicineController>(context);
    return Column(
      children: [
        if (_controller.xFile == null) ...[
          const SizedBox(
            height: 200,
            child: Center(
              child: Text(
                'Nenhuma imagem selecionada\nSelecione uma imagem para continuar',
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildSelectButton(
                onPressed: () => _controller.pickImageFromCamera(),
                icon: Icons.camera,
                text: 'Camera',
              ),
              _buildSelectButton(
                onPressed: () => _controller.pickImageFromGallery(),
                icon: Icons.image,
                text: 'Galeria',
              ),
            ],
          )
        ] else ...[
          Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 50),
                child: SizedBox(
                  height: 200,
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: Image.memory(
                      _controller.imageFile!,
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildSelectButton(
                    onPressed: () => _controller.pickImageFromCamera(),
                    icon: Icons.camera,
                    text: 'Camera',
                  ),
                  _buildSelectButton(
                    onPressed: () => _controller.pickImageFromGallery(),
                    icon: Icons.image,
                    text: 'Galeria',
                  ),
                ],
              )
            ],
          ),
        ]
      ],
    );
  }

  Widget _buildSelectButton({
    required Function() onPressed,
    required String text,
    required IconData icon,
  }) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: ElevatedButton(
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(icon),
            Text(text),
          ],
        ),
      ),
    );
  }
}
