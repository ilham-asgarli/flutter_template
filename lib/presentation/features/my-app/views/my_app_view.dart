import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/init/router/navigation_service.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../../../utils/app/state/bloc/theme/theme_bloc.dart';
import '../../../../utils/app/config/router/app_router.dart';
import '../../../../utils/app/config/theme/common_theme.dart';
import '../../../../utils/app/config/theme/dark_theme.dart';
import '../../../../utils/app/state/cubit/network/network_cubit.dart';
import '../../../widgets/have_no.dart';
import '../view-models/my_app_view_model.dart';

class MyAppView extends StatefulWidget {
  const MyAppView({Key? key}) : super(key: key);

  @override
  State<MyAppView> createState() => _MyAppViewState();
}

class _MyAppViewState extends State<MyAppView> {
  final MyAppViewModel _myAppViewModel = MyAppViewModel();

  ThemeMode? _themeMode;
  ThemeData? _themeData;

  @override
  void initState() {
    _myAppViewModel.init(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) => buildThemeBloc(),
    );
  }

  Widget buildThemeBloc() {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, ThemeState state) {
        if (state is ThemeChanged) {
          _themeMode = state.themeMode;
          _themeData = state.themeData;
        }

        return buildApp();
      },
    );
  }

  Widget buildApp() {
    return MaterialApp(
      scrollBehavior: const ScrollBehavior().copyWith(overscroll: false),
      debugShowCheckedModeBanner: false,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      themeMode: _themeMode,
      theme: _themeData,
      darkTheme: CommonTheme.instance.getTheme(
        CustomDarkTheme.instance.getDarkTheme(),
      ),
      onGenerateRoute: AppRouter.instance.generateRoute,
      navigatorKey: NavigationService.instance.navigatorKey,
      initialRoute: _myAppViewModel.getInitialRoute(),
      builder: (context, child) {
        return buildNetworkCubit(child);
      },
    );
  }

  Widget buildNetworkCubit(Widget? child) {
    final networkCubitState = context.watch<NetworkCubit>().state;

    return BlocBuilder<NetworkCubit, NetworkState>(
      builder: (context, NetworkState state) {
        if (child == null) {
          return const SizedBox();
        }

        if (networkCubitState is! NetworkInitial) {
          _myAppViewModel.removeSplashScreen();
        }

        if (networkCubitState is ConnectionSuccess) {
          return child;
        }

        if (networkCubitState is ConnectionFailure) {
          return buildNoInternetWidget();
        }

        return const SizedBox();
      },
    );
  }

  buildNoInternetWidget() {
    return Scaffold(
      body: HaveNo(
        description: LocaleKeys.noInternet.tr(),
        iconData: Icons.wifi_off_rounded,
      ),
    );
  }
}
