import 'package:app_medicine/controller/details_medicine_controller.dart';
import 'package:app_medicine/models/medicine.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MedicineListTile extends StatelessWidget {
  const MedicineListTile(
    this.medicine,
  );

  final Medicine medicine;

  @override
  Widget build(BuildContext context) {
    final _detailsController = Provider.of<DetailsMedicineController>(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: ListTile(
          onTap: () {
            _detailsController.setMedicine(medicine);
            Navigator.pushNamed(
              context,
              '/details',
            );
          },
          leading:
              Hero(tag: medicine.id!, child: Image.network(medicine.image!)),
          title: Text(medicine.name!),
          subtitle: Text(
            '${medicine.dateInitial} - ${medicine.timeInitial} '
            '| de ${medicine.interval} em ${medicine.interval} horas.\nHorários: ${medicine.listInterval}',
          ),
        ),
      ),
    );
  }
}
