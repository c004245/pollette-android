import 'package:flame/components.dart';
import 'package:flame_forge2d/contact_callbacks.dart';
import 'package:flame_forge2d/flame_forge2d.dart';

class BlackholeComponent extends BodyComponent with ContactCallbacks {
  final Vector2 position;

  BlackholeComponent({required this.position});

  @override
  Future<void> onLoad() async {
    super.onLoad();
    final sprite = await Sprite.load('blackhole.png');
    final blackhole = SpriteComponent(
      sprite: sprite,
      size: Vector2(48, 48),
      anchor: Anchor.center
    );
    add(blackhole);
  }
  @override
  bool get debugMode => false;

  @override
  Body createBody() {
    final bodyDef = BodyDef(
      type: BodyType.static,
      position: position,
    );

    final body = world.createBody(bodyDef);
    final shape = CircleShape()..radius = 24;
    final fixtureDef = FixtureDef(shape)
      ..isSensor = true;
    body.createFixture(fixtureDef);

    body.userData = this;
    return body;
  }
}
