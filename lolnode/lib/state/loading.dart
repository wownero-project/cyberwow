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

import 'package:shared_preferences/shared_preferences.dart';
import 'package:async/async.dart';

import 'dart:async';
import 'dart:core';
import 'dart:convert';
import 'dart:collection';

import '../config.dart' as config;
import '../helper.dart';
import '../logic/controller/process/run.dart' as process;
import '../logging.dart';

import 'prototype.dart';
import 'syncing.dart';

class LoadingState extends AppStateAutomata {
  String status = '';

  LoadingState(appHook) : super(appHook);

  void append(final String msg) {
    this.status += msg;
    syncState();
  }

  Future<SyncingState> next() async {
    Future<void> showBanner() async {
      final Iterable<String> chars =
          config.c.splash.runes.map((x) => String.fromCharCode(x));

      for (final String char in chars) {
        append(char);
        final int _delay = config.c.splashDelay;
        await Future.delayed(Duration(milliseconds: _delay));
      }

      await tick();
      await tick();
    }

    SharedPreferences _prefs = await SharedPreferences.getInstance();
    final _bannerShown = _prefs.getBool(config.bannerShownKey);

    if (_bannerShown == null) {
      await showBanner();
      await _prefs.setBool(config.bannerShownKey, true);
    }

    final _initialIntent = await appHook.getInitialIntent();
    final _userArgs = _initialIntent
        .trim()
        .split(RegExp(r"\s+"))
        .where((x) => x.isNotEmpty)
        .toList();

    if (_userArgs.isNotEmpty) {
      log.info('user args: $_userArgs');
    }

    final _process = await process.runBinary(
      config.c.outputBin,
      userArgs: _userArgs,
    );

    log.fine('process created');

    final _stdout = StreamGroup.merge([_process.stdout, _process.stderr]
            .map((x) => x.transform(utf8.decoder).transform(LineSplitter())))
        .asBroadcastStream();

    final _stdoutQueue = Queue();

    AppHook _appHook = AppHook(
      appHook.setState,
      appHook.getNotification,
      appHook.isExiting,
      appHook.getInitialIntent,
      _process,
      _stdoutQueue,
    );

    _stdout.listen((x) {
      log.fine(x);
      _stdoutQueue.addLast(x);
      while (_stdoutQueue.length > config.logLines) {
        _stdoutQueue.removeFirst();
      }
      _appHook.stdoutCache = _stdoutQueue.join('\n');
    });

    _process.exitCode.whenComplete(() => _appHook.processCompleted = true);

    return SyncingState(_appHook);
  }
}
