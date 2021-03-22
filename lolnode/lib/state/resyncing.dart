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

import '../logic/sensor/rpc/rpc.dart' as rpc;
import '../logic/sensor/daemon.dart' as daemon;
import '../logging.dart';
import '../helper.dart';

import 'prototype.dart';
import 'synced.dart';

class ReSyncingState extends AppStateAutomata {
  final int pageIndex;
  bool synced = false;

  ReSyncingState(appHook, this.pageIndex) : super(appHook);

  Future<AppStateAutomata> next() async {
    log.fine("ReSyncing next");
    if (await shouldExit()) return exitState();

    if (shouldSkip()) {
      log.finest('skipping state update');
      await tick();
      return this;
    }

    if (await daemon.isSynced()) {
      final int _height = await rpc.height();
      return SyncedState(appHook, _height, pageIndex);
    } else {
      await tick();
      return this;
    }
  }
}
