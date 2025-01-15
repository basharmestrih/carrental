import 'package:carrentalapp/features/Authentication/application/Firebase_Proider.dart';
import 'package:carrentalapp/features/Authentication/presentation/Login_Page.dart';
import 'package:carrentalapp/main_app/Splash_Screen.dart';
import 'package:carrentalapp/features/Fetch_Cars/application/Cars_Cubit.dart';
import 'package:carrentalapp/features/Fetch_Cars/data/Cars_Web_Sers.dart';
import 'package:carrentalapp/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:carrentalapp/features/Fetch_Cars/data/Cars_Repo.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'Localization/generated/l10n.dart';
import 'package:carrentalapp/stripe_keys/key_constants.dart';
import 'package:open_street_map_search_and_pick/open_street_map_search_and_pick.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey = publishable_key;
  Stripe.instance.applySettings();

  // Initialize Firebase
   Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize Hive
  try {
    await Hive.initFlutter();
     Hive.openBox<String>('settings');
    await Hive.openBox('carBox');
     await Hive.openBox('user_nsme');
     Hive.openBox('seto');
    final langBox = await Hive.openBox<String>('applanguage');

  } catch (e) {
    debugPrint('Error initializing Hive: $e');
  }
  

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProviders(),
        ),
        BlocProvider(
          create: (context) => CarsCubit(CarsRepository(CarsWebServices()))
            ..getAllCarsFunctions(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final langBox = Hive.box<String>('applanguage');
    final currentLang = langBox.get('language', defaultValue: 'fr');
    return MaterialApp(
      locale:  Locale(currentLang!),
      localizationsDelegates: [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      debugShowCheckedModeBanner: false, // Remove the debug banner
      title: 'Car Rental App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2C2B2A)),
        useMaterial3: true,
      ),
      home:  const SplashScreen(), // Show the splash screen initially
    );
  }
}
