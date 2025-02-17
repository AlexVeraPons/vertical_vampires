part of 'game_bloc.dart';

abstract class GameState {}

class StartState extends GameState {}
class BattleState extends GameState {}
class EndState extends GameState {}
