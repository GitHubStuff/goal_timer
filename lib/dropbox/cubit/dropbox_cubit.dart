import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:dropbox_client/dropbox_client.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:xfer/xfer.dart';

part 'dropbox_state.dart';

const String _accessTokenKey = 'pref://com.icodeforyou.dropbox.access.token';
const String _dropbox_clientId = 'test-flutter-dropbox';
const String _dropbox_key = 'jdngwadvorh5zue';
const String _dropbox_secret = 'wx6iaz7tzrv9ene';

class DropboxCubit extends Cubit<DropboxState> {
  String? _accessToken;
  final _list = List<dynamic>.empty(growable: true);

  DropboxCubit() : super(DropboxInitial());

  void initDropbox() async {
    await Dropbox.init(_dropbox_clientId, _dropbox_key, _dropbox_secret);
    Either<XferFailure, XferResponse> result = await Xfer().get(_accessTokenKey, value: '');
    result.fold((l) => throw FlutterError('Read error ${l.toString()}'), (r) {
      _accessToken = r.body;
      debugPrint('AccessToken $_accessToken');
      emit(DropboxAuthorized(_accessToken!.isNotEmpty));
    });
  }

  void checkDropboxLink() async {
    _accessToken = await Dropbox.getAccessToken();
    await Xfer().put(_accessTokenKey, value: (_accessToken ?? ''));
    emit(DropboxAuthorized(_accessToken != null));
  }

  void unlinkFromDropbox() async {
    _accessToken = '';
    await Xfer().put(_accessTokenKey, value: _accessToken);
    final token = await Dropbox.getAccessToken();
    emit(DropboxAuthorized(false));
    if (token != null) await Dropbox.unlink();
  }

  Future buildDropboxFileList(String path) async {
    _list.clear();
    if (await checkAuthorized(true)) {
      final result = await Dropbox.listFolder(path);
      _list.addAll(result);
      if (path.isNotEmpty) _list.insert(0, {'name': '..', 'pathLower': '${path.toLowerCase()}'});
      emit(DropboxFileList(_list));
    }
  }

  Future<String?> getTemporaryLink(path) async {
    final result = await Dropbox.getTemporaryLink(path);
    return result;
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
          print('authorizeWithAccessToken!');
          return true;
        }
      } else {
        await Dropbox.authorize();
        print('authorize!');
      }
    }
    return false;
  }
}
