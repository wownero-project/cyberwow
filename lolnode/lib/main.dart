/*

Copyright 2019 fuwa

This file is part of CyberWOW.

CyberWOW is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

CyberWOW is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with CyberWOW.  If not, see <https://www.gnu.org/licenses/>.

*/

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';

import 'dart:io';
import 'dart:async';
import 'dart:collection';

import 'config.dart' as config;
import 'logging.dart';
import 'state.dart' as state;
import 'widget.dart' as widget;

void main() {
  Logger.root.level = kReleaseMode ? Level.INFO : Level.FINE;
  Logger.root.onRecord.listen((LogRecord rec) {
    print('${rec.level.name}: ${rec.time}: ${rec.message}');
  });
  runApp(LNodeApp());
}

class LNodeApp extends StatelessWidget {
  @override
  Widget build(final BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);

    return MaterialApp(
      title: 'L node',
      theme: config.c.theme,
      darkTheme: config.c.theme,
      home: LNodePage(),
    );
  }
}

class LNodePage extends StatefulWidget {
  LNodePage({Key? key}) : super(key: key);
  @override
  _LNodePageState createState() => _LNodePageState();
}

class _LNodePageState extends State<LNodePage> with WidgetsBindingObserver {
  // AppState _state = LoadingState("init...");
  static const _channel = const MethodChannel('send-intent');

  state.AppState? _state;
  AppLifecycleState _notification = AppLifecycleState.resumed;

  bool _exiting = false;

  final StreamController<String> _inputStreamController = StreamController();

  Future<String> getInitialIntent() async {
    final text = await _channel.invokeMethod('getInitialIntent');
    log.fine('getInitialIntent: $text');
    return text;
  }

  @override
  void didChangeAppLifecycleState(final AppLifecycleState state) {
    log.fine('app cycle: $state');
    setState(() {
      _notification = state;
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    _inputStreamController.close();
    super.dispose();
  }

  void _setState(final state.AppState newState) {
    setState(() => _state = newState);
  }

  AppLifecycleState _getNotification() {
    return _notification;
  }

  bool _isExiting() {
    return _exiting;
  }

  Future<void> buildStateMachine(final state.BlankState _blankState) async {
    _setState(_blankState);

    bool exited = false;
    bool validState = true;

    while (validState && !exited) {
      switch (_state.runtimeType) {
        case state.ExitingState:
          {
            await (_state as state.ExitingState).wait();
            log.finer('exit state wait done');
            exited = true;
          }
          break;

        case state.BlankState:
        case state.LoadingState:
        case state.SyncingState:
        case state.SyncedState:
        case state.ReSyncingState:
          _setState(await (_state as state.AppStateAutomata).next());
          break;
        default:
          validState = false;
      }
    }

    log.finer('state machine finished');

    if (exited) {
      log.finer('popping navigator');
      exit(0);
    } else {
      log.severe('Reached invalid state!');
      exit(1);
    }
  }

  @override
  void initState() {
    super.initState();
    log.fine("LNodePageState initState");

    WidgetsBinding.instance?.addObserver(this);

    final state.AppHook _appHook = state.AppHook(
      _setState,
      _getNotification,
      _isExiting,
      getInitialIntent,
      null,
      Queue(),
    );
    final state.BlankState _blankState = state.BlankState(_appHook);
    _state = _blankState;

    buildStateMachine(_blankState);
  }

  Future<bool> _exitApp(final BuildContext context) async {
    log.info("LNodePageState _exitApp");
    WidgetsBinding.instance?.removeObserver(this);

    _exiting = true;
    _inputStreamController.sink.add('exit');

    await Future.delayed(const Duration(seconds: 5));

    // the process controller should call exit(0) for us
    log.warning('Daemon took too long to shut down!');
    exit(1);
  }

  @override
  Widget build(final BuildContext context) {
    return WillPopScope(
      onWillPop: () => _exitApp(context),
      child: widget.build(context, _state!),
    );
  }
}
