// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en';

  static String m0(error) => "Google login failed: ${error}";

  static String m1(error) => "Login failed: ${error}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "bestPlaceToRide": MessageLookupByLibrary.simpleMessage(
            "Your best place to ride anywhere"),
        "continueWith":
            MessageLookupByLibrary.simpleMessage("Or continue with:"),
        "email": MessageLookupByLibrary.simpleMessage("Email"),
        "facebookLogin": MessageLookupByLibrary.simpleMessage("Facebook login"),
        "forgotPassword":
            MessageLookupByLibrary.simpleMessage("Forgot password"),
        "googleLoginFailure": m0,
        "googleLoginSuccess":
            MessageLookupByLibrary.simpleMessage("Google login successful"),
        "greeting": MessageLookupByLibrary.simpleMessage(
            "Welcome to the car rental app"),
        "loginFailed": m1,
        "loginSuccess":
            MessageLookupByLibrary.simpleMessage("Login successful"),
        "loginbutton": MessageLookupByLibrary.simpleMessage("Login"),
        "password": MessageLookupByLibrary.simpleMessage("Password"),
        "signUpEmail": MessageLookupByLibrary.simpleMessage("Sign up by email")
      };
}
