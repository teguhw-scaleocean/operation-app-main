import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory/core/navigation/argument/home_argument.dart';
import 'package:inventory/core/navigation/argument/stock_count_session_line.dart';
import 'package:inventory/core/navigation/argument/stock_session_detail_argument.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../core/navigation/argument/operation_argument.dart';
import '../core/navigation/argument/operation_detail_argument.dart';
import '../core/navigation/argument/stock_count_session.dart';
import '../core/navigation/navigation_helper.dart';
import '../core/navigation/routes.dart';
import '../features/authentication/presentation/bloc/sign_in_bloc.dart';
import '../features/authentication/presentation/ui/sign_in_screen.dart';
import '../features/home/presentation/cubit/home_cubit.dart';
import '../features/home/presentation/cubit/stock_count_line_cubit/stock_count_line_cubit.dart';
import '../features/home/presentation/cubit/stock_opname_cubit/stock_count_session_cubit.dart';
import '../features/home/presentation/cubit/user_cubit/user_cubit.dart';
import '../features/home/presentation/ui/home_screen.dart';
import '../features/home/presentation/ui/profile_screen.dart';
import '../features/home/presentation/ui/stock_count_session_detail_screen.dart';
import '../features/home/presentation/ui/stock_count_session_screen.dart';
import '../features/onboarding/presentation/onboarding_cubit/onboarding_cubit.dart';
import '../features/onboarding/presentation/splash_cubit/splash_cubit.dart';
import '../features/onboarding/presentation/ui/onboarding_screen.dart';
import '../features/onboarding/presentation/ui/splash_screen.dart';
import '../features/operation/presentation/cubit/detail_barcode_cubit/detail_barcode_cubit.dart';
import '../features/operation/presentation/cubit/detail_cubit/detail_cubit.dart';
import '../features/operation/presentation/cubit/operation_cubit.dart';
import '../features/operation/presentation/ui/operation_detail_screen.dart';
import '../features/operation/presentation/ui/operation_screen.dart';
import '../injections/injections.dart';
import '../shared_libraries/common/theme/theme.dart';

class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // designSize: const Size(360, 800),
    return MaterialApp(
      useInheritedMediaQuery: true,
      // locale: DevicePreview.locale(context),
      builder: (context, child) => ResponsiveWrapper.builder(
        ClampingScrollWrapper.builder(context, child!),
        breakpoints: const [
          ResponsiveBreakpoint.resize(350, name: MOBILE),
          ResponsiveBreakpoint.autoScale(800, name: TABLET),
          // ResponsiveBreakpoint.resize(800, name: DESKTOP),
          // ResponsiveBreakpoint.autoScale(1700, name: 'XL'),
        ],
      ),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BlocProvider(
        create: (context) => SplashCubit(
          getOnBoardingUseCase: sl(),
          getTokenUsecase: sl(),
        )..splashInit(),
        child: const AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle(
              statusBarColor: ColorName.gradient1Color,
            ),
            child: Scaffold(body: SplashScreen())),
      ),
      navigatorKey: NavigationHelperImpl.navigatorKey,
      onGenerateRoute: (RouteSettings settings) {
        final argument = settings.arguments;

        switch (settings.name) {
          case AppRoutes.onboarding:
            return MaterialPageRoute(
                builder: (_) => BlocProvider(
                      create: (context) =>
                          OnboardingCubit(cachedOnboardingUsecase: sl()),
                      child: const AnnotatedRegion<SystemUiOverlayStyle>(
                          value: SystemUiOverlayStyle(
                            statusBarIconBrightness: Brightness.dark,
                            statusBarBrightness: Brightness.light,
                            statusBarColor: ColorName.whiteColor,
                          ),
                          child: OnBoardingScreen()),
                    ));
          case AppRoutes.signIn:
            return MaterialPageRoute(
                builder: (_) => MultiBlocProvider(
                      providers: [
                        BlocProvider(
                          create: (context) => SignInBloc(
                            signInUseCase: sl(),
                            cachedTokenUsecase: sl(),
                          ),
                        ),
                        BlocProvider<UserCubit>(
                          create: (context) => UserCubit(
                            getUserUsecase: sl(),
                            sharedPreferences: sl(),
                          ),
                        ),
                      ],
                      child: AnnotatedRegion<SystemUiOverlayStyle>(
                          value: const SystemUiOverlayStyle(
                            statusBarIconBrightness: Brightness.dark,
                            statusBarBrightness: Brightness.light,
                            statusBarColor: ColorName.whiteColor,
                          ),
                          child: SignInScreen()),
                    ));
          case AppRoutes.home:
            return MaterialPageRoute(
                builder: (_) => MultiBlocProvider(
                      providers: [
                        BlocProvider(
                          create: (context) => HomeCubit(
                              getWarehouseUsecase: sl(),
                              getOverviewUsecase: sl(),
                              getUserUsecase: sl(),
                              sharedPreferences: sl()),
                        ),
                        BlocProvider<UserCubit>(
                          create: (context) => UserCubit(
                            getUserUsecase: sl(),
                            sharedPreferences: sl(),
                          ),
                        ),
                        BlocProvider<StockCountSessionCubit>(
                          create: (context) => StockCountSessionCubit(
                              sharedPreferences: sl(),
                              getStockCountSessionUsecase: sl()),
                        ),
                      ],
                      child: const AnnotatedRegion<SystemUiOverlayStyle>(
                          value: SystemUiOverlayStyle(
                            statusBarIconBrightness: Brightness.light,
                            statusBarBrightness: Brightness.light,
                            statusBarColor: ColorName.mainColor,
                          ),
                          child: HomeScreen(isSigned: false)),
                    ));
          case AppRoutes.profile:
            return MaterialPageRoute(builder: (_) => ProfileScreen());
          case AppRoutes.stockSchedule:
            return MaterialPageRoute(
                builder: (_) => BlocProvider<StockCountSessionCubit>(
                      create: (context) => StockCountSessionCubit(
                          sharedPreferences: sl(),
                          getStockCountSessionUsecase: sl()),
                      child: AnnotatedRegion<SystemUiOverlayStyle>(
                          value: const SystemUiOverlayStyle(
                            statusBarIconBrightness: Brightness.dark,
                            statusBarBrightness: Brightness.light,
                            statusBarColor: ColorName.whiteColor,
                          ),
                          child: StockCountSessionScreen(
                            stockCountSessionArgument:
                                argument as StockCountSessionArgument,
                          )),
                    ));
          case AppRoutes.operation:
            return MaterialPageRoute(
              builder: (_) => BlocProvider<OperationCubit>(
                create: (_) => OperationCubit(
                  getOperationUsecase: sl(),
                  getOperationStateUsecase: sl(),
                  getOperationBackorderUsecase: sl(),
                  sharedPreferences: sl(),
                ),
                child: AnnotatedRegion<SystemUiOverlayStyle>(
                  value: const SystemUiOverlayStyle(
                      statusBarIconBrightness: Brightness.dark,
                      statusBarBrightness: Brightness.light,
                      statusBarColor: ColorName.whiteColor),
                  child:
                      OperationScreen(argument: argument as OperationArgument),
                ),
              ),
            );
          case AppRoutes.operationDetail:
            return MaterialPageRoute(
                builder: (_) => MultiBlocProvider(
                      providers: [
                        BlocProvider(
                          create: (context) => DetailCubit(
                            getDetailUsecase: sl(),
                            sharedPreferences: sl(),
                          ),
                        ),
                        BlocProvider<DetailBarcodeCubit>(
                            create: (context) => DetailBarcodeCubit(
                                productScanUsecase: sl(),
                                updateDetailUsecase: sl(),
                                sharedPreferences: sl()))
                      ],
                      child: AnnotatedRegion<SystemUiOverlayStyle>(
                        value: const SystemUiOverlayStyle(
                          statusBarIconBrightness: Brightness.dark,
                          statusBarBrightness: Brightness.light,
                          statusBarColor: ColorName.whiteColor,
                        ),
                        child: OperationDetailScreen(
                            argument: argument as OperationDetailArgument),
                      ),
                    ));
          case AppRoutes.stockScheduleDetail:
            return MaterialPageRoute(
                builder: (_) => BlocProvider<StockCountLineCubit>(
                      create: (context) => StockCountLineCubit(
                        getStockCountSessionUsecase: sl(),
                        sharedPreferences: sl(),
                      ),
                      child: AnnotatedRegion<SystemUiOverlayStyle>(
                          value: const SystemUiOverlayStyle(
                              statusBarIconBrightness: Brightness.dark,
                              statusBarBrightness: Brightness.light,
                              statusBarColor: ColorName.whiteColor),
                          child: StockCountSessionDetailScreen(
                            stockSessionDetailArgument:
                                argument as StockSessionDetailArgument,
                          )),
                    ));
          default:
            return MaterialPageRoute(
                builder: (_) => BlocProvider(
                      create: (context) => SplashCubit(
                        getOnBoardingUseCase: sl(),
                        getTokenUsecase: sl(),
                      ),
                      child: const SplashScreen(),
                    ));
        }
      },
    );
  }
}
