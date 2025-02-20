import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import 'package:vertical_vampires/bloc/player_bloc/player_bloc.dart';
import 'package:vertical_vampires/bloc/player_bloc/player_state.dart';

class LifeUI extends PositionComponent {
  final PlayerBloc playerBloc;
  late final RectangleComponent _barBackground;
  late final RectangleComponent _barFill;

  final double maxHealth;
  double currentHealth;

  LifeUI({
    required this.playerBloc,
    this.maxHealth = 100.0,
    double? initialHealth,
  }) : currentHealth = initialHealth ?? 100.0;

  final Vector2 _defaultPosition = Vector2(10, 60);
  final Vector2 _defaultSize = Vector2(200, 20);
  final Paint _backgroundPaint = Paint()..color = Colors.black;
  final Paint _fillPaint = Paint()..color = Colors.red;
  late final double _minHealthPercentage = 0.0;
  late final double _maxHealthPercentage = 1.0;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    _initPositionAndSize();
    _initBars();
    _subscribeToBloc();
  }

  void _initPositionAndSize() {
    position = _defaultPosition;
    size = _defaultSize;
  }

  void _initBars() {
    _barBackground = RectangleComponent(
      position: Vector2.zero(),
      size: size,
      paint: _backgroundPaint,
    );

    _barFill = RectangleComponent(
      position: Vector2.zero(),
      size: Vector2(size.x * (currentHealth / maxHealth), size.y),
      paint: _fillPaint,
    );
    add(_barBackground);
    add(_barFill);
  }

  void _subscribeToBloc() => playerBloc.stream.listen((state) {
        if (state is PlayerHitState) _updateHealth(state.currentHealth);
      });

  void _updateHealth(double newHealth) {
    currentHealth = newHealth;
    final healthPercentage = (currentHealth / maxHealth)
        .clamp(_minHealthPercentage, _maxHealthPercentage);
    _barFill.size = Vector2(size.x * healthPercentage, size.y);
  }
}
