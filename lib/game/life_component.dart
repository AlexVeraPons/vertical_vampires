import 'package:flame/components.dart';

class LifeComponent extends Component {
  double _maxHealth;
  double _currentHealth;
  final void Function() _onDeath;
  final void Function(double)? _onHit;
  LifeComponent({
    required double maxHealth,
    required void Function() onDeath,
    void Function(double ammount)? onHit,
  })  : _onDeath = onDeath,
        _onHit = onHit,
        _maxHealth = maxHealth,
        _currentHealth = maxHealth;

  get currentLife => null;

  void takeDamage(double amount) {
    _currentHealth -= amount;
    if (_onHit != null) {
      _onHit!(_currentHealth);
    }
    if (_currentHealth <= 0) {
      _currentHealth = 0;
      _onDeath();
      removeFromParent();
    }
  }

  void heal(double amount) {
    _currentHealth = (_currentHealth + amount).clamp(0, _maxHealth);
  }
}
