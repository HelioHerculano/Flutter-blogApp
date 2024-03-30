import 'dart:io';

import 'package:blogapp/constant.dart';
import 'package:blogapp/screens/login.dart';
import 'package:blogapp/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';

import '../models/api_response.dart';
import '../models/user.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  User? user;
  bool _loading = true;

  File? _imageFile;
  final _picker = ImagePicker();
  TextEditingController _txtNameController = TextEditingController();

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  Future getImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> getUser() async {
    ApiResponse response = await getUserDetail();
    if (response.error == null) {
      setState(() {
        user = response.data as User;
        _loading = false;
        _txtNameController.text = user!.name ?? '';
      });
    } else if (response.error == unauthorized) {
      logout().then((value) => {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => Login()),
                (route) => false)
          });
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('${response.error}')));
    }
  }

  void updateProfile() async {
    ApiResponse response =
        await updateUser(_txtNameController.text, getStringImage(_imageFile));
    setState(() {
      _loading = false;
    });

    if (response.error == null) {
      
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('${response.data}')));

    } else if (response.error == unauthorized) {
      logout().then((value) => {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => Login()),
                (route) => false)
          });
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('${response.error}')));
    }
  }

  @override
  void initState() {
    getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _loading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Padding(
            padding: EdgeInsets.only(top: 40, left: 40, right: 40),
            child: ListView(
              children: [
                Center(
                  child: GestureDetector(
                    child: Container(
                      width: 110,
                      height: 110,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(60),
                          image: _imageFile == null
                              ? user!.image != null
                                  ? DecorationImage(
                                      image: NetworkImage("${user!.image}"),
                                      fit: BoxFit.cover,
                                    )
                                  : null
                              : DecorationImage(
                                  image: FileImage(_imageFile ?? File("")),
                                  fit: BoxFit.cover),
                          color: Colors.amber),
                    ),
                    onTap: () {
                      getImage();
                    },
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Form(
                    key: _formkey,
                    child: TextFormField(
                      decoration: kInputDecoration("Name"),
                      controller: _txtNameController,
                      validator: (val) => val!.isEmpty ? 'Invalid Name' : null,
                    )),
                SizedBox(
                  height: 20,
                ),
                kTextButton("Update", () {
                  if (_formkey.currentState!.validate()) {
                    setState(() {
                      _loading = true;
                    });
                    updateProfile();
                  }
                })
              ],
            ),
          );
  }
}
