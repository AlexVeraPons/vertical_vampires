import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';

import 'package:vertical_vampires/bloc/player_bloc/player_event.dart';
import 'package:vertical_vampires/game/enemy/ai_behavior/ai_behavior.dart';
import 'package:vertical_vampires/game/life_component.dart';
import 'package:vertical_vampires/game/player/player.dart';

/// Abstract class for all enemy types
abstract class AbstractEnemy extends BodyComponent with ContactCallbacks {
  late Vector2 size = Vector2(50, 50);
  final double speed;
  final double attackPower;
  final double health;
  final int experienceValue;

  late final LifeComponent life;
  late final Body target;

  late final AiBehavior aiBehavior;

  bool _behaviorInitialzied = false;
  late Vector2 position;

  AbstractEnemy(
      {required Vector2 this.position,
      this.speed = 2.0,
      this.attackPower = 100.0,
      this.health = 10,
      this.experienceValue = 20});

  @override
  Future<void> onLoad() async {
    super.onLoad();
    life = LifeComponent(maxHealth: health, onDeath: onDeath);
    this.add(life);
  }

  @override
  void onMount() async {
    super.onMount();
    await Future.delayed(Duration(milliseconds: 50));
    final game = findGame();
    if (game != null) {
      final player = game.firstChild<Player>();
      if (player != null) {
        target = player.body;
      }
    }

    setupBehavior();
  }

  Body createBody() {
    final shape = PolygonShape()
      ..setAsBox(size.x / 4, size.y / 4, Vector2.zero(), 0.0);
    final fixtureDef = FixtureDef(shape)
      ..density = 0.001
      ..friction = 0.0
      ..isSensor = true
      ..userData = this;
    final bodyDef = BodyDef()
      ..position = position
      ..type = BodyType.dynamic
      ..gravityScale = Vector2(0, 0);

    final body = world.createBody(bodyDef)..createFixture(fixtureDef);
    renderBody = false;
    return body;
  }

  void beginContact(Object other, Contact contact) {
    if (other is LifeComponent) {
    } else if (other is Component) {
      final lifeComponent = other.firstChild<LifeComponent>();
      if (lifeComponent != null) {
        print('enemy attack');
        lifeComponent.takeDamage(attackPower);
        removeFromParent();
      }
    }
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (!_behaviorInitialzied) {
      return;
    }
    aiBehavior.move(dt);
  }

  void onDeath() {
    final game = findGame();
    if (game != null) {
      final player = game.firstChild<Player>();
      player?.playerBloc.add(PlayerGainedXP(experienceValue));
    }

    removeFromParent();
  }

  void setupBehavior() {
    _behaviorInitialzied = true;
  }
}
