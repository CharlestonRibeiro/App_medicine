import 'package:app_medicine/controller/auth_service.dart';
import 'package:app_medicine/models/medicine.dart';
import 'package:app_medicine/screens/home_page/components/medicine_list_tile.dart';
import 'package:app_medicine/screens/home_page/components/search_dialog.dart';
import 'package:app_medicine/themes/app_text_styles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _MedicineScreenState();
}

class _MedicineScreenState extends State<HomeScreen> {
  String search = '';
  @override
  Widget build(BuildContext context) {
    final AuthService auth = Provider.of<AuthService>(context);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).pushNamed(
            '/add',
          );
        },
      ),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.search),
          onPressed: () async {
            search = await showDialog<String>(
                  context: context,
                  builder: (_) => SearchDialog(search),
                ) ??
                '';

            setState(
              () {
                search = search;
              },
            );
          },
        ),
        automaticallyImplyLeading: false,
        title: search.isEmpty
            ? Text('Medicine App', style: TextStyles.titleAppBar)
            : LayoutBuilder(
                builder: (_, constraints) {
                  return GestureDetector(
                    onTap: () async {
                      search = await showDialog<String>(
                            context: context,
                            builder: (_) => SearchDialog(search),
                          ) ??
                          '';

                      setState(() {
                        search = search;
                      });
                    },
                    child: SizedBox(
                      width: constraints.biggest.width,
                      child: Text(
                        search,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                },
              ),
        centerTitle: true,
        actions: [
          if (search.isEmpty) ...[
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () async {
                auth.logout();

                setState(() {});
              },
            ),
          ] else ...[
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () async {
                setState(() {
                  search = '';
                });
              },
            )
          ],
        ],
      ),
      body: StreamBuilder(
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text('Erro ao carregar os medicamentos'),
            );
          }
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                'Nenhum medicamento cadastrado!\nAdicione medicamentos para começar!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          }

          return ListView(
            children: snapshot.data!.docs.map(
              (document) {
                return MedicineListTile(
                  Medicine.fromDocument(document),
                );
              },
            ).toList(),
          );
        },
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(auth.usuario!.email)
            .collection('medicine')
            .orderBy('name')
            .where('name', isGreaterThanOrEqualTo: search)
            .snapshots(),
      ),
    );
  }
}
