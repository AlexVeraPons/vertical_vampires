import 'package:flame/components.dart';
import 'abstract_bullet.dart';

class BulletPool extends Component {
  final Map<Type, List<AbstractBullet>> _pool = {};

  BulletPool();

  AbstractBullet obtainBullet(AbstractBullet prefab) {
    AbstractBullet bullet;
    bullet = prefab.createNewInstance();
    bullet.pool = this;
    return bullet;
  }

  void releaseBullet(AbstractBullet bullet) {
    final bulletType = bullet.runtimeType;
    _pool.putIfAbsent(bulletType, () => []);
    _pool[bulletType]!.add(bullet);
  }
}
