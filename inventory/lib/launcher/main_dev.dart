import 'package:flutter/widgets.dart';
import 'package:intl/date_symbol_data_local.dart';

import '../app/main_app.dart';
import '../core/network/flavor/app_flavor.dart';
import '../injections/injections.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );
  Config.appFlavor = Flavor.development;
  // SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
  //   // systemNavigationBarColor: Colors.blue, // navigation bar color
  //   // statusBarColor: ColorName.whiteColor, // status bar color
  //   // Status bar brightness (optional)
  //   statusBarIconBrightness: Brightness.dark, // For Android (dark icons)
  //   statusBarBrightness: Brightness.light, // For iOS (dark icons)
  // )

  await Injections().initialize();
  await initializeDateFormatting('id_ID', null).then(
    (_) => runApp(
      const MainApp(),
    ),
  );
}
