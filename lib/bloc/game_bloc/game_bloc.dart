import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:vertical_vampires/bloc/game_bloc/game_event.dart';
import 'package:vertical_vampires/bloc/game_bloc/game_state.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  GameBloc() : super(StartState()) {
    on<StartEvent>((event, emit) => emit(StartState()));

    on<BattleEvent>((event, emit) => emit(BattleState()));

    on<UpgradeEvent>((event, emit) => emit(UpgradeState()));

    on<EndEvent>((event, emit) async {
      emit(EndState());
      await Future.delayed(const Duration(seconds: 1));
      add(ResetGameEvent());
    });

    on<ResetGameEvent>((event, emit) {
      emit(ResetState());
    });
  }
}
