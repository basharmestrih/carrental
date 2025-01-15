// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Welcome to the car rental app`
  String get greeting {
    return Intl.message(
      'Welcome to the car rental app',
      name: 'greeting',
      desc: '',
      args: [],
    );
  }

  /// `Your best place to ride anywhere`
  String get bestPlaceToRide {
    return Intl.message(
      'Your best place to ride anywhere',
      name: 'bestPlaceToRide',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get email {
    return Intl.message(
      'Email',
      name: 'email',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get password {
    return Intl.message(
      'Password',
      name: 'password',
      desc: '',
      args: [],
    );
  }

  /// `Login`
  String get loginbutton {
    return Intl.message(
      'Login',
      name: 'loginbutton',
      desc: '',
      args: [],
    );
  }

  /// `Sign up by email`
  String get signUpEmail {
    return Intl.message(
      'Sign up by email',
      name: 'signUpEmail',
      desc: '',
      args: [],
    );
  }

  /// `Forgot password`
  String get forgotPassword {
    return Intl.message(
      'Forgot password',
      name: 'forgotPassword',
      desc: '',
      args: [],
    );
  }

  /// `Or continue with:`
  String get continueWith {
    return Intl.message(
      'Or continue with:',
      name: 'continueWith',
      desc: '',
      args: [],
    );
  }

  /// `Google login successful`
  String get googleLoginSuccess {
    return Intl.message(
      'Google login successful',
      name: 'googleLoginSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Google login failed: {error}`
  String googleLoginFailure(Object error) {
    return Intl.message(
      'Google login failed: $error',
      name: 'googleLoginFailure',
      desc: '',
      args: [error],
    );
  }

  /// `Facebook login`
  String get facebookLogin {
    return Intl.message(
      'Facebook login',
      name: 'facebookLogin',
      desc: '',
      args: [],
    );
  }

  /// `Login successful`
  String get loginSuccess {
    return Intl.message(
      'Login successful',
      name: 'loginSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Login failed: {error}`
  String loginFailed(Object error) {
    return Intl.message(
      'Login failed: $error',
      name: 'loginFailed',
      desc: '',
      args: [error],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'fr'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
