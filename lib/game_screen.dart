import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:vertical_vampires/game/game.dart';

class GameScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GameWidget(
        game: SurvivorsGame(context), 
      ),
    );
  }
}