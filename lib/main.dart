import 'package:my_first_app/widget_tree.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart'
    show
        BuildContext,
        Colors,
        Key,
        MaterialApp,
        StatelessWidget,
        ThemeData,
        Widget,
        WidgetsFlutterBinding,
        runApp;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.orange),
      home: const WidgetTree(),
    );
  }
}
