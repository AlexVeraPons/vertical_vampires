import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/particles.dart' as flame_particles;
import 'package:flame/flame.dart';
import 'package:flutter/material.dart';

import 'abstract_enemy.dart';
import 'package:vertical_vampires/game/enemy/ai_behavior/seek_move_behavior.dart';

class BatEnemy extends AbstractEnemy {
  late final SeekMoveBehavior behavior;
  final Random _rnd = Random();

  BatEnemy({
    required Vector2 position,
  }) : super(
          position: position,
          speed: 8.0,
          attackPower: 30.0,
          health: 70,
          experienceValue: 100,
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    final spriteSheet = await Flame.images.load('bat.png');
    final spriteSize = Vector2(32.0, 32.0);

    final spriteAnimation = SpriteAnimation.fromFrameData(
      spriteSheet,
      SpriteAnimationData.sequenced(
        amount: 2,
        stepTime: 0.3,
        textureSize: spriteSize,
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
    behavior = SeekMoveBehavior(
      this.target,
      body,
      speed,
    );
    aiBehavior = behavior;
    super.setupBehavior();
  }

  void _spawnDeathParticles() {
    final game = this.findGame();
    if (game != null) {
      final particle = flame_particles.Particle.generate(
        count: 10,
        generator: (i) => flame_particles.AcceleratedParticle(
          lifespan: 1.0,
          speed: Vector2(
            _rnd.nextDouble() * 200 - 100,
            _rnd.nextDouble() * 200 - 100,
          ),
          acceleration: Vector2(0, 100),
          child: flame_particles.CircleParticle(
            radius: 5.0,
            paint: Paint()..color = Colors.red,
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
  void  onDeath(){
    _spawnDeathParticles();
    super.onDeath();
  }
}
