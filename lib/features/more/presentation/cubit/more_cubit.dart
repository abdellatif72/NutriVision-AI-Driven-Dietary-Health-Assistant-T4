import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:afia/features/more/presentation/cubit/more_state.dart';

class MoreCubit extends Cubit<MoreState> {
  MoreCubit() : super(const MoreState());

  void loadProfile() {
    emit(state.copyWith(isLoading: true));
    emit(state.copyWith(isLoading: false));
  }

  void updateName(String name) {
    final initials = name
        .split(' ')
        .map((w) => w.isNotEmpty ? w[0] : '')
        .take(2)
        .join()
        .toUpperCase();
    emit(state.copyWith(name: name, initials: initials));
  }
}
