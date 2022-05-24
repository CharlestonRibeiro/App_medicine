import 'package:app_medicine/screens/login_page/login_page.dart';
import 'package:flutter/material.dart';

class LoginButton extends StatelessWidget {
  final Widget icon;
  final Function()? onPressed;
  const LoginButton({Key? key, required this.icon, this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 35,
      backgroundColor: kGreyColor,
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blue,
              Colors.yellow,
            ],
          ),
        ),
        child: IconButton(
          onPressed: onPressed,
          icon: icon,
          iconSize: 32,
          color: Colors.white,
        ),
      ),
    );
  }
}
