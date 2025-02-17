import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame/components.dart';

/// Abstract base class for different movement styles.
/// Uses [updateMovement] with a Vector2 input + an optional jump flag.
abstract class MovementStrategy {
  /// Called on every frame to update entity movement.
  ///
  /// [dt] is the delta time since last frame.
  /// [input] is a Vector2 describing directional input:
  ///   - input.x in [-1, 1] for left/right
  ///   - input.y in [-1, 1] for up/down or forward/back
  /// [jumpPressed] indicates if the jump action is triggered this frame.
  void updateMovement(double dt, Vector2 input, {bool jumpPressed = false});

  /// Optional hook for when this strategy is first activated.
  void onEnterStrategy();

  /// Optional hook for when this strategy is deactivated/changed.
  void onExitStrategy();
}