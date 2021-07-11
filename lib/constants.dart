import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart' as FA;

const bool logSql = true;
const String dbName = 'goal_timer.db';
const int maxTitleLength = 250;
const int maxTimeLength = 25;
const bool enableSqliteExplorer = true;

const TextStyle textStyle = TextStyle(fontSize: fontSize);
const TextStyle intervalStyle = TextStyle(fontSize: 24.0);
const TextStyle dateStyle = TextStyle(fontSize: 22.0);

const double fontSize = 30.0;
const double buttonWidth = 315.0;

const pad = const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0);
const dropboxIcon = const FA.FaIcon(FA.FontAwesomeIcons.dropbox);
const siteMap = const FA.FaIcon(FA.FontAwesomeIcons.sitemap);
const folder = const FA.FaIcon(FA.FontAwesomeIcons.folderOpen);
const dataFile = const FA.FaIcon(FA.FontAwesomeIcons.fileAlt);
const fileUpload = const FA.FaIcon(FA.FontAwesomeIcons.cloudUploadAlt);

enum PopoverButtons {
  theme,
  dropbox,
  upload,
}