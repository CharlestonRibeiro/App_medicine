import 'package:app_medicine/controller/edit_medicine_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditTimePickerWidget extends StatelessWidget {
  const EditTimePickerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _controller = Provider.of<EditMedicineController>(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Selecione a hora em que o alarme irá iniciar',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          if (_controller.listRecomendations != null)
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 10,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Horarios recomendados para o intervalo',
                    style: TextStyle(fontSize: 16),
                  ),
                  Wrap(
                    children: _controller.listRecomendations!
                        .map(
                          (e) => Text(
                            '$e | ',
                            style: const TextStyle(fontSize: 16),
                          ),
                        )
                        .toList(),
                  )
                ],
              ),
            ),
          if (_controller.selectedTime != null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Text(
                'Tempo selecionado: ${_controller.selectedTime!.hour} horas e ${_controller.selectedTime!.minute} minutos',
                style: const TextStyle(fontSize: 16),
              ),
            ),
          Row(
            children: [
              ElevatedButton(
                onPressed: () {
                  _controller.selectTime();
                },
                child: const Text('Selecionar'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
