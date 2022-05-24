import 'package:app_medicine/screens/login_page/components/form.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBlueColor,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text('Medicine App'),
        centerTitle: true,
      ),
      body: const Center(
        child: FormLogin(),
      ),
    );
  }
}

const kBlueColor = Color.fromARGB(255, 98, 191, 237);
const kGreyColor = Color.fromARGB(255, 42, 50, 56);
const kYellowColor = Color.fromARGB(255, 185, 185, 114);
const kWhiteColor = Color.fromARGB(255, 255, 255, 255);
const kBlackColor = Color.fromARGB(255, 0, 0, 0);
const kGreenColor = Color.fromARGB(255, 14, 58, 52);
