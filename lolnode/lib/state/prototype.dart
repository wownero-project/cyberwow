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

import 'dart:collection';
import 'dart:io';

import '../config.dart' as config;

import 'exiting.dart';

typedef SetStateFunc = void Function(AppState);
typedef GetNotificationFunc = AppLifecycleState Function();
typedef IsExitingFunc = bool Function();
typedef GetInitialIntentFunc = Future<String> Function();

class AppHook {
  final SetStateFunc setState;
  final GetNotificationFunc getNotification;
  final IsExitingFunc isExiting;
  final GetInitialIntentFunc getInitialIntent;

  final Process? process;
  final Queue stdout;
  String stdoutCache;
  bool processCompleted;

  AppHook(
    this.setState,
    this.getNotification,
    this.isExiting,
    this.getInitialIntent,
    this.process,
    this.stdout, {
    this.stdoutCache = '',
    this.processCompleted = false,
  });
}

class AppState {
  final AppHook appHook;
  int skipped = 0;
  AppState(this.appHook);

  Future<bool> shouldExit() async {
    final _isExiting = appHook.isExiting();
    if (_isExiting) return true;

    if (appHook.process != null && appHook.processCompleted) {
      final _exitCode = await appHook.process?.exitCode;
      return _exitCode != 0;
    }

    return false;
  }

  ExitingState exitState() => ExitingState(appHook);

  bool isActive() {
    final _appState = appHook.getNotification();
    return _appState == AppLifecycleState.resumed;
  }

  bool shouldPop() => true;

  bool shouldSkip() {
    if (!isActive()) {
      if (skipped < config.forcedUpdateInSeconds) {
        skipped++;
        return true;
      } else {
        skipped = 0;
        return false;
      }
    } else {
      skipped = 0;
      return false;
    }
  }

  void syncState() {
    appHook.setState(this);
  }
}

abstract class AppStateAutomata extends AppState {
  AppStateAutomata(appHook) : super(appHook);
  Future<AppStateAutomata> next();
}
