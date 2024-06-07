import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'screen/home_screen.dart';
import 'services/sinhvien_view_model.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => SinhVienViewModel(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Danh sách sinh viên'),
        ),
        body: const HomeScreen(),
      ),
    );
  }
}
