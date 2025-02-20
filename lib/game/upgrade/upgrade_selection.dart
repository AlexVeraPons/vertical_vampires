import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';
import 'package:vertical_vampires/game/upgrade/upgrade_system.dart';

class UpgradeSelectionComponent extends PositionComponent with HasGameRef, TapCallbacks {
  final UpgradeSystem upgradeSystem;
  final List<Upgrade> upgrades;

  final double _boxWidth = 200.0;
  final double _boxHeight = 150.0;
  final double _spacing = 50.0;

  UpgradeSelectionComponent({
    required this.upgradeSystem,
    required this.upgrades,
  });

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    size = gameRef.size;
    anchor = Anchor.topLeft;
    final double totalWidth = _boxWidth * upgrades.length + _spacing * (upgrades.length - 1);
    final double startX = (size.x - totalWidth) / 2;
    final double centerY = (size.y - _boxHeight) / 2;
    for (int i = 0; i < upgrades.length; i++) {
      final xPos = startX + i * (_boxWidth + _spacing);
      final box = UpgradeBox(
        upgrade: upgrades[i],
        position: Vector2(xPos, centerY),
        size: Vector2(_boxWidth, _boxHeight),
        onUpgradeSelected: (selectedUpgrade) {
          selectedUpgrade.applyUpgrade();
          removeFromParent();
          upgradeSystem.resumeGame();
        },
      );
      add(box);
    }
  }
}

class UpgradeBox extends PositionComponent with TapCallbacks {
  final Upgrade upgrade;
  final void Function(Upgrade) onUpgradeSelected;

  final Vector2 _titlePosition = Vector2(10, 10);
  final Vector2 _descriptionPosition = Vector2(10, 30);
  final double _textPadding = 10.0;

  UpgradeBox({
    required this.upgrade,
    required Vector2 position,
    required Vector2 size,
    required this.onUpgradeSelected,
  }) {
    this.position = position;
    this.size = size;
    anchor = Anchor.topLeft;
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(RectangleComponent(
      size: size,
      paint: BasicPalette.blue.paint()..style = PaintingStyle.fill,
    ));
    final textPaint = TextPaint(
      style: TextStyle(color: Colors.white, fontSize: 14),
    );
    add(TextComponent(
      text: upgrade.title,
      textRenderer: textPaint,
      position: _titlePosition,
    ));
    add(TextBoxComponent(
      text: upgrade.description,
      textRenderer: textPaint,
      boxConfig: TextBoxConfig(
        maxWidth: size.x - 2 * _textPadding,
        timePerChar: 0.0,
      ),
      position: _descriptionPosition,
    ));
  }

  @override
  void onTapDown(TapDownEvent event) => onUpgradeSelected(upgrade);
}
