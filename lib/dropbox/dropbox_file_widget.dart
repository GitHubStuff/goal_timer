import 'package:dartz/dartz.dart';
import 'package:dropbox_client/dropbox_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_extras/flutter_extras.dart';
import 'package:xfer/xfer.dart';

import '../constants.dart' as K;

const String _dropbox_clientId = 'test-flutter-dropbox';
const String _dropbox_key = 'jdngwadvorh5zue';
const String _dropbox_secret = 'wx6iaz7tzrv9ene';
const String _accessTokenKey = 'pref://com.icodeforyou.dropbox.access.token';

class DropboxFileWidget extends StatefulWidget {
  _DropboxFileWidget createState() => _DropboxFileWidget();
}

//---
class _DropboxFileWidget extends ObservingStatefulWidget<DropboxFileWidget> {
  String? _accessToken;

  @override
  initState() {
    super.initState();
    _initDropbox();
  }

  @override
  Widget build(BuildContext context) {
    return _useDropbox();
  }

  Widget _useDropbox() {
    return Row(
      children: [
        SlideSwitch(
          value: false,
          onChanged: (value) {
            if (value) {
              _checkAuthorized(true);
            }
          },
        ),
        Text('Use Dropbox'),
        K.dropboxIcon,
      ],
    );
  }

  Future _initDropbox() async {
    bool flag = await Dropbox.init(_dropbox_clientId, _dropbox_key, _dropbox_secret);
    debugPrint('FLAG $flag');
    Either<XferFailure, XferResponse> result = await Xfer().get(_accessTokenKey, value: '');
    result.fold((l) => throw FlutterError('Read error ${l.toString()}'), (r) {
      _accessToken = r.body;
      debugPrint('AccessToken $_accessToken');
    });
  }

  Future<bool> _checkAuthorized(bool authorize) async {
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
