import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:vertical_vampires/bloc/player_bloc/player_bloc.dart';
import 'package:vertical_vampires/bloc/player_bloc/player_event.dart';
import 'package:vertical_vampires/bloc/player_bloc/player_state.dart';
import 'package:vertical_vampires/game/upgrade/upgrade_selection.dart';
import 'package:vertical_vampires/game/weapon/bullet/abstract_bullet.dart';
import 'package:vertical_vampires/game/weapon/bullet/big_bullet.dart';
import 'package:vertical_vampires/game/weapon/bullet/zigzag_bullet.dart';
import 'package:vertical_vampires/game/weapon/shoot_strategy.dart';
import 'package:vertical_vampires/game/weapon/weapon_stats.dart';

class UpgradeSystem extends Component {
  final PlayerBloc _playerBloc;
  late Forge2DGame gameRef;
  late UpgradeContext currentUpgrade;

  late final List<Upgrade> allPossibleUpgrades;

  UpgradeSystem(this._playerBloc) {
    allPossibleUpgrades = [
      Upgrade(
        title: 'Change to ZigZag missiles',
        description:
            'your missiles will move esporadically and have lots more damage!',
        applyUpgrade: () {
          UpgradeContext newUpgrade = UpgradeContext(
              stats: currentUpgrade.stats,
              shootStrategy: currentUpgrade.shootStrategy,
              bullets: ZigZagBullet());

          _playerBloc.add(PlayerUpgrade(newUpgrade));
        },
      ),
      Upgrade(
        title: 'Faster Attack Speed',
        description: 'Shoot 20% faster!',
        applyUpgrade: () {
          WeaponStats newStat =
              WeaponStats(fireRate: currentUpgrade.stats.fireRate * 0.8);

          UpgradeContext newUpgrade = UpgradeContext(
              stats: newStat,
              shootStrategy: currentUpgrade.shootStrategy,
              bullets: currentUpgrade.bullets);

          _playerBloc.add(PlayerUpgrade(newUpgrade));
        },
      ),
      Upgrade(
        title: 'Change to big damage bullets',
        description: 'Your bullets are larger and deal more damage!',
        applyUpgrade: () {
          UpgradeContext newUpgrade = UpgradeContext(
              stats: currentUpgrade.stats,
              shootStrategy: currentUpgrade.shootStrategy,
              bullets: BigBullet());

          _playerBloc.add(PlayerUpgrade(newUpgrade));
        },
      ),
    ];
  }

  @override
  FutureOr<void> onLoad() async {
    await super.onLoad();
    gameRef = findGame() as Forge2DGame;

    currentUpgrade = _playerBloc.getUpgradeContext();

    _playerBloc.stream.listen((state) {
      if (state is PlayerUpgradeState) {
        if (currentUpgrade == state.upgrade) {
          upgrade(state.upgrade);
        }
        currentUpgrade = state.upgrade;
      }
    });
  }

  void showAvailableUpgrades() async {
    final threeUpgrades = [...allPossibleUpgrades]..shuffle();
    final selectedUpgrades = threeUpgrades.take(3).toList();

    final selectionComponent = UpgradeSelectionComponent(
      upgradeSystem: this,
      upgrades: selectedUpgrades,
    );

    gameRef.add(selectionComponent);
    await Future.delayed(const Duration(milliseconds: 500));
    gameRef.pauseEngine();
  }

  void resumeGame() {
    gameRef.resumeEngine();
  }

  void upgrade(UpgradeContext upgrade) {
    FlameAudio.play('upgrade.mp3');
    showAvailableUpgrades();
  }
}

class Upgrade {
  final String title;
  final String description;
  final void Function() applyUpgrade;

  Upgrade({
    required this.title,
    required this.description,
    required this.applyUpgrade,
  });
}

class UpgradeContext {
  late WeaponStats stats;
  late ShootStrategy shootStrategy;
  late AbstractBullet bullets;

  UpgradeContext({
    required this.stats,
    required this.shootStrategy,
    required this.bullets,
  });
}
