import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_extras/flutter_extras.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:goal_timer/dropbox/cubit/dropbox_cubit.dart';
import 'package:goal_timer/file_info/file_info_object.dart';
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          String timeStamp = DateTime.now().asKey();
          String fileName = '$timeStamp.txt';
          String data = 'This was created $timeStamp for a test! $fileName';
          final dropboxCubit = Modular.get<DropboxCubit>();
          dropboxCubit.uploadFile(data, fileName: fileName);
        },
        tooltip: 'Upload file',
        child: K.fileUpload,
      ),
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
        if (state is DropboxUpload) {
          return Text('Upload: ${state.uploaded} of ${state.total}');
        }
        if (state is DropboxUploadCompleted) {
          dropboxCubit.buildDropboxFileList();
        }
        if (!(state is DropboxFileList)) return Text('..Waiting');
        final list = state.fileList;
        return Expanded(
          child: RefreshIndicator(
            onRefresh: () async {
              final dropboxCubit = Modular.get<DropboxCubit>();
              dropboxCubit.buildDropboxFileList();
            },
            child: ListView.builder(
              itemCount: list.length,
              itemBuilder: (context, index) {
                final dbf = FileInfoObject.dropbox(list[index]);
                return Card(
                  child: ListTile(
                      leading: dbf.icon,
                      title: Text(dbf.name),
                      subtitle: (dbf.isBackPath)
                          ? null
                          : Text(
                              (dbf.isDirectory) ? 'Directory' : dbf.sizeString! + " bytes",
                            ),
                      onTap: () async {
                        if (dbf.isFile) {
                          final link = await dropboxCubit.getTemporaryLink(dbf.path);
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(link ?? 'getTemporaryLink error: ${dbf.path}')));
                        } else {
                          if (dbf.isBackPath) {
                            String rebuiltPath = dbf.backPath();
                            dropboxCubit.buildDropboxFileList(path: rebuiltPath);
                          } else
                            dropboxCubit.buildDropboxFileList(path: dbf.path);
                          //await listFolder(path);
                        }
                      }),
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _useDropbox() {
    final dropboxCubit = Modular.get<DropboxCubit>();
    Widget widget = SpinnerWidget.text('Awaiting state');
    return BlocBuilder<DropboxCubit, DropboxState>(
      bloc: dropboxCubit,
      builder: (cntx, state) {
        if (state is DropboxAuthorized) {
          if (state.authorized) dropboxCubit.buildDropboxFileList();
          widget = SwitchListTile(
            key: UniqueKey(),
            title: Text('Use Dropbox'),
            value: state.authorized,
            secondary: K.dropboxIcon,
            onChanged: (value) {
              value ? dropboxCubit.checkAuthorized(true) : dropboxCubit.unlinkFromDropbox();
            },
          );
        }
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: widget,
        );
      },
    );
  }
}
