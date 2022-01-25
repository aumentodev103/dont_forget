import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:dont_forget/providers/auth.dart';
import 'package:dont_forget/screens/dashboard_screen.dart';
import 'package:dont_forget/screens/login_screen.dart';
import 'package:dont_forget/screens/user_details_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const DontForgetApp());
}

class DontForgetApp extends StatelessWidget {
  const DontForgetApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Auth(),
        ),
      ],
      child: Consumer<Auth>(
        builder: (context, value, child) {
          return MaterialApp(
            title: "Don't Forget",
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primaryColor: Colors.redAccent,
              fontFamily: "Opensans",
              disabledColor: Colors.grey,
            ),
            initialRoute: LoginScreen.routeName,
            routes: {
              LoginScreen.routeName: (_) => const LoginScreen(),
              UserDetailsScreen.routeName: (_) => const UserDetailsScreen(),
              DashboardScreen.routeName: (_) => const DashboardScreen(),
              // BarcodeScanScreen.routeName: (_) => const BarcodeScanScreen(),
            },
          );
        },
      ),
    );
  }
}
