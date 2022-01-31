import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:puzzle/models/models.dart';
import 'package:puzzle/provider/puzzle_state.dart';

/// A delegate for computing the layout of the puzzle UI.
abstract class PuzzleLayoutDelegate extends Equatable {
  const PuzzleLayoutDelegate();

  /// A widget builder for the puzzle board.
  ///
  /// The board should have a dimension of [size]
  /// (e.g. 4x4 puzzle has a dimension of 4).
  ///
  /// The board should display the list of [tiles],
  /// each built with [tileBuilder].
  Widget boardBuilder(int size, List<Widget> tiles);

  /// A widget builder for the puzzle tile associated
  /// with [tile] and based on the puzzle [state].
  ///
  /// To complete the puzzle, all tiles must be arranged
  /// in order by their [Tile.value].
  Widget tileBuilder(Tile tile, PuzzleState state);

  /// A widget builder for the whitespace puzzle tile.
  Widget whitespaceTileBuilder();
}
