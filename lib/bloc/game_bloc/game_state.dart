abstract class GameEvent {}

class StartEvent extends GameEvent {}

class BattleEvent extends GameEvent {}

class UpgradeEvent extends GameEvent {}

class EndEvent extends GameEvent {}

class ResetGameEvent extends GameEvent {}
