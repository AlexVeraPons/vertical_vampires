import 'package:flame_forge2d/flame_forge2d.dart';

class Player extends BodyComponent {
  final Vector2 position;
  final Vector2 size;


  Player(this.position, this.size);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
  }

  @override
  Body createBody() {
    final shape = PolygonShape()..setAsBox(size.x / 2, size.y / 2, Vector2.zero(), 0);
    final fixtureDef = FixtureDef(shape)
      ..userData = this
      ..restitution = 0.3
      ..density = 0.001
      ..friction = 0.3;
    final bodyDef = BodyDef()
      ..position = position
      ..type = BodyType.dynamic;
    final body = world.createBody(bodyDef)..createFixture(fixtureDef);
    renderBody = true; 
    return body;
  }
}