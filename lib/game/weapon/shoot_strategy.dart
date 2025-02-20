import 'package:vertical_vampires/game/enemy/abstract_enemy.dart';
import 'package:vertical_vampires/game/weapon/bullet/abstract_bullet.dart';
import 'package:vertical_vampires/game/weapon/weapon.dart';
import 'package:vertical_vampires/game/weapon/weapon_stats.dart';

abstract class ShootStrategy {
  void shoot(
    AbstractBullet bullet,
    WeaponStats stats,
    Weapon weapon,
    List<AbstractEnemy> enemies,
  );
}
