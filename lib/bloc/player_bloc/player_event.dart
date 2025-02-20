import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:vertical_vampires/game/movement/movement_strategy.dart';
import 'package:vertical_vampires/game/upgrade/upgrade_system.dart';

abstract class PlayerEvent {}

class MovePlayer extends PlayerEvent {
  final Vector2 direction;
  final bool jumpPressed;

  MovePlayer(this.direction, {this.jumpPressed = false});
}

class ChangePlayerStrategy extends PlayerEvent {
  final MovementStrategy strategy;

  ChangePlayerStrategy(this.strategy);
}

class PlayerUpgrade extends PlayerEvent {
  final UpgradeContext upgrade;
  PlayerUpgrade(this.upgrade);
}

class PlayerDeath extends PlayerEvent {}

class PlayerGainedXP extends PlayerEvent {
  int amount;
  PlayerGainedXP(this.amount);
}

class PlayerHit extends PlayerEvent {
  final double currentHealth;
  PlayerHit(this.currentHealth);
}
