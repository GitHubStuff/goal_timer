import 'package:flutter/material.dart';
import 'package:theme_manager/theme_manager.dart';

import '../constants.dart' as K;

Widget popupMenuButton(BuildContext context, Function(int) onSelected) {
  return PopupMenuButton<int>(
    onSelected: (item) => (item == 0) ? SetThemeDialog.show(context: context) : onSelected(item),
    itemBuilder: (cntx) {
      return [
        _themeWidget(context),
        _dropboxWidget(context),
      ];
    },
  );
}

PopupMenuItem<int> _themeWidget(BuildContext context) {
  return PopupMenuItem<int>(
    value: 0,
    child: Row(
      children: [
        ThemeManager.themeModeIcon(context),
        SizedBox(width: 4),
        Text('Theme'),
      ],
    ),
  );
}

PopupMenuItem<int> _dropboxWidget(BuildContext context) {
  return PopupMenuItem<int>(
    value: 1,
    child: Row(
      children: [
        K.dropboxIcon,
        SizedBox(width: 4),
        Text('Dropbox'),
      ],
    ),
  );
}
