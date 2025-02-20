import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import 'package:vertical_vampires/bloc/player_bloc/player_bloc.dart';
import 'package:vertical_vampires/bloc/player_bloc/player_state.dart';

class ScoreUI extends PositionComponent {
  final PlayerBloc _playerBloc;
  late TextComponent _xpText;
  int _currentXP = 0;

  final Color _textColor = Colors.white;
  final double _fontSize = 20;

  ScoreUI({required PlayerBloc playerBloc}) : _playerBloc = playerBloc;

  @override
  Future<void> onLoad() async {
    super.onLoad();

    position = Vector2(10, 10);
    size = Vector2(150, 40);

    _xpText = TextComponent(
      text: "XP: $_currentXP",
      textRenderer: TextPaint(
        style: TextStyle(
          color: _textColor,
          fontSize: _fontSize,
          fontWeight: FontWeight.bold,
        ),
      ),
    );

    add(_xpText);

    _playerBloc.stream.listen((state) {
      if (state is PlayerGainedXPState) {
        _updateXP(state.amount);
      }
    });
  }

  void _updateXP(int xpGained) {
    _currentXP += xpGained;
    _xpText.text = "XP: $_currentXP";
  }
}
