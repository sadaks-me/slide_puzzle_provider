import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:puzzle/models/models.dart';
import 'package:puzzle/provider/puzzle_state.dart';

class PuzzleProvider with ChangeNotifier implements ReassembleHandler {
  PuzzleProvider(this.size, {this.shufflePuzzle = true}) {
    onPuzzleInitialized(shufflePuzzle);
  }

  final int size;

  final bool shufflePuzzle;

  late PuzzleState state;

  void onPuzzleInitialized(bool shufflePuzzle) {
    final puzzle = _generatePuzzle(size, shuffle: shufflePuzzle);
    state = PuzzleState(
      puzzle: puzzle.sort(),
      numberOfCorrectTiles: puzzle.getNumberOfCorrectTiles(),
    );
    notifyListeners();
  }

  void onTileTapped(Tile tappedTile) {
    if (state.puzzleStatus == PuzzleStatus.incomplete) {
      if (state.puzzle.isTileMovable(tappedTile)) {
        final mutablePuzzle = Puzzle(tiles: [...state.puzzle.tiles]);
        final puzzle = mutablePuzzle.moveTiles(tappedTile, []);
        if (puzzle.isComplete()) {
          state = state.copyWith(
            puzzle: puzzle.sort(),
            puzzleStatus: PuzzleStatus.complete,
            tileMovementStatus: TileMovementStatus.moved,
            numberOfCorrectTiles: puzzle.getNumberOfCorrectTiles(),
            numberOfMoves: state.numberOfMoves + 1,
            lastTappedTile: tappedTile,
          );
        } else {
          state = state.copyWith(
            puzzle: puzzle.sort(),
            tileMovementStatus: TileMovementStatus.moved,
            numberOfCorrectTiles: puzzle.getNumberOfCorrectTiles(),
            numberOfMoves: state.numberOfMoves + 1,
            lastTappedTile: tappedTile,
          );
        }
      } else {
        state = state.copyWith(
            tileMovementStatus: TileMovementStatus.cannotBeMoved);
      }
    } else {
      state =
          state.copyWith(tileMovementStatus: TileMovementStatus.cannotBeMoved);
    }
    notifyListeners();
  }

  void onPuzzleReset() {
    final puzzle = _generatePuzzle(size);
    state = PuzzleState(
      puzzle: puzzle.sort(),
      numberOfCorrectTiles: puzzle.getNumberOfCorrectTiles(),
    );
    notifyListeners();
  }

  /// Build a randomized, solvable puzzle of the given size.
  Puzzle _generatePuzzle(int size, {bool shuffle = true}) {
    final correctPositions = <Position>[];
    final currentPositions = <Position>[];
    final whitespacePosition = Position(x: size, y: size);

    // Create all possible board positions.
    for (var y = 1; y <= size; y++) {
      for (var x = 1; x <= size; x++) {
        if (x == size && y == size) {
          correctPositions.add(whitespacePosition);
          currentPositions.add(whitespacePosition);
        } else {
          final position = Position(x: x, y: y);
          correctPositions.add(position);
          currentPositions.add(position);
        }
      }
    }

    if (shuffle) {
      // Randomize only the current tile positions.
      currentPositions.shuffle();
    }

    var tiles = _getTileListFromPositions(
      size,
      correctPositions,
      currentPositions,
    );

    var puzzle = Puzzle(tiles: tiles);

    if (shuffle) {
      // Assign the tiles new current positions until the puzzle is solvable and
      // zero tiles are in their correct position.
      while (!puzzle.isSolvable() || puzzle.getNumberOfCorrectTiles() != 0) {
        currentPositions.shuffle();
        tiles = _getTileListFromPositions(
          size,
          correctPositions,
          currentPositions,
        );
        puzzle = Puzzle(tiles: tiles);
      }
    }

    return puzzle;
  }

  /// Build a list of tiles - giving each tile their correct position and a
  /// current position.
  List<Tile> _getTileListFromPositions(
    int size,
    List<Position> correctPositions,
    List<Position> currentPositions,
  ) {
    final whitespacePosition = Position(x: size, y: size);
    return [
      for (int i = 1; i <= size * size; i++)
        if (i == size * size)
          Tile(
            value: i,
            correctPosition: whitespacePosition,
            currentPosition: currentPositions[i - 1],
            isWhitespace: true,
          )
        else
          Tile(
            value: i,
            correctPosition: correctPositions[i - 1],
            currentPosition: currentPositions[i - 1],
          )
    ];
  }

  @override
  void reassemble() {
    debugPrint('PuzzleProvider did hot-reload');
  }
}
