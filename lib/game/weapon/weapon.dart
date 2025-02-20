import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';

import 'package:vertical_vampires/bloc/player_bloc/player_bloc.dart';
import 'package:vertical_vampires/bloc/player_bloc/player_state.dart';
import 'package:vertical_vampires/game/enemy/abstract_enemy.dart';
import 'package:vertical_vampires/game/upgrade/upgrade_system.dart';
import 'package:vertical_vampires/game/weapon/bullet/abstract_bullet.dart';
import 'package:vertical_vampires/game/weapon/shoot_strategy.dart';
import 'package:vertical_vampires/game/weapon/weapon_stats.dart';
import 'bullet/bullet_pool.dart';

class Weapon extends PositionComponent {
  Vector2 weaponPosition = Vector2.zero();
  WeaponStats stats;

  ShootStrategy shootStrategy;
  AbstractBullet bulletPrefab;
  final BulletPool bulletPool;

  final Body holdingBody;
  final Vector2 offset = Vector2(-30, -20);

  late final SpriteComponent weaponSprite;
  double _timeSinceLastShot = 0.0;

  Weapon({
    required this.stats,
    required this.shootStrategy,
    required this.bulletPrefab,
    required this.bulletPool,
    required this.holdingBody,
    required Sprite sprite,
    required PlayerBloc playerBloc,
  }) {
    weaponSprite = SpriteComponent(size: Vector2(30, 30), sprite: sprite);
    weaponSprite.anchor = Anchor.center;
    playerBloc.stream.listen((state) {
      if (state is PlayerUpgradeState) {
        _onUpgrade(state.upgrade);
      }
    });
  }

  @override
  void onMount() {
    super.onMount();
    add(weaponSprite);
  }

  @override
  void update(double dt) {
    super.update(dt);
    _updatePosition();
    _updateShooting(dt);
  }

  void _updatePosition() {
    position = holdingBody.position + offset;
    weaponPosition = position;
  }

  void _updateShooting(double dt) {
    _timeSinceLastShot += dt;
    if (_timeSinceLastShot >= stats.fireRate) {
      shoot();
      _timeSinceLastShot = 0.0;
    }
  }

  void shoot() {
    final game = findGame();
    if (game == null) return;

    final enemies = game.children.whereType<AbstractEnemy>().toList();
    final newBullet = bulletPool.obtainBullet(bulletPrefab);
    shootStrategy.shoot(newBullet, stats, this, enemies);
  }

  void changeWeaponStats(WeaponStats stats) {
    print(stats.fireRate);
    this.stats = stats;
  }

  void changeShootStrategy(ShootStrategy newStrategy) {
    shootStrategy = newStrategy;
  }

  void changeBulletType(AbstractBullet newPrefab) {
    bulletPrefab = newPrefab;
  }

  void _onUpgrade(UpgradeContext upgrade) {
    changeWeaponStats(upgrade.stats);
    changeShootStrategy(upgrade.shootStrategy);
    changeBulletType(upgrade.bullets);
  }
}
