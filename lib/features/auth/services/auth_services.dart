import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intern_app/constants/error_variables.dart';
import 'package:intern_app/constants/utils.dart';
import 'package:intern_app/home/screens/home_screen.dart';
import 'package:intern_app/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:intern_app/constants/global_variables.dart';
import 'package:intern_app/providers/user_provide.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  // sign up for user
  void signUpUser({
    required BuildContext context,
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      User user = User(
        id: '',
        name: name,
        email: email,
        password: password,
        address: '',
        type: '',
        token: '',
      );
      // uri lay tu global_variable.dart
      http.Response res = await http.post(
        Uri.parse('$uri/api/signup'),
        body: user.toJson(),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          showSnackBar(
            context,
            'Created account for You!',
          );
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  // sign in for user
  void signInUser({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    try {
      // uri lay tu global_variable.dart
      http.Response res = await http.post(
        Uri.parse('$uri/api/signin'),
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      // print(res.body);

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () async {
          // lay instance
          SharedPreferences prefs = await SharedPreferences.getInstance();
          // save data
          Provider.of<UserProvider>(context, listen: false).setUser(res.body);

          // set the token
          await prefs.setString('x-auth-token', jsonDecode(res.body)['token']);
          Navigator.pushNamedAndRemoveUntil(
              context, HomeScreen.routeName, (route) => false);
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

// get User
  void getUserData({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    try {
      // uri lay tu global_variable.dart
      // http.Response res = await http.post(
      //   Uri.parse('$uri/api/signin'),
      //   body: jsonEncode({
      //     'email': email,
      //     'password': password,
      //   }),
      //   headers: <String, String>{
      //     'Content-Type': 'application/json; charset=UTF-8',
      //   },
      // );
      // print(res.body);

      // httpErrorHandle(
      //   response: res,
      //   context: context,
      //   onSuccess: () async {
      //     // lay instance
      //     SharedPreferences prefs = await SharedPreferences.getInstance();
      //     // save data
      //     Provider.of<UserProvider>(context, listen: false).setUser(res.body);

      //     // set the token
      //     await prefs.setString('x-auth-token', jsonDecode(res.body)['token']);
      //     Navigator.pushNamedAndRemoveUntil(
      //         context, HomeScreen.routeName, (route) => false);
      //   },
      // );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }
}
