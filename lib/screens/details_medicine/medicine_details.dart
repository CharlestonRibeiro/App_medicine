// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:app_medicine/controller/details_medicine_controller.dart';
import 'package:app_medicine/controller/edit_medicine_controller.dart';
import 'package:app_medicine/themes/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DetailsMedicine extends StatelessWidget {
  const DetailsMedicine({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _controller = Provider.of<DetailsMedicineController>(context);
    final _editController = Provider.of<EditMedicineController>(context);
    final medicine = _controller.medicine!;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          '${_controller.medicine!.name}',
          style: TextStyles.titleAppBar,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              _editController.openEditPage(_controller.medicine!);
              Navigator.pushNamed(context, '/edit');
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              _controller.remove(context, _controller.medicine!.id!);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: medicine.id!,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  height: 300,
                  child: Center(
                    child: Material(
                      elevation: 15,
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: Image.network(
                          medicine.image!,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20).copyWith(top: 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(
                      '${medicine.name}',
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Divider(thickness: 1.5),
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      child: Text(
                        'Horários: ${medicine.listInterval}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  if (_controller.medicine!.description != '') ...[
                    const SizedBox(height: 10),
                    Text(
                      '${medicine.description}',
                      textAlign: TextAlign.justify,
                      style: const TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 20,
                      ),
                    ),
                  ],
                  const SizedBox(height: 15),
                  RichText(
                    text: TextSpan(
                      children: [
                        const TextSpan(
                          text: 'Início do tratamento: ',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 20,
                            color: Colors.black,
                          ),
                        ),
                        TextSpan(
                          text:
                              '${medicine.dateInitial} às ${medicine.timeInitial}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 20,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      child: Text(
                        'Intervalo: de ${medicine.interval} em ${medicine.interval} horas',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
