import 'package:dropbox_client/dropbox_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_extras/flutter_extras.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:theme_manager/theme_manager.dart';

import '../goal_display/goal_module.dart';

const String _dropbox_clientId = 'test-flutter-dropbox';
const String _dropbox_key = 'jdngwadvorh5zue';
const String _dropbox_secret = 'jdngwadvorh5zue';

class ScaffoldWidget extends StatefulWidget {
  ScaffoldWidget({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _ScaffoldWidget createState() => _ScaffoldWidget();
}

class _ScaffoldWidget extends ObservingStatefulWidget<ScaffoldWidget> {
  @override
  initState() {
    super.initState();
    _initDropbox();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          ThemeControlWidget(),
        ],
      ),
      body: _body(context),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Modular.to.pushNamed(GoalModule.route);
          //Modular.to.pushNamed(EventEditor.route, arguments: 1);
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _body(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text('${AppLocalizations.of(context)!.helloWorld} ${DateTime.now()}'), //Example of localization
        ],
      ),
    );
  }

  Future _initDropbox() async {
    bool flag = await Dropbox.init(_dropbox_clientId, _dropbox_key, _dropbox_secret);
    debugPrint('FLAG $flag');
  }
}
