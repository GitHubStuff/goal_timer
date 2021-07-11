// Copyright 2021, LTMM LLC.
import 'package:xfer/xfer.dart';

const String _key = 'com.icodeforyou.goal_orderBy';

/// Manager for reading/setting the display order in on-device preferences
class OrderByPref {
  static Future<bool> get inOrder async {
    final result = await Xfer().get('pref://$_key', value: true);
    return result.fold((l) => false, (r) => r.body as bool);
  }

  static Future setAscending(bool flag) async {
    await Xfer().put('pref://$_key', value: flag);
  }
}
