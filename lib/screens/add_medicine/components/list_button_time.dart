import 'package:app_medicine/controller/add_medicine_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ListButtonTime extends StatelessWidget {
  const ListButtonTime({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<AddMedicineController>(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Escolha o intervalo de horas para o medicamento',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.start,
            ),
          ),
          if (controller.intervalSelected != null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Text(
                'Intervalo selecionado: ${controller.intervalSelected} horas',
                style: const TextStyle(fontSize: 16),
              ),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Wrap(
              children: [
                ElevatedButton(
                  onPressed: () => controller.setIntervalSelected(2),
                  child: const Text('2'),
                ),
                const SizedBox(width: 5),
                ElevatedButton(
                  onPressed: () => controller.setIntervalSelected(3),
                  child: const Text('3'),
                ),
                const SizedBox(width: 5),
                ElevatedButton(
                  onPressed: () => controller.setIntervalSelected(4),
                  child: const Text('4'),
                ),
                const SizedBox(width: 5),
                ElevatedButton(
                  onPressed: () => controller.setIntervalSelected(6),
                  child: const Text('6'),
                ),
                const SizedBox(width: 5),
                ElevatedButton(
                  onPressed: () => controller.setIntervalSelected(8),
                  child: const Text('8'),
                ),
                ElevatedButton(
                  onPressed: () => controller.setIntervalSelected(12),
                  child: const Text('12'),
                ),
                const SizedBox(width: 5),
                ElevatedButton(
                  onPressed: () => controller.setIntervalSelected(24),
                  child: const Text('24'),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
