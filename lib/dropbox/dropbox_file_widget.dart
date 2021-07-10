import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_extras/flutter_extras.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:goal_timer/dropbox/cubit/dropbox_cubit.dart';
import 'package:intl/intl.dart';
import 'package:theme_manager/theme_manager.dart';

import '../constants.dart' as K;

class DropboxFileWidget extends StatefulWidget {
  _DropboxFileWidget createState() => _DropboxFileWidget();
}

//---
class _DropboxFileWidget extends ObservingStatefulWidget<DropboxFileWidget> {
  @override
  Widget build(BuildContext context) {
    return _scaffold();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    debugPrint('🤓 ${state.toString()}');
    if (state == AppLifecycleState.resumed) {
      final dropboxCubit = Modular.get<DropboxCubit>();
      dropboxCubit.checkDropboxLink();
    }
  }

  @override
  initState() {
    super.initState();
    Modular.get<DropboxCubit>()..initDropbox();
  }

  Widget _scaffold() {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dropbox Manager'),
        actions: [
          ThemeControlWidget(),
        ],
      ),
      body: _mainColumn(),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {},
      //   tooltip: 'Add Goal',
      //   child: Icon(Icons.add),
      // ),
    );
  }

  Widget _mainColumn() {
    return Column(
      children: [
        _useDropbox(),
        _fileList(),
      ],
    );
  }

  Widget _fileList() {
    final dropboxCubit = Modular.get<DropboxCubit>();
    return BlocBuilder<DropboxCubit, DropboxState>(
      bloc: dropboxCubit,
      builder: (cntx, state) {
        if (!(state is DropboxFileList)) return Text('..Waiting');
        final list = state.fileList;
        return Expanded(
          child: ListView.builder(
            itemCount: list.length,
            itemBuilder: (context, index) {
              final item = list[index];
              final filesize = item['filesize'];
              final String path = item['pathLower'];
              bool isFile = false;
              var name = item['name'];
              if (filesize == null) {
                if (name != '..') name = '/$name';
              } else {
                isFile = true;
              }
              return ListTile(
                  title: Text(name),
                  subtitle: (name == '..')
                      ? null
                      : Text((filesize == null)
                          ? 'Directory'
                          : NumberFormat(
                              '###,###,###,###',
                            ).format(filesize)),
                  onTap: () async {
                    if (isFile) {
                      final link = await dropboxCubit.getTemporaryLink(path);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(link ?? 'getTemporaryLink error: $path')));
                    } else {
                      if (name == '..') {
                        List<String> legs = path.split('/');
                        String rebuiltPath = '';
                        for (int i = 1; i < legs.length - 1; i++) {
                          rebuiltPath = '$rebuiltPath/${legs[i]}';
                        }
                        dropboxCubit.buildDropboxFileList(rebuiltPath);
                      } else
                        dropboxCubit.buildDropboxFileList(path);
                      //await listFolder(path);
                    }
                  });
            },
          ),
        );
      },
    );
  }

  Widget _useDropbox() {
    final dropboxCubit = Modular.get<DropboxCubit>();
    Widget widget = SpinnerWidget.text('');
    return BlocBuilder<DropboxCubit, DropboxState>(
      bloc: dropboxCubit,
      builder: (cntx, state) {
        if (state is DropboxAuthorized) {
          if (state.authorized) dropboxCubit.buildDropboxFileList('');
          widget = SlideSwitch(
            key: UniqueKey(),
            value: state.authorized,
            onChanged: (value) {
              value ? dropboxCubit.checkAuthorized(true) : dropboxCubit.unlinkFromDropbox();
            },
          );
        }

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              widget,
              SizedBox(width: 12.0),
              Text('Use Dropbox'),
              SizedBox(width: 12.0),
              K.dropboxIcon,
            ],
          ),
        );
      },
    );
  }
}
