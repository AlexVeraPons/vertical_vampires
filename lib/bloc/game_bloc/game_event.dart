part of 'game_bloc.dart';

abstract class GameEvent {}

class StartEvent extends GameEvent {}
class BattleEvent extends GameEvent {}
class EndEvent extends GameEvent {}