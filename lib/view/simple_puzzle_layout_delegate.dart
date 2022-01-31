import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:puzzle/models/models.dart';
import 'package:puzzle/provider/puzzle_provider.dart';
import 'package:puzzle/provider/puzzle_state.dart';
import 'package:puzzle/util/util.dart';
import 'package:puzzle/view/layout.dart';

/// A delegate for computing the layout of the puzzle UI
/// that uses a [SimpleTheme].
class SimplePuzzleLayoutDelegate extends PuzzleLayoutDelegate {
  const SimplePuzzleLayoutDelegate();

  @override
  Widget boardBuilder(int size, List<Widget> tiles) {
    return Column(
      children: [
        const ResponsiveGap(
          small: 32,
          medium: 48,
          large: 96,
        ),
        ResponsiveLayoutBuilder(
          small: (_, __) => SizedBox.square(
            dimension: _BoardSize.small,
            child: SimplePuzzleBoard(
              key: const Key('simple_puzzle_board_small'),
              size: size,
              tiles: tiles,
              spacing: 5,
            ),
          ),
          medium: (_, __) => SizedBox.square(
            dimension: _BoardSize.medium,
            child: SimplePuzzleBoard(
              key: const Key('simple_puzzle_board_medium'),
              size: size,
              tiles: tiles,
            ),
          ),
          large: (_, __) => SizedBox.square(
            dimension: _BoardSize.large,
            child: SimplePuzzleBoard(
              key: const Key('simple_puzzle_board_large'),
              size: size,
              tiles: tiles,
            ),
          ),
        ),
        const ResponsiveGap(
          large: 96,
        ),
      ],
    );
  }

  @override
  Widget tileBuilder(Tile tile, PuzzleState state) {
    return ResponsiveLayoutBuilder(
      small: (_, __) => SimplePuzzleTile(
        key: Key('simple_puzzle_tile_${tile.value}_small'),
        tile: tile,
        tileFontSize: _TileFontSize.small,
        state: state,
      ),
      medium: (_, __) => SimplePuzzleTile(
        key: Key('simple_puzzle_tile_${tile.value}_medium'),
        tile: tile,
        tileFontSize: _TileFontSize.medium,
        state: state,
      ),
      large: (_, __) => SimplePuzzleTile(
        key: Key('simple_puzzle_tile_${tile.value}_large'),
        tile: tile,
        tileFontSize: _TileFontSize.large,
        state: state,
      ),
    );
  }

  @override
  Widget whitespaceTileBuilder() {
    return const SizedBox();
  }

  @override
  List<Object?> get props => [];
}

abstract class _BoardSize {
  static double small = 312;
  static double medium = 424;
  static double large = 472;
}

/// Display the board of the puzzle in a [size]x[size] layout
/// filled with [tiles]. Each tile is spaced with [spacing].
class SimplePuzzleBoard extends StatelessWidget {
  const SimplePuzzleBoard({
    Key? key,
    required this.size,
    required this.tiles,
    this.spacing = 8,
  }) : super(key: key);

  /// The size of the board.
  final int size;

  /// The tiles to be displayed on the board.
  final List<Widget> tiles;

  /// The spacing between each tile from [tiles].
  final double spacing;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: size,
      mainAxisSpacing: spacing,
      crossAxisSpacing: spacing,
      children: tiles,
    );
  }
}

abstract class _TileFontSize {
  static double small = 36;
  static double medium = 50;
  static double large = 54;
}

/// Displays the puzzle tile associated with [tile] and
/// the font size of [tileFontSize] based on the puzzle [state].
class SimplePuzzleTile extends StatelessWidget {
  const SimplePuzzleTile({
    Key? key,
    required this.tile,
    required this.tileFontSize,
    required this.state,
  }) : super(key: key);

  /// The tile to be displayed.
  final Tile tile;

  /// The font size of the tile to be displayed.
  final double tileFontSize;

  /// The state of the puzzle.
  final PuzzleState state;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        primary: Colors.white,
        textStyle: PuzzleTextStyle.headline2.copyWith(
          fontSize: tileFontSize,
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(12),
          ),
        ),
      ).copyWith(
        foregroundColor: MaterialStateProperty.all(Colors.white),
        backgroundColor: MaterialStateProperty.resolveWith<Color?>(
          (states) {
            if (tile.value == state.lastTappedTile?.value) {
              return simpleTheme.pressedColor;
            } else if (states.contains(MaterialState.hovered)) {
              return simpleTheme.hoverColor;
            } else {
              return simpleTheme.defaultColor;
            }
          },
        ),
      ),
      onPressed: state.puzzleStatus == PuzzleStatus.incomplete
          ? () => context.read<PuzzleProvider>().onTileTapped(tile)
          : null,
      child: Text(
        tile.value.toString(),
      ),
    );
  }
}
