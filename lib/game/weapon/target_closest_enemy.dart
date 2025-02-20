// target_closest_enemy.dart
import 'package:vertical_vampires/game/enemy/abstract_enemy.dart';
import 'package:vertical_vampires/game/weapon/bullet/abstract_bullet.dart';
import 'package:vertical_vampires/game/weapon/shoot_strategy.dart';
import 'package:vertical_vampires/game/weapon/weapon.dart';
import 'package:vertical_vampires/game/weapon/weapon_stats.dart';

class TargetClosestEnemyShootStrategy implements ShootStrategy {
  @override
  void shoot(
    AbstractBullet bullet,
    WeaponStats stats,
    Weapon weapon,
    List<AbstractEnemy> enemies,
  ) {
    final weaponPos = weapon.weaponPosition;

    //Find the closest enemy
    AbstractEnemy? closest;
    double minDist = double.infinity;
    for (final enemy in enemies) {
      final dist = weaponPos.distanceTo(enemy.body.position);
      if (dist < minDist) {
        minDist = dist;
        closest = enemy;
      }
    }

    if (closest != null) {
      final direction = (closest.body.position - weaponPos).normalized();
      weapon.findGame()?.add(bullet);
      bullet.shoot(weaponPos, direction, closest.body);
    }
  }
}
