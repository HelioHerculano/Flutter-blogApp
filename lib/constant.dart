//----------STRINGS------------

import 'package:flutter/material.dart';

const baseURL = "http://192.168.43.227:8000/api";
const loginURL = '$baseURL/login';
const registerURL = '$baseURL/register';
const logoutURL = '$baseURL/logout';
const userURL = '$baseURL/user';
const postsURL = '$baseURL/posts';
const commentsURL = '$baseURL/comments';

//------Errors------------
const serverError = 'Server error';
const unauthorized = 'Unauthorized';
const somethingWentWrong = 'Same thing went wrong, try again!';



//--- Input decoration ---
InputDecoration kInputDecoration(String label){
  return  InputDecoration(
          labelText: label,
          contentPadding: const EdgeInsets.all(10),
          border: const OutlineInputBorder(borderSide: BorderSide(width: 1,color: Colors.black))
        );
}

//-- Button --
TextButton kTextButton(String label, Function onPressed){
  return TextButton(
          onPressed: () => onPressed(),
            style: ButtonStyle(
              backgroundColor: MaterialStateColor.resolveWith((states) => Colors.blue),
              padding: MaterialStateProperty.resolveWith((states) => const EdgeInsets.symmetric(vertical: 10))
            ),
          child:  Text(label,style: const TextStyle(color: Colors.white),),
          );
}

//loginRegisterHint

Row kLoginRegisterHint(String text,String label, Function onTap){
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(text),
      GestureDetector(
        child:  Text(label,style: const TextStyle(color: Colors.blue),),
        onTap: () => onTap(),
      )
    ],
  );
}