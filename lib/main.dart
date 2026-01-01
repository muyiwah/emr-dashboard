import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart' as provider_package;
import 'package:schmgtsystem/constants/appcolor.dart';
import 'package:schmgtsystem/router/app_router.dart';
import 'package:schmgtsystem/providers/patient_proviider.dart';
import 'package:schmgtsystem/providers/user_provider.dart';

void main() {
  runApp(
    ProviderScope(
      child: provider_package.MultiProvider(
        providers: [
          provider_package.ChangeNotifierProvider(
            create: (_) => UserProvider(),
          ),
          provider_package.ChangeNotifierProvider(
            create: (_) => PatientProvider(),
          ),
        ],
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      child: MaterialApp.router(
        routerConfig: router,
        debugShowCheckedModeBanner: false,
        localizationsDelegates: const [
          FlutterQuillLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('en'), Locale('fr'), Locale('es')],
        title: 'MediCore EMR',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: AppColors.secondary),
          useMaterial3: true,
        ),
      ),
    );
  }
}
