import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:konnectify/http/services/shared_prefs.dart';
import 'package:konnectify/routes/routes.dart';
import 'package:konnectify/views/screens/authetication/otp_screen.dart';
import 'package:konnectify/views/screens/authetication/register.dart';
import 'package:konnectify/views/screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  bool isLoggedIn = await LoginPersistence.isLoggedIn();
  runApp(ProviderScope(
      child: MyApp(
    isLoggedin: isLoggedIn,
  )));
}

class MyApp extends StatelessWidget {
  final bool isLoggedin;
  const MyApp({super.key, required this.isLoggedin});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(360, 700),
        builder: (context, child) {
          return GetMaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Konnectify',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              //useMaterial3: true,
            ),
            //home: const HomePage(),
            onGenerateRoute: (settings) {
              if (settings.name == OTPScreen.routeName) {
                final args = settings.arguments as Map<String, dynamic>;
                return MaterialPageRoute(
                    builder: (context) => OTPScreen(
                          verificationId: args['verificationId'],
                        ));
              }
              return null;
            },
            initialRoute: isLoggedin
                ? HomeScreen.routeName
                : RegistrationScreen.routeName,
            routes: routes,
          );
        });
  }
}
