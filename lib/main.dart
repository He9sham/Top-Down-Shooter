import 'package:flutter/material.dart';
import 'package:flutter_games/game/ui/home_menu.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() {
  runApp(const GameApp());
}

class GameApp extends StatelessWidget {
  const GameApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Wave Fall',
          theme: ThemeData.dark(),
          home: const HomeMenuScreen(),
        );
      },
    );
  }
}
