import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vertical_vampires/bloc/game_bloc/game_bloc.dart';
import 'package:vertical_vampires/bloc/player_bloc/player_bloc.dart';
import 'package:vertical_vampires/game_screen.dart';

void main() {
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<GameBloc>(
          create: (context) => GameBloc(),
        ),
        BlocProvider<PlayerBloc>(
          create: (context) => PlayerBloc(),
        ),
      ],
      child: MaterialApp(
        home: Builder(
          builder: (context) => GameScreen(
            gameBloc: BlocProvider.of<GameBloc>(context),
            playerBloc: BlocProvider.of<PlayerBloc>(context),
          ),
        ),
      ),
    ),
  );
}
