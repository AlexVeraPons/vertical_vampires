import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flame/game.dart';
import 'package:vertical_vampires/bloc/game_bloc/game_bloc.dart';
import 'package:vertical_vampires/bloc/game_bloc/game_event.dart';
import 'package:vertical_vampires/bloc/player_bloc/player_bloc.dart';
import 'package:vertical_vampires/game/game.dart';

class GameScreen extends StatefulWidget {
  final GameBloc gameBloc;
  final PlayerBloc playerBloc;

  const GameScreen({
    required this.gameBloc,
    required this.playerBloc,
  });

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late SurvivorsGame _game;

  @override
  void initState() {
    super.initState();
    _createNewGameInstance();
  }

  void _createNewGameInstance() {
    _game = SurvivorsGame(
      gameBloc: widget.gameBloc,
      playerBloc: widget.playerBloc,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<GameBloc, GameState>(
        bloc: widget.gameBloc,
        builder: (context, state) {
          if (state is ResetState) {
            _createNewGameInstance();
          }

          return GameWidget(game: _game);
        },
      ),
    );
  }
}
