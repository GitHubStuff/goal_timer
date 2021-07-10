part of 'dropbox_cubit.dart';

@immutable
abstract class DropboxState {}

class DropboxInitial extends DropboxState {}

class DropboxAuthorized extends DropboxState {
  final bool authorized;
  DropboxAuthorized(this.authorized);
}

class DropboxFileList extends DropboxState {
  final List<dynamic> fileList;
  DropboxFileList(this.fileList);
}
