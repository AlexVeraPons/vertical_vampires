import 'package:flame_forge2d/flame_forge2d.dart';

class Platform extends BodyComponent {
  final Vector2 position;
  final Vector2 size;
  final BodyType bodyType;

  Platform(this.position, this.size, this.bodyType);

  @override
  Body createBody() {
    final PolygonShape shape = PolygonShape();
    shape.setAsBox(size.x / 2, size.y / 2, Vector2.zero(), 0.0);

    final fixtureDef = FixtureDef(shape)
      ..restitution = 0.0
      ..density = 1.0
      ..friction = 0.0;

    final bodyDef = BodyDef()
      ..position = position
      ..type = bodyType;

    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }
}
