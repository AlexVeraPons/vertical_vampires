import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame/components.dart';
import 'package:vertical_vampires/game/enemy/abstract_enemy.dart';
import 'package:vertical_vampires/game/player/player.dart';
import 'package:vertical_vampires/game/weapon/bullet/bullet_pool.dart';
import 'package:vertical_vampires/game/life_component.dart';

abstract class AbstractBullet extends BodyComponent with ContactCallbacks {
  Vector2? _position;
  Vector2? initialDirection;
  Body? _target;
  late FixtureDef fixtureDef;

  late double size;
  late double speed;

  BulletPool? pool;

  AbstractBullet createNewInstance();

  void shoot(Vector2 position, Vector2 direction, Body target) {
    _position = position;
    initialDirection = direction;
    _target = target;

    executeOnShoot();
  }

  void executeOnShoot() {}

  @override
  Body createBody() {
    final bodyDef = BodyDef()
      ..position = _position ?? Vector2.zero()
      ..type = BodyType.kinematic
      ..linearVelocity = (initialDirection ?? Vector2.zero()) * speed;

    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }

  @override
  void update(double dt) {
    super.update(dt);
    move(dt);
  }

  @override
  Future<void> onLoad() {
    final shape = CircleShape()..radius = size;
     fixtureDef = FixtureDef(shape)
      ..restitution = 0.0
      ..density = 1.0
      ..friction = 0.0
      ..isSensor = true
      ..userData = this;
    return super.onLoad();
  }

  void move(double dt);

  @override
  void beginContact(Object other, Contact contact) {
    if (other is Player) {
      return;
    }

    LifeComponent? lifeComponent;

    if (other is AbstractEnemy) {
      lifeComponent = other.life;
      hitTarget(lifeComponent);
      recycleBullet();
      return;
    } else if (other is LifeComponent) {
      lifeComponent = other;
    } else if (other is Component) {
      final candidates = other.children.whereType<LifeComponent>().toList();
      if (candidates.isNotEmpty) {
        lifeComponent = candidates.first;
      }
    }

    if (lifeComponent != null) {
      hitTarget(lifeComponent);
      recycleBullet();
    }
  }

  @override
  void endContact(Object other, Contact contact) {}

  void hitTarget(LifeComponent life) {}

  void recycleBullet() {
    if (pool != null) {
      pool!.releaseBullet(this);
    removeFromParent();
    }
  }

  AbstractBullet clone() {
    final newBullet = createNewInstance()
      ..size = size
      ..speed = speed
      ..pool = pool;
    return newBullet;
  }
}
