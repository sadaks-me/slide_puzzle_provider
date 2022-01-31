import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:puzzle/view/layout.dart';

/// Template for creating custom puzzle UI.
abstract class PuzzleTheme extends Equatable {
  const PuzzleTheme();

  /// The display name of this theme.
  String get name;

  /// The background color of this theme.
  Color get backgroundColor;

  /// The default color of this theme.
  ///
  /// Applied to the text color of the score and
  /// the default background color of puzzle tiles.
  Color get defaultColor;

  /// The hover color of this theme.
  ///
  /// Applied to the background color of a puzzle tile
  /// that is hovered over.
  Color get hoverColor;

  /// The pressed color of this theme.
  ///
  /// Applied to the background color of a puzzle tile
  /// that was pressed.
  Color get pressedColor;

  /// The puzzle layout delegate of this theme.
  ///
  /// Used for building sections of the puzzle UI.
  PuzzleLayoutDelegate get layoutDelegate;
}
