part of 'home_cubit.dart';

class HomeState extends Equatable {
  final ViewData<WarehouseResponseDto> warehouseState;
  final ViewData<OverviewResponseDto> overviewState;
  final ViewData<UserResponseDto> userState;
  // final ViewData<OperationResponseDto> operationState;

  const HomeState({
    required this.warehouseState,
    required this.overviewState,
    required this.userState,
    // required this.operationState
  });

  HomeState copyWith({
    ViewData<WarehouseResponseDto>? warehouseState,
    ViewData<OverviewResponseDto>? overviewState,
    ViewData<UserResponseDto>? userState,
    // ViewData<OperationResponseDto>? operationState
  }) {
    return HomeState(
      warehouseState: warehouseState ?? this.warehouseState,
      overviewState: overviewState ?? this.overviewState,
      userState: userState ?? this.userState,
      // operationState: operationState ?? this.operationState,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HomeState &&
          runtimeType == other.runtimeType &&
          warehouseState == other.warehouseState &&
          overviewState == other.overviewState &&
          userState == other.userState;

  @override
  List<Object?> get props => [warehouseState, overviewState, userState];

  @override
  int get hashCode =>
      warehouseState.hashCode ^ overviewState.hashCode ^ userState.hashCode;
}
