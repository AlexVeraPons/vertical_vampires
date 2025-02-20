import 'dart:async';
import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:vertical_vampires/bloc/player_bloc/player_bloc.dart';
import 'package:vertical_vampires/bloc/player_bloc/player_state.dart';
import 'package:vertical_vampires/game/enemy/abstract_enemy.dart';
import 'package:vertical_vampires/game/enemy/bat_enemy.dart';
import 'package:vertical_vampires/game/enemy/dragon_enemy.dart';

class EnemySpawner extends Component with HasGameRef<Forge2DGame> {
  
  final List<EnemyContainer> _possibleEnemies;
  double _spawnRate;
  final int _maxEnemies;
  int _currentDifficulty = 1;
  double _timeSinceLastSpawn = 0.0;
  final List<AbstractEnemy> _activeEnemies = [];

  final Random _random = Random();

  final PlayerBloc _playerBloc;

  EnemySpawner({
    required List<EnemyContainer> possibleEnemies,
    required PlayerBloc playerBloc,
    double spawnRate = 3.0,
    int maxEnemies = 10,
  }) : _playerBloc = playerBloc, _possibleEnemies = possibleEnemies, _maxEnemies = maxEnemies, _spawnRate = spawnRate;

  @override
  FutureOr<void> onLoad() async {
    await super.onLoad();
    _playerBloc.stream.listen((playerState) {
      if (playerState is PlayerUpgradeState) {
        _currentDifficulty++;
      }
    });
  }

  @override
  void update(double dt) {
    super.update(dt);
    _timeSinceLastSpawn += dt;

    if (_timeSinceLastSpawn >= _spawnRate && _activeEnemies.length < _maxEnemies) {
      _spawnEnemy();
      _timeSinceLastSpawn = 0.0;
      _spawnRate /= 1.05; // Gradually decrease spawn rate to increase challenge.
    }

    _activeEnemies.removeWhere((enemy) => enemy.isRemoved);
  }

  void _spawnEnemy() {
    final Vector2 spawnPosition = _getRandomSpawnPosition();
    final AbstractEnemy? newEnemy = _createRandomEnemy(spawnPosition);

    if (newEnemy != null) {
      gameRef.add(newEnemy);
      _activeEnemies.add(newEnemy);
    }
  }

  AbstractEnemy? _createRandomEnemy(Vector2 spawnPosition) {
    final availableEnemies = _possibleEnemies
        .where((enemyContainer) => enemyContainer.minimumDifficulty <= _currentDifficulty)
        .toList();

    if (availableEnemies.isEmpty) {
      print('No available enemies to spawn.');
      return null;
    }

    final int enemyIndex = _random.nextInt(availableEnemies.length);
    final Type enemyType = availableEnemies[enemyIndex].enemyType;

    return _instantiateEnemy(enemyType, spawnPosition);
  }

  AbstractEnemy _instantiateEnemy(Type enemyType, Vector2 position) {
    if (enemyType == BatEnemy) return BatEnemy(position: position);
    if (enemyType == DragonEnemy) return DragonEnemy(position: position);
    throw Exception("Unknown enemy type: $enemyType");
  }

  Vector2 _getRandomSpawnPosition() {
    final double screenWidth = gameRef.size.x;
    final double screenHeight = gameRef.size.y;

    final double x = _random.nextBool() ? -50 : screenWidth + 50;
    final double y = _random.nextDouble() * screenHeight;

    return Vector2(x, y);
  }
}

class EnemyContainer {
  final Type enemyType;
  final int minimumDifficulty;

  EnemyContainer(this.enemyType, this.minimumDifficulty);
}
