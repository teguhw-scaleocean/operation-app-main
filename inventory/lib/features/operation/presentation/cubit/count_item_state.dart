part of 'count_item_cubit.dart';

class CountItemState extends Equatable {
  final ViewData<List<int>> countItemState;

  const CountItemState({required this.countItemState});

  CountItemState copyWith({ViewData<List<int>>? countItemState}) {
    return CountItemState(
        countItemState: countItemState ?? this.countItemState);
  }

  @override
  List<Object> get props => [countItemState];
}
