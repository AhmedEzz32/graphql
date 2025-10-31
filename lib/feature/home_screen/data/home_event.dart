import 'package:equatable/equatable.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

class ChangeTab extends HomeEvent {
  final int tabIndex;

  const ChangeTab(this.tabIndex);

  @override
  List<Object?> get props => [tabIndex];
}
