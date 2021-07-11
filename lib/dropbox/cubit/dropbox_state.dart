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

class DropboxUpload extends DropboxState {
  final int uploaded;
  final int total;
  DropboxUpload({required this.uploaded, required this.total});
}

class DropboxUploadCompleted extends DropboxState {
  final int uploaded;
  final int total;
  DropboxUploadCompleted({required this.uploaded, required this.total});
}
