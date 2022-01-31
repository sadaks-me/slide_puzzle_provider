import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:puzzle/models/models.dart';
import 'package:puzzle/provider/puzzle_provider.dart';
import 'package:puzzle/util/util.dart';
import 'package:puzzle/widgets/puzzle_keyboard_handler.dart';

class SimplePuzzle extends StatelessWidget {
  const SimplePuzzle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: simpleTheme.backgroundColor,
      body: LayoutBuilder(
        builder: (context, constraints) => SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight,
            ),
            child: const Center(child: PuzzleBoard()),
          ),
        ),
      ),
    );
  }
}

/// Displays the board of the puzzle.
class PuzzleBoard extends StatelessWidget {
  const PuzzleBoard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = context.select((PuzzleProvider bloc) => bloc.state);
    final size = state.puzzle.getDimension();
    if (size == 0) return const CircularProgressIndicator();
    return PuzzleKeyboardHandler(
      child: simpleTheme.layoutDelegate.boardBuilder(size, [
        ...state.puzzle.tiles.map(
          (tile) => _PuzzleTile(
            key: Key('puzzle_tile_${tile.value.toString()}'),
            tile: tile,
          ),
        )
      ]),
    );
  }
}

class _PuzzleTile extends StatelessWidget {
  const _PuzzleTile({
    Key? key,
    required this.tile,
  }) : super(key: key);

  /// The tile to be displayed.
  final Tile tile;

  @override
  Widget build(BuildContext context) {
    final state = context.select((PuzzleProvider bloc) => bloc.state);

    return tile.isWhitespace
        ? simpleTheme.layoutDelegate.whitespaceTileBuilder()
        : simpleTheme.layoutDelegate.tileBuilder(tile, state);
  }
}
