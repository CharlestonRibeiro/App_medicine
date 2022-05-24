import 'package:app_medicine/controller/add_medicine_controller.dart';
import 'package:app_medicine/themes/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SaveButton extends StatelessWidget {
  const SaveButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _controller = Provider.of<AddMedicineController>(context);
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 50,
            width: 120,
            child: ElevatedButton(
              onPressed: () async {
                _controller.saveMedicine();
              },
              child: _controller.loading
                  ? const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(
                        ColorsApp.white,
                      ),
                    )
                  : const Text(
                      'Salvar',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
