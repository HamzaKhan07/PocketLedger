import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'package:sizer/sizer.dart';
import 'package:provider/provider.dart';
import 'khata_brain.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => KhataBrain(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData.light().copyWith(accentColor: Colors.teal[300]),
          home: HomeScreen(),
        );
      },
    );
  }
}
