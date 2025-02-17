import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vertical_vampires/bloc/game_bloc/game_bloc.dart';
import 'package:vertical_vampires/game_screen.dart';
void main() {
  runApp(
    BlocProvider(
      create: (context) => GameBloc(),
      child: MaterialApp(
        home: GameScreen(),
      ),
    ),
  );
}

