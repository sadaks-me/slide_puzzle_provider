import 'dart:ui';

import 'package:puzzle/util/util.dart';
import 'package:puzzle/view/layout.dart';

import 'simple_puzzle_layout_delegate.dart';

/// The simple puzzle theme.
class SimpleTheme extends PuzzleTheme {
  const SimpleTheme() : super();

  @override
  String get name => 'Simple';

  @override
  Color get backgroundColor => PuzzleColors.black;

  @override
  Color get defaultColor => PuzzleColors.primary5;

  @override
  Color get hoverColor => PuzzleColors.primary3;

  @override
  Color get pressedColor => PuzzleColors.primary7;

  @override
  PuzzleLayoutDelegate get layoutDelegate => const SimplePuzzleLayoutDelegate();

  @override
  List<Object?> get props => [
        name,
        backgroundColor,
        defaultColor,
        hoverColor,
        pressedColor,
        layoutDelegate,
      ];
}
