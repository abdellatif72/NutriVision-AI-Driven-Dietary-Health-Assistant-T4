import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum MainTab {
  home(indexInStack: 0),
  progress(indexInStack: 1);

  const MainTab({required this.indexInStack});

  final int indexInStack;
}

class MainShellState extends Equatable {
  const MainShellState({this.tab = MainTab.home});

  final MainTab tab;

  MainShellState copyWith({MainTab? tab}) =>
      MainShellState(tab: tab ?? this.tab);

  @override
  List<Object?> get props => [tab];
}

class MainShellCubit extends Cubit<MainShellState> {
  MainShellCubit() : super(const MainShellState());

  void selectTab(MainTab tab) {
    if (state.tab == tab) return;
    emit(state.copyWith(tab: tab));
  }
}
