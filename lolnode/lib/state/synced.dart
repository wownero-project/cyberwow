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

import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';

import '../config.dart' as config;
import '../logic/sensor/daemon.dart' as daemon;
import '../logic/sensor/rpc/rpc.dart' as rpc;
import '../logic/sensor/rpc/rpc2.dart' as rpc;
import '../logic/view/rpc/rpc2.dart' as rpc2View;
import '../logic/view/rpc/rpc.dart' as rpcView;
import '../helper.dart';
import '../logging.dart';

import 'prototype.dart';
import 'resyncing.dart';

class SyncedState extends AppStateAutomata {
  final TextEditingController textController = TextEditingController();

  bool synced = true;
  bool userExit = false;
  bool connected = true;

  Map<String, dynamic> getInfo = {};
  List<Map<String, dynamic>> getConnections = [];
  List<Map<String, dynamic>> getTransactionPool = [];

  int height;
  int pageIndex;
  PageController? pageController;

  String getInfoCache = '';
  String getConnectionsCache = '';
  String getTransactionPoolCache = '';

  SyncedState(appHook, this.height, this.pageIndex) : super(appHook) {
    pageController = PageController(initialPage: pageIndex);
    // textController.addListener(this.appendInput);
  }

  void appendInput(final String x) {
    final _input = config.c.promptString + x;
    log.fine(_input);
    final _stdoutQueue = appHook.stdout;
    _stdoutQueue.addLast('\n' + _input);
    while (_stdoutQueue.length > config.logLines) {
      _stdoutQueue.removeFirst();
    }
    appHook.stdoutCache = _stdoutQueue.join();

    // ignore: close_sinks
    final IOSink? _stdin = appHook.process?.stdin;

    _stdin?.writeln(x);
    _stdin?.flush();

    syncState();

    if (x == 'exit') {
      userExit = true;
    }
  }

  void onPageChanged(int value) {
    this.pageIndex = value;
  }

  Future<AppStateAutomata> next() async {
    log.fine("Synced next");
    if (userExit) {
      return exitState();
    }
    if (await shouldExit()) {
      return exitState();
    }

    if (shouldSkip()) {
      log.finest('skipping state update');
      await tick();
      return this;
    }

    if (await daemon.isNotSynced()) {
      return ReSyncingState(appHook, pageIndex);
    }

    await tick();
    // log.finer('SyncedState: checkSync loop');
    height = await rpc.height();
    connected = await daemon.isConnected();
    getInfo = await rpc.getInfoSimple();
    final _getInfoView = cleanKey(rpcView.getInfoView(getInfo));
    getInfoCache = pretty(_getInfoView);

    getConnections = await rpc.getConnectionsSimple();
    final List<Map<String, dynamic>> _getConnectionsView = getConnections
        .map(rpcView.getConnectionView)
        .map((x) => rpcView.simpleHeight(height, x))
        .map(cleanKey)
        .toList();
    getConnectionsCache = pretty(_getConnectionsView);

    getTransactionPool = await rpc.getTransactionPoolSimple();
    final List<Map<String, dynamic>> _getTransactionPoolView =
        getTransactionPool.map(rpc2View.txView).map(cleanKey).toList();
    getTransactionPoolCache = pretty(_getTransactionPoolView);

    log.fine('synced: loop exit');

    return this;
  }
}
