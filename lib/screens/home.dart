import 'package:blogapp/screens/login.dart';
import 'package:blogapp/services/user_service.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: GestureDetector(
          onTap: () {
            logout().then((value) => {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => Login()), (route) => false)
            });
          },
          child: Text("Home: press to logout"),
        ),
      ),
    );
  }
}
