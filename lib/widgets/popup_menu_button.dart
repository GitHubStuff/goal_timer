import 'package:flutter/material.dart';
import 'package:theme_manager/theme_manager.dart';

import '../constants.dart' as K;

Widget popupMenuButton(BuildContext context, Function(K.PopoverButtons) onSelected) {
  return PopupMenuButton<K.PopoverButtons>(
    onSelected: (item) => (item == K.PopoverButtons.theme) ? SetThemeDialog.show(context: context) : onSelected(item),
    itemBuilder: (cntx) {
      return [
        _themeWidget(context),
        _dropboxWidget(context),
        _dropboxUpload(context),
      ];
    },
  );
}

PopupMenuItem<K.PopoverButtons> _dropboxWidget(BuildContext context) {
  return PopupMenuItem<K.PopoverButtons>(
    value: K.PopoverButtons.dropbox,
    child: Row(
      children: [
        K.dropboxIcon,
        SizedBox(width: 4),
        Text('Dropbox'),
      ],
    ),
  );
}

PopupMenuItem<K.PopoverButtons> _dropboxUpload(BuildContext context) {
  return PopupMenuItem<K.PopoverButtons>(
    value: K.PopoverButtons.upload,
    child: Row(
      children: [
        K.fileUpload,
        SizedBox(width: 4),
        Text('Upload'),
      ],
    ),
  );
}

PopupMenuItem<K.PopoverButtons> _themeWidget(BuildContext context) {
  return PopupMenuItem<K.PopoverButtons>(
    value: K.PopoverButtons.theme,
    child: Row(
      children: [
        ThemeManager.themeModeIcon(context),
        SizedBox(width: 4),
        Text('Theme'),
      ],
    ),
  );
}
