import 'package:flutter/material.dart';
import 'package:flutter_stacked_architecture_todo/constants/constants.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'app/locator.dart';
import 'adapters/todos.adapter.dart';
import 'views/todos.view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(TodoAdapter());
  await Hive.openBox(HIVE_BOX_NAME);

  setupLocator();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const TodosScreenView(),
      theme: ThemeData.dark(),
      title: 'Flutter Stacked Todos',
    );
  }
}
