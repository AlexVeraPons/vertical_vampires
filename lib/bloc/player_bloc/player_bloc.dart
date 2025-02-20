import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:vertical_vampires/game/upgrade/upgrade_system.dart';
import 'package:vertical_vampires/game/weapon/bullet/fast_bullet.dart';
import 'package:vertical_vampires/game/weapon/target_closest_enemy.dart';
import 'package:vertical_vampires/game/weapon/weapon_stats.dart';

import 'player_event.dart';
import 'player_state.dart';

class PlayerBloc extends Bloc<PlayerEvent, PlayerState> {
  int currentExperience = 0;
  late double currentHealth;

  int _experienceThreshold = 50;
  late UpgradeContext _currentContext;

  PlayerBloc() : super(PlayerIdleState()) {
    WeaponStats initialStats = WeaponStats(fireRate: 1);
    TargetClosestEnemyShootStrategy initialStrategy =
        TargetClosestEnemyShootStrategy();
    FastRedBullet initialBullet = FastRedBullet();

    _currentContext = UpgradeContext(
      stats: initialStats,
      shootStrategy: initialStrategy,
      bullets: initialBullet,
    );

    on<MovePlayer>((event, emit) =>
        emit(PlayerMovementState(event.direction, event.jumpPressed)));

    on<ChangePlayerStrategy>(
        (event, emit) => emit(PlayerChangingStrategyState(event.strategy)));

    on<PlayerDeath>((event, emit) => emit(PlayerDeathState()));

    on<PlayerUpgrade>((event, emit) {
      emit(PlayerUpgradeState(event.upgrade));
      _currentContext = event.upgrade;
    });

    on<PlayerGainedXP>((event, emit) {
      currentExperience += event.amount;
      emit(PlayerGainedXPState(currentExperience));
      if (currentExperience > _experienceThreshold) {
        _experienceThreshold *= 2;
        emit(PlayerUpgradeState(_currentContext));
      }
    });

    on<PlayerHit>((event, emit) => emit(PlayerHitState(event.currentHealth)));
  }

  UpgradeContext getUpgradeContext() {
    return _currentContext;
  }
}
