import 'package:flame/flame.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:vertical_vampires/bloc/player_bloc/player_bloc.dart';
import 'package:vertical_vampires/bloc/player_bloc/player_event.dart';
import 'package:vertical_vampires/bloc/player_bloc/player_state.dart';
import 'package:vertical_vampires/game/life_component.dart';
import 'package:vertical_vampires/game/movement/ground_movement_strategy.dart';
import 'package:vertical_vampires/game/movement/movement_strategy.dart';
import 'package:vertical_vampires/game/player/player_animator.dart';
import 'package:vertical_vampires/game/weapon/bullet/bullet_pool.dart';
import 'package:vertical_vampires/game/weapon/bullet/fast_bullet.dart';
import 'package:vertical_vampires/game/weapon/target_closest_enemy.dart';
import 'package:vertical_vampires/game/weapon/weapon.dart';
import 'package:vertical_vampires/game/weapon/weapon_stats.dart';

const String _PLAYER_IMAGE = 'player.png';
const String _WEAPON_IMAGE = 'wand.png';

class Player extends BodyComponent {
  final Vector2 _position;
  final Vector2 size;
  final PlayerBloc playerBloc;
  final double initialHealth = 100;

  Player(this._position, this.size, this.playerBloc);

  late final MovementStrategy movementStrategy;
  late final PlayerAnimation playerAnimation;
  late final LifeComponent life;
  late final BulletPool bulletPool;

  final Vector2 input = Vector2.zero();
  bool jumpPressed = false;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    final spriteAnimations = await _loadAnimations();
    
    playerAnimation = PlayerAnimation(
      playerBloc: playerBloc,
      playerBody: body,
      externalAnimations: spriteAnimations,
      size: Vector2(size.x, size.y),
    );
    parent?.add(playerAnimation);
    
    playerBloc.stream.listen((state) {
      if (state is PlayerMovementState) _onInput(state.direction, state.jumpPressed);
      if (state is PlayerChangingStrategyState) movementStrategy = state.strategy;
    });
    playerBloc.add(ChangePlayerStrategy(GroundMovementStrategy(playerBody: body)));
    playerBloc.currentHealth = initialHealth;
    
    life = LifeComponent(maxHealth: initialHealth, onDeath: _onDeath, onHit: _onHit);
    add(life);
  }

  @override
  Body createBody() {
    final shape = PolygonShape()..setAsBox(size.x / 2, size.y / 4, Vector2.zero(), 0);
    final fixture = FixtureDef(shape)
      ..restitution = 0
      ..userData = this
      ..density = 0.001
      ..friction = 0.3;
    final bodyDef = BodyDef()
      ..position = _position
      ..type = BodyType.dynamic
      ..linearDamping = 0.0;
    final body = world.createBody(bodyDef)..createFixture(fixture);
    renderBody = false;
    return body;
  }

  @override
  void onMount() async {
    super.onMount();
    bulletPool = await _initializeBulletPool();
    await _initializeWeapon(bulletPool);
  }

  @override
  void update(double dt) {
    super.update(dt);
    movementStrategy.updateMovement(dt, input, jumpPressed: jumpPressed);
  }

  void _onInput(Vector2 input, bool jumpPressed) {
    this.input.setFrom(input);
    this.jumpPressed = jumpPressed;
  }

  Future<Map<PlayerAnimationState, SpriteAnimation>> _loadAnimations() async {
    final image = await Flame.images.load(_PLAYER_IMAGE);
    final spriteSheet = SpriteSheet(image: image, srcSize: Vector2(192, 256));
    return {
      PlayerAnimationState.idle: spriteSheet.createAnimation(row: 0, from: 0, to: 1, stepTime: 0.2),
      PlayerAnimationState.running: spriteSheet.createAnimation(row: 2, from: 6, to: 8, stepTime: 0.1),
      PlayerAnimationState.jumping: spriteSheet.createAnimation(row: 0, from: 2, to: 3, stepTime: 0.3),
      PlayerAnimationState.dead: spriteSheet.createAnimation(row: 3, from: 4, to: 5, stepTime: 0.3),
    };
  }

  void _onDeath() {
    removeFromParent();
    playerBloc.add(PlayerDeath());
  }

  void _onHit(double currentHealth) => playerBloc.add(PlayerHit(currentHealth));

  Future<BulletPool> _initializeBulletPool() async {
    final bp = BulletPool();
    parent?.add(bp);
    return bp;
  }

  Future<void> _initializeWeapon(BulletPool bp) async {
    final sprite = await Sprite.load(_WEAPON_IMAGE);
    final fastRedPrefab = FastBullet();
    final stats = WeaponStats(fireRate: 1.5);
    parent?.add(Weapon(
      stats: stats,
      shootStrategy: TargetClosestEnemyShootStrategy(),
      bulletPrefab: fastRedPrefab,
      bulletPool: bp,
      holdingBody: body,
      sprite: sprite,
      playerBloc: playerBloc,
    ));
  }
}
