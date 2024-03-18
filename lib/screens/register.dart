import 'package:blogapp/models/api_response.dart';
import 'package:blogapp/screens/login.dart';
import 'package:blogapp/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constant.dart';
import '../models/user.dart';
import 'home.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  bool loading = false;
  TextEditingController emailController = TextEditingController(),
      nameController = TextEditingController(),
      passwordController = TextEditingController(),
      passwordConfirmedController = TextEditingController();

  void _registerUser() async {
    ApiResponse response = await register(
        nameController.text, emailController.text, passwordController.text);
    if (response.error == null) {
      _saveAndRedirectToHome(response.data as User);
    } else {
      setState(() {
        loading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('${response.error}'),
      ));
    }
  }

  void _saveAndRedirectToHome(User user) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString('token', user.token ?? "");
    await pref.setInt('userId', user.id ?? 0);

    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => Home()), (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Register',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: Form(
        key: formkey,
        child: ListView(
          padding: const EdgeInsets.all(32),
          children: [
            TextFormField(
              controller: nameController,
              validator: (val) => val!.isEmpty ? 'Invalid name' : null,
              decoration: kInputDecoration("Name"),
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              controller: emailController,
              validator: (val) => val!.isEmpty ? 'Invalid email address' : null,
              decoration: kInputDecoration("Email"),
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: passwordController,
              obscureText: true,
              validator: (val) =>
                  val!.length < 6 ? 'Required at least 6 chars' : null,
              decoration: kInputDecoration("Password"),
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: passwordConfirmedController,
              obscureText: true,
              validator: (val) =>
                  val != passwordController.text ? 'Confirm password does not match' : null,
              decoration: kInputDecoration("Password confirmation"),
            ),
            const SizedBox(
              height: 10,
            ),
            loading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : kTextButton("Rgister", () {
                    if (formkey.currentState!.validate()) {
                      setState(() {
                        loading = true;
                        _registerUser();
                      });
                    }
                  }),
            const SizedBox(
              height: 10,
            ),
            kLoginRegisterHint("Do you have an account?", "Login", () {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => Login()),
                  (route) => false);
            })
          ],
        ),
      ),
    );
  }
}
