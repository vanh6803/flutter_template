import 'package:flutter/material.dart';
import 'package:flutter_template/app/app.dart';
import 'package:flutter_template/app/bootstap.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await bootstrap();

  runApp(const MyApplication());
}