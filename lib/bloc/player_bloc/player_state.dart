import 'package:vector_math/vector_math_64.dart';
import 'package:vertical_vampires/game/movement/movement_strategy.dart';
import 'package:vertical_vampires/game/upgrade/upgrade_system.dart';

abstract class PlayerState {}

class PlayerIdleState extends PlayerState {}

class PlayerMovementState extends PlayerState {
  final Vector2 direction;
  final bool jumpPressed;
  PlayerMovementState(this.direction, this.jumpPressed) {}
}

class PlayerChangingStrategyState extends PlayerState {
  final MovementStrategy strategy;
  PlayerChangingStrategyState(this.strategy);
}

class PlayerUpgradeState extends PlayerState {
  final UpgradeContext upgrade;
  PlayerUpgradeState(this.upgrade);
}

class PlayerDeathState extends PlayerState {}

class PlayerGainedXPState extends PlayerState{
  int amount;
  PlayerGainedXPState(this.amount);
}

class PlayerHitState extends PlayerState {
  final double currentHealth;
  PlayerHitState(this.currentHealth);
}
