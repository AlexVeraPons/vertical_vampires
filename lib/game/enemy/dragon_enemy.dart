import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/particles.dart' as flame_particles;
import 'package:flutter/material.dart';

import 'abstract_enemy.dart';
import 'package:vertical_vampires/game/enemy/ai_behavior/dive_move_behavior.dart';

class DragonEnemy extends AbstractEnemy {
  late final DiveMoveBehavior behavior;
  final Random _rnd = Random();

  DragonEnemy({
    required Vector2 position,
  }) : super(
          position: position,
          speed: 4.0,
          attackPower: 150.0,
          health: 200,
          experienceValue: 50,
        ) {
    size = Vector2(50, 60);
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    final spriteSheet = await Flame.images.load('dragon.png');
    final spriteFrameSize = Vector2(16, 16);

    final spriteAnimation = SpriteAnimation.fromFrameData(
      spriteSheet,
      SpriteAnimationData.sequenced(
        amount: 4,
        stepTime: 0.2,
        textureSize: spriteFrameSize,
      ),
    );

    final spriteAnimationComponent = SpriteAnimationComponent(
      animation: spriteAnimation,
      size: size,
      anchor: Anchor.center,
    );

    add(spriteAnimationComponent);
  }

  @override
  void setupBehavior() {
    behavior = DiveMoveBehavior(
      target,
      body,
      speed,
      leftBound: 0.0,
      rightBound: findGame()?.size.x ?? 100.0,
    );
    aiBehavior = behavior;
    super.setupBehavior();
  }

  void _spawnDeathParticles() {
    final game = findGame();
    if (game != null) {
      final particle = flame_particles.Particle.generate(
        count: 20,
        generator: (i) => flame_particles.AcceleratedParticle(
          lifespan: 1.5,
          speed: Vector2(
            _rnd.nextDouble() * 300 - 150,
            _rnd.nextDouble() * 300 - 150,
          ),
          acceleration: Vector2(0, 150),
          child: flame_particles.CircleParticle(
            radius: 8.0,
            paint: Paint()..color = Colors.orange,
          ),
        ),
      );

      final translated = flame_particles.TranslatedParticle(
        offset: body.position,
        child: particle,
      );

      game.add(
        ParticleSystemComponent(
          particle: translated,
        ),
      );
    }
  }

  @override
  void onRemove() {
    _spawnDeathParticles();
    super.onRemove();
  }
}
