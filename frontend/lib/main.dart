import 'package:flutter/material.dart';
import 'package:frontend/widgets/credentials/forgot_username_screen.dart';
import 'package:frontend/widgets/credentials/reset_new_password.dart';
import 'package:frontend/widgets/credentials/credentials_screen.dart';
import 'package:frontend/widgets/credentials/forgot_password_screen.dart';
import 'package:frontend/widgets/credentials/forgot_something_screen.dart';
import 'package:frontend/widgets/credentials/loading_screen.dart';

void main() {
  runApp(MaterialApp(
    home: ForgotUsernameWidget(),
  ));
}
