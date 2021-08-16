// @dart=2.9
import 'package:flutter/material.dart';
import 'app.dart';
import 'app_state.dart';
import 'package:provider/provider.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ChangeNotifierProvider<AppState>(
      create: (_) => AppState(),
      child: MyApp(),
    ),
  );
}
