import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:puzzle/models/models.dart';
import 'package:puzzle/provider/puzzle_provider.dart';

/// A widget that listens to the keyboard events and moves puzzle tiles
/// whenever a user presses keyboard arrows (←, →, ↑, ↓).
class PuzzleKeyboardHandler extends StatefulWidget {
  const PuzzleKeyboardHandler({
    Key? key,
    required this.child,
  }) : super(key: key);

  /// The widget below this widget in the tree.
  final Widget child;

  @override
  State createState() => _PuzzleKeyboardHandlerState();
}

class _PuzzleKeyboardHandlerState extends State<PuzzleKeyboardHandler> {
  // The node used to request the keyboard focus.
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _handleKeyEvent(RawKeyEvent event) {
    // The user may move tiles only when the puzzle is started.
    // There's no need to check the Simple theme as it is started by default.

    if (event is RawKeyDownEvent) {
      var puzzleProvider = context.read<PuzzleProvider>();
      final puzzle = puzzleProvider.state.puzzle;
      final physicalKey = event.data.physicalKey;

      Tile? tile;
      if (physicalKey == PhysicalKeyboardKey.arrowDown) {
        tile = puzzle.getTileRelativeToWhitespaceTile(const Offset(0, -1));
      } else if (physicalKey == PhysicalKeyboardKey.arrowUp) {
        tile = puzzle.getTileRelativeToWhitespaceTile(const Offset(0, 1));
      } else if (physicalKey == PhysicalKeyboardKey.arrowRight) {
        tile = puzzle.getTileRelativeToWhitespaceTile(const Offset(-1, 0));
      } else if (physicalKey == PhysicalKeyboardKey.arrowLeft) {
        tile = puzzle.getTileRelativeToWhitespaceTile(const Offset(1, 0));
      }

      if (tile != null) {
        puzzleProvider.onTileTapped(tile);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      focusNode: _focusNode,
      onKey: _handleKeyEvent,
      child: Builder(
        builder: (context) {
          if (!_focusNode.hasFocus) {
            FocusScope.of(context).requestFocus(_focusNode);
          }
          return widget.child;
        },
      ),
    );
  }
}
