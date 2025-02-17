import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flame_forge2d/flame_forge2d.dart';

class PlayerState {
  final Vector2 position;
  final double health;

  PlayerState({required this.position, this.health = 100});
}

class PlayerCubit extends Cubit<PlayerState> {
  PlayerCubit() : super(PlayerState(position: Vector2(0, 0)));

  void move(Vector2 direction) {
    emit(PlayerState(position: state.position + direction, health: state.health));
  }

  void takeDamage(double damage) {
    double newHealth = (state.health - damage).clamp(0, 100);
    emit(PlayerState(position: state.position, health: newHealth));
  }

  void heal(double amount) {
    double newHealth = (state.health + amount).clamp(0, 100);
    emit(PlayerState(position: state.position, health: newHealth));
  }

}
