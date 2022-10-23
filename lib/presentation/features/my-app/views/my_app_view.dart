import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/base/views/base_view.dart';
import '../../../../core/init/navigation/navigation_service.dart';
import '../../../../utils/app/bloc/theme/theme_bloc.dart';
import '../../../../utils/app/config/navigation/navigation_route.dart';
import '../../../../utils/app/config/theme/common_theme.dart';
import '../../../../utils/app/config/theme/dark_theme.dart';
import '../view-models/my_app_view_model.dart';

class MyAppView extends StatefulWidget {
  const MyAppView({Key? key}) : super(key: key);

  @override
  State<MyAppView> createState() => _MyAppViewState();
}

class _MyAppViewState extends State<MyAppView> {
  late MyAppViewModel _myAppViewModel;

  @override
  Widget build(BuildContext context) {
    return BaseView<MyAppViewModel>(
      viewModel: MyAppViewModel(),
      onModelReady: (model) {
        model.init(context);
        _myAppViewModel = model;
      },
      onPageBuilder: (BuildContext context, MyAppViewModel viewModel) =>
          Sizer(builder: (context, orientation, deviceType) {
        return BlocBuilder<ThemeBloc, ThemeState>(
          builder: (context, state) {
            ThemeMode? themeMode;
            ThemeData? themeData;

            if (state is ThemeChanged) {
              themeMode = state.themeMode;
              themeData = state.themeData;
            }

            return MaterialApp(
              scrollBehavior:
                  const ScrollBehavior().copyWith(overscroll: false),
              debugShowCheckedModeBanner: false,
              localizationsDelegates: context.localizationDelegates,
              supportedLocales: context.supportedLocales,
              locale: context.locale,
              themeMode: themeMode,
              theme: themeData,
              darkTheme: CommonTheme.instance
                  .getTheme(CustomDarkTheme.instance.getDarkTheme()),
              onGenerateRoute: NavigationRoute.instance.generateRoute,
              navigatorKey: NavigationService.instance.navigatorKey,
              initialRoute: _myAppViewModel.getInitialRoute(),
            );
          },
        );
      }),
    );
  }
}
