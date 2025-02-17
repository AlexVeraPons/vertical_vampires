import 'package:bloc/bloc.dart';

part 'game_event.dart';
part 'game_state.dart';

class GameBloc extends Bloc<GameEvent,GameState> {
  GameBloc() : super(StartState()) {
    on<StartEvent>((event, emit) {
      emit(StartState());
    });
    on<BattleEvent>((event, emit) {
      emit(BattleState());
    });
    on<EndEvent>((event, emit) {
      emit(EndState());
    });
  }
}