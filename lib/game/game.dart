import 'package:flame/events.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vertical_vampires/bloc/game_bloc/game_bloc.dart';
import 'package:vertical_vampires/game/platform.dart';
import 'package:vertical_vampires/game/player/player.dart';

class SurvivorsGame extends Forge2DGame with HasKeyboardHandlerComponents {
  final BuildContext context;

  SurvivorsGame(this.context) : super(gravity: Vector2(0, 100));

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    final viewportSize = camera.viewport.size;

    add(Player(Vector2(viewportSize.x/2,viewportSize.y-200), Vector2(30, 50)));
    add(Platform(Vector2(viewportSize.x/2, viewportSize.y), Vector2(viewportSize.x, 50), BodyType.static));


    context.read<GameBloc>().add(StartEvent());
  }
}
