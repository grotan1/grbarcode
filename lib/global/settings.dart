import 'dart:async';

import 'package:prefs/prefs.dart';

Future<Map<String, dynamic>> readPreferences() async {
  final all = <String, dynamic>{};

  all['serverAddress'] = await Prefs.getStringF('serverAddress');
  all['serverKey'] = await Prefs.getStringF('serverKey');

  return all;
}
