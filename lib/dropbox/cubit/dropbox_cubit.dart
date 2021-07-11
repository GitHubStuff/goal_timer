import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:dropbox_client/dropbox_client.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:path_provider/path_provider.dart';
import 'package:xfer/xfer.dart';

part 'dropbox_state.dart';

const String _accessTokenKey = 'pref://com.icodeforyou.dropbox.access.token';
const String _dropbox_clientId = 'test-flutter-dropbox';
const String _dropbox_key = 'jdngwadvorh5zue';
const String _dropbox_secret = 'wx6iaz7tzrv9ene';

class DropboxCubit extends Cubit<DropboxState> {
  static bool _isInitialized = false;

  String? _accessToken;
  final _list = List<dynamic>.empty(growable: true);

  DropboxCubit() : super(DropboxInitial());

  void initDropbox() async {
    if (!_isInitialized) {
      _isInitialized = true;
      await Dropbox.init(_dropbox_clientId, _dropbox_key, _dropbox_secret);
      Either<XferFailure, XferResponse> result = await Xfer().get(_accessTokenKey, value: '');
      result.fold((l) => throw FlutterError('Read error ${l.toString()}'), (r) {
        _accessToken = r.body;
        emit(DropboxAuthorized(_accessToken!.isNotEmpty));
      });
    }
  }

  Future buildDropboxFileList({String path = ''}) async {
    _list.clear();
    if (await checkAuthorized(true)) {
      final result = await Dropbox.listFolder(path);
      _list.addAll(result);
      if (path.isNotEmpty) _list.insert(0, {'name': '..', 'pathLower': '${path.toLowerCase()}'});
      emit(DropboxFileList(_list));
    }
  }

  Future<bool> checkAuthorized(bool authorize) async {
    final token = await Dropbox.getAccessToken();
    if (token != null) {
      if (_accessToken == null || _accessToken!.isEmpty) {
        _accessToken = token;
        await Xfer().put(_accessTokenKey, value: _accessToken);
      }
      return true;
    }
    if (authorize) {
      if (_accessToken != null && _accessToken!.isNotEmpty) {
        await Dropbox.authorizeWithAccessToken(_accessToken!);
        final token = await Dropbox.getAccessToken();
        if (token != null) {
          return true;
        }
      } else {
        await Dropbox.authorize();
      }
    }
    return false;
  }

  void checkDropboxLink() async {
    _accessToken = await Dropbox.getAccessToken();
    await Xfer().put(_accessTokenKey, value: (_accessToken ?? ''));
    emit(DropboxAuthorized(_accessToken != null));
  }

  Future<String?> getTemporaryLink(path) async {
    final result = await Dropbox.getTemporaryLink(path);
    return result;
  }

  void unlinkFromDropbox() async {
    _accessToken = '';
    await Xfer().put(_accessTokenKey, value: _accessToken);
    final token = await Dropbox.getAccessToken();
    emit(DropboxAuthorized(false));
    if (token != null) await Dropbox.unlink();
  }

  void mockUpload() async {
    emit(DropboxUpload(uploaded: 0, total: 0));
  }

  void uploadFileWithProgress(
    String data, {
    required String fileName,
    DropboxProgressCallback? progress,
    DropboxProgressCallback? completed,
  }) async {
    assert(fileName.isNotEmpty, 'Cannot have empty file name');
    if (await checkAuthorized(true)) {
      int total = 0;
      int uploaded = 0;
      emit(DropboxUpload(uploaded: uploaded, total: total));
      if (progress != null) progress(uploaded, total);
      var tempDirectory = await getTemporaryDirectory();
      var filePath = '${tempDirectory.path}/$fileName';
      File(filePath).writeAsStringSync(data);
      final _ = await Dropbox.upload(filePath, '/$fileName', (up, tot) {
        uploaded = up;
        total = tot;
        emit(DropboxUpload(uploaded: uploaded, total: total));
        if (progress != null) progress(uploaded, total);
      });
      emit(DropboxUploadCompleted(uploaded: uploaded, total: total));
      if (completed != null) completed(uploaded, total);
    }
  }

  void uploadFile(String data, {required String fileName}) async {
    assert(fileName.isNotEmpty, 'Cannot have empty file name');
    if (await checkAuthorized(true)) {
      int total = 0;
      int uploaded = 0;
      emit(DropboxUpload(uploaded: uploaded, total: total));

      var tempDirectory = await getTemporaryDirectory();
      var filePath = '${tempDirectory.path}/$fileName';
      File(filePath).writeAsStringSync(data);
      final _ = await Dropbox.upload(filePath, '/$fileName', (up, tot) {
        uploaded = up;
        total = tot;
        emit(DropboxUpload(uploaded: uploaded, total: total));
      });
      emit(DropboxUploadCompleted(uploaded: uploaded, total: total));
    }
  }
}
