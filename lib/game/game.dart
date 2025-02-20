import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame/events.dart';
import 'package:vertical_vampires/bloc/game_bloc/game_bloc.dart';
import 'package:vertical_vampires/bloc/game_bloc/game_state.dart';
import 'package:vertical_vampires/bloc/player_bloc/player_bloc.dart';
import 'package:vertical_vampires/bloc/player_bloc/player_state.dart';
import 'package:vertical_vampires/game/enemy/bat_enemy.dart';
import 'package:vertical_vampires/game/enemy/dragon_enemy.dart';
import 'package:vertical_vampires/game/enemy/enemy_spawner.dart';
import 'package:vertical_vampires/game/platform.dart';
import 'package:vertical_vampires/game/player/player.dart';
import 'package:vertical_vampires/game/player/player_controller.dart';
import 'package:vertical_vampires/game/ui/life_ui.dart';
import 'package:vertical_vampires/game/ui/score_ui.dart';
import 'package:vertical_vampires/game/upgrade/upgrade_system.dart';

class SurvivorsGame extends Forge2DGame with HasKeyboardHandlerComponents {
  final GameBloc gameBloc;
  final PlayerBloc playerBloc;

  final String _backgroundMusic = 'background.mp3';
  final String _upgradeSound = 'upgrade.mp3';
  final String _backgroundImage = 'background.png';
  final double _backgroundVolume = 0.25;
  final Vector2 _playerSize = Vector2(50, 70);
  final double _platformHeight = 50;

  SurvivorsGame({required this.gameBloc, required this.playerBloc})
      : super(gravity: Vector2(0, 100)) {
    debugMode = false;
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    final viewportSize = camera.viewport.size;
    await _initializeAudio();
    await _addBackground(viewportSize);
    _addPlayer(viewportSize);
    _addPlatform(viewportSize);
    _addEnemySpawner();
    _addUI();
    _subscribeToPlayerDeath();
    gameBloc.add(StartEvent());
  }

  Future<void> _initializeAudio() async {
    await FlameAudio.audioCache.loadAll([_backgroundMusic, _upgradeSound]);
    FlameAudio.bgm.initialize();
    FlameAudio.bgm.play(_backgroundMusic, volume: _backgroundVolume);
  }

  Future<void> _addBackground(Vector2 viewportSize) async {
    final bgSprite = await loadSprite(_backgroundImage);
    add(SpriteComponent()
      ..sprite = bgSprite
      ..size = viewportSize);
  }

  void _addPlayer(Vector2 viewportSize) {
    final playerPosition = Vector2(viewportSize.x / 2, viewportSize.y / 2);
    final player = Player(playerPosition, _playerSize, playerBloc);
    add(player);
    player.add(PlayerController(playerBloc));
  }

  void _addPlatform(Vector2 viewportSize) {
    final platformPosition = Vector2(viewportSize.x / 2, viewportSize.y);
    final platformSize = Vector2(viewportSize.x, _platformHeight);
    add(Platform(platformPosition, platformSize, BodyType.static));
  }

  void _addEnemySpawner() {
    final possibleEnemies = [
      EnemyContainer(BatEnemy, 1),
      EnemyContainer(DragonEnemy, 3),
    ];
    add(EnemySpawner(possibleEnemies: possibleEnemies, playerBloc: playerBloc));
  }

  void _addUI() {
    add(ScoreUI(playerBloc: playerBloc));
    add(LifeUI(playerBloc: playerBloc));
    add(UpgradeSystem(playerBloc));
  }

  void _subscribeToPlayerDeath() =>
      playerBloc.stream.listen((state) {
        if (state is PlayerDeathState) _playerDeath();
      });

  void _playerDeath() => gameBloc.add(EndEvent());
}
