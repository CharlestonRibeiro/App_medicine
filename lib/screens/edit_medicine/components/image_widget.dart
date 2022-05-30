import 'package:app_medicine/controller/edit_medicine_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditImage extends StatelessWidget {
  const EditImage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _controller = Provider.of<EditMedicineController>(context);
    return Column(
      children: [
        if (_controller.medicine!.image != null &&
            _controller.xFile == null) ...[
          Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 50),
                child: SizedBox(
                  height: 200,
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: Image.network(
                      _controller.medicine!.image!,
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
