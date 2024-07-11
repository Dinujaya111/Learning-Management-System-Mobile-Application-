import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:slitem/auth/login_page.dart';
import 'package:slitem/firebase_options.dart';
import 'package:velocity_x/velocity_x.dart';
import 'core/store.dart';
import 'pages/cart_page.dart';
import 'utils/routes.dart';
import 'widgets/themes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(VxState(store: MyStore(), child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      builder: (context, _) {
        final themeProvider = Provider.of<ThemeProvider>(context);
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          themeMode: themeProvider.themeMode,
          theme: Mytheme.lightTheme(context),
          darkTheme: Mytheme.darkTheme(context),
          initialRoute: "/",
          routes: {
            "/": (context) => LoginPage(),
            MyRoutes.homeRoute: (context) => LoginPage(),
            MyRoutes.cartRoute: (context) => CartPage(),
          },
        );
      },
    );
  }
}
