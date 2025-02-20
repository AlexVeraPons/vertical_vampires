import 'package:flutter/material.dart';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/rendering.dart';
import 'package:flame_forge2d/flame_forge2d.dart';

import 'package:vertical_vampires/bloc/player_bloc/player_bloc.dart';
import 'package:vertical_vampires/bloc/player_bloc/player_state.dart';

/// Possible states for the player's animation.
enum PlayerAnimationState { idle, running, jumping, dead }

/// A component that displays and updates a sprite animation
/// based on the velocity of a Forge2D [playerBody].
class PlayerAnimation extends SpriteAnimationComponent
    with HasGameRef<Forge2DGame> {
  final Body playerBody;
  late final Map<PlayerAnimationState, SpriteAnimation> animationsMap;
  final PlayerBloc playerBloc;
  PlayerAnimationState _currentState = PlayerAnimationState.idle;

  PlayerAnimation({
    required this.playerBloc,
    required this.playerBody,
    required Map<PlayerAnimationState, SpriteAnimation> externalAnimations,
    Vector2? size,
  }) : super(
          size: size,
          anchor: Anchor.center,
        ) {
    animationsMap = externalAnimations;
    animation = animationsMap[_currentState];
    playerBloc.stream.listen((state) {
      if (state is PlayerDeathState) {
        animation = animationsMap[PlayerAnimationState.dead];
      }
    });
    playerBloc.stream.listen((state) {
      if (state is PlayerHitState) {
        _hitDecorator();
      }
    });
  }

  void _hitDecorator() {
    final whiteTint = PaintDecorator.tint(Colors.white);

    decorator.addLast(whiteTint);

    final scaleEffect = ScaleEffect.by(
      Vector2.all(1.2),
      EffectController(duration: 0.1, alternate: true),
    );
    add(scaleEffect);

    Future.delayed(Duration(milliseconds: 100), () {
      decorator.removeLast();
    });
  }

  @override
  void update(double dt) {
    super.update(dt);

    final velocity = playerBody.linearVelocity;
    PlayerAnimationState newState;

    if (velocity.y.abs() > 0.1) {
      newState = PlayerAnimationState.jumping;
    } else if (velocity.x.abs() > 1) {
      newState = PlayerAnimationState.running;
    } else {
      newState = PlayerAnimationState.idle;
    }

    if (newState != _currentState) {
      _currentState = newState;
      animation = animationsMap[_currentState];
    }

    position = playerBody.position;
    position.add(Vector2(0, -size.y / 4));

    if (velocity.x < 0 && scale.x > 0) {
      scale.x = -scale.x.abs();
    } else if (velocity.x > 0 && scale.x < 0) {
      scale.x = scale.x.abs();
    }
  }
}
