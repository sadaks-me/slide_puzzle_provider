import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'provider/puzzle_provider.dart';
import 'util/util.dart';
import 'view/layout.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => PuzzleProvider(4),
      child: MaterialApp(
        title: 'Puzzle Demo',
        theme: appTheme,
        home: const SimplePuzzle(),
      ),
    );
  }
}
