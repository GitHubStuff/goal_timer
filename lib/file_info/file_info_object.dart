import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../constants.dart' as K;

const String BackPath = '..';

class FileInfoObject {
  final int? byteSize;
  final String path;
  late final String name;
  final String? clientModified;
  final String? serverModified;
  bool get isBackPath => name == BackPath;
  bool get isFile => (byteSize != null);
  bool get isDirectory => !isFile;
  String? get sizeString => isFile ? NumberFormat('###,###,###,###').format(byteSize) : null;

  Widget get icon {
    if (name == BackPath) return K.siteMap;
    if (isDirectory) return K.folder;
    return K.dataFile;
  }

  FileInfoObject({
    required this.path,
    required String name,
    this.byteSize,
    this.clientModified,
    this.serverModified,
  }) {
    if (byteSize == null) {
      this.name = (name == BackPath) ? name : '/$name';
    } else
      this.name = name;
  }

  factory FileInfoObject.dropbox(dynamic item) {
    final filesize = item['filesize'];
    final String path = item['pathLower'];
    var name = item['name'];
    final clientModified = item['clientModified'];
    final serverModified = item['serverModified'];
    return FileInfoObject(
      path: path,
      name: name,
      byteSize: filesize,
      clientModified: clientModified,
      serverModified: serverModified,
    );
  }

  String backPath() {
    String rebuiltPath = '';
    if (name != BackPath) return rebuiltPath;
    List<String> legs = path.split('/');
    for (int i = 1; i < legs.length - 1; i++) {
      rebuiltPath = '$rebuiltPath/${legs[i]}';
    }
    return rebuiltPath;
  }
}
