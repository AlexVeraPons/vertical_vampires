import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';
import 'package:vertical_vampires/game/upgrade/upgrade_system.dart';

class UpgradeSelectionComponent extends PositionComponent
    with HasGameRef, TapCallbacks {
  final UpgradeSystem upgradeSystem;
  final List<Upgrade> upgrades;

  UpgradeSelectionComponent({
    required this.upgradeSystem,
    required this.upgrades,
  });

  @override
  Future<void> onLoad() async {
    super.onLoad();

    size = gameRef.size;
    anchor = Anchor.topLeft;

    final double boxWidth = 200;
    final double boxHeight = 150;
    final double spacing = 50;

    final double totalWidth = boxWidth * 3 + spacing * 2;
    final double startX = (size.x - totalWidth) / 2;
    final double centerY = (size.y - boxHeight) / 2;

    for (int i = 0; i < upgrades.length; i++) {
      final xPos = startX + i * (boxWidth + spacing);
      final box = UpgradeBox(
        upgrade: upgrades[i],
        position: Vector2(xPos, centerY),
        size: Vector2(boxWidth, boxHeight),
        onUpgradeSelected: (selectedUpgrade) {
          // Apply the chosen upgrade
          selectedUpgrade.applyUpgrade();
          // Remove this selection UI
          removeFromParent();
          // Resume the game
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
    super.onLoad();

    add(RectangleComponent(
      size: size,
      paint: BasicPalette.blue.paint()..style = PaintingStyle.fill,
    ));

    final textPaint = TextPaint(
      style: TextStyle(color: Colors.white, fontSize: 14),
    );

    add(
      TextComponent(
        text: upgrade.title,
        textRenderer: textPaint,
        position: Vector2(10, 10),
      ),
    );

    add(
      TextBoxComponent(
        text: upgrade.description,
        textRenderer: textPaint,
        boxConfig: TextBoxConfig(
          maxWidth: size.x - 20,
          timePerChar: 0.0,
        ),
        position: Vector2(10, 30),
      ),
    );
  }

  @override
  void onTapDown(TapDownEvent event) {
    onUpgradeSelected(upgrade);
  }
}
