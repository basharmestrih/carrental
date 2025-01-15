// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a fr locale. All the
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
  String get localeName => 'fr';

  static String m0(error) => "Échec de la connexion Google : ${error}";

  static String m1(error) => "Échec de la connexion : ${error}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "bestPlaceToRide": MessageLookupByLibrary.simpleMessage(
            "Votre meilleur endroit pour rouler n\'importe où"),
        "continueWith":
            MessageLookupByLibrary.simpleMessage("Ou continuer avec:"),
        "email": MessageLookupByLibrary.simpleMessage("E-mail"),
        "facebookLogin":
            MessageLookupByLibrary.simpleMessage("Connexion Facebook"),
        "forgotPassword":
            MessageLookupByLibrary.simpleMessage("Mot de passe oublié"),
        "googleLoginFailure": m0,
        "googleLoginSuccess":
            MessageLookupByLibrary.simpleMessage("Connexion Google réussie"),
        "greeting": MessageLookupByLibrary.simpleMessage(
            "Bienvenue sur l’application de location de voiture"),
        "loginFailed": m1,
        "loginSuccess":
            MessageLookupByLibrary.simpleMessage("Connexion réussie"),
        "loginbutton": MessageLookupByLibrary.simpleMessage("Connexion"),
        "password": MessageLookupByLibrary.simpleMessage("Mot de passe"),
        "signUpEmail":
            MessageLookupByLibrary.simpleMessage("Inscription par e-mail")
      };
}
