import 'package:flutter/material.dart';

import '../../init/cache/shared_preferences_manager.dart';
import '../../init/router/navigation_service.dart';

abstract class BaseViewModel {
  late BuildContext buildContext;

  SharedPreferencesManager sharedPreferencesManager =
      SharedPreferencesManager.instance;
  NavigationService navigation = NavigationService.instance;
  //Box hiveBox = Hive.box(HiveConstants.userBox);

  /// If you want to set user info before screen created call super.init(); first at override on init function
  void init(context) {
    setBuildContext(context);
  }

  void setBuildContext(BuildContext context) {
    buildContext = context;
  }
}
