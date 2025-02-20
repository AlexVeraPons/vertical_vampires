import 'package:flame/components.dart';

import 'package:flutter/services.dart';

import 'package:vertical_vampires/bloc/player_bloc/player_bloc.dart';
import 'package:vertical_vampires/bloc/player_bloc/player_event.dart';

class PlayerController extends Component with KeyboardHandler {
  final PlayerBloc playerBloc;

  PlayerController(this.playerBloc);

  final LogicalKeyboardKey moveUpKey = LogicalKeyboardKey.keyW;
  final LogicalKeyboardKey moveDownKey = LogicalKeyboardKey.keyS;
  final LogicalKeyboardKey moveLeftKey = LogicalKeyboardKey.keyA;
  final LogicalKeyboardKey moveRightKey = LogicalKeyboardKey.keyD;

  final LogicalKeyboardKey jumpKey = LogicalKeyboardKey.space;

  final Vector2 _input = Vector2.zero();
  bool _jumpPressed = false;

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    _input.x = 0;
    _input.y = 0;

    if (keysPressed.contains(LogicalKeyboardKey.keyA)) {
      _input.x = -1;
    } else if (keysPressed.contains(LogicalKeyboardKey.keyD)) {
      _input.x = 1;
    }

    if (keysPressed.contains(LogicalKeyboardKey.keyW)) {
      _input.y = -1;
    } else if (keysPressed.contains(LogicalKeyboardKey.keyS)) {
      _input.y = 1;
    }

    _jumpPressed = keysPressed.contains(LogicalKeyboardKey.space);

    playerBloc.add(MovePlayer(_input, jumpPressed: _jumpPressed));
    return true;
  }
}
