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

import 'dart:io';

import '../config.dart' as config;
import '../logging.dart';

import 'prototype.dart';

class ExitingState extends AppStateAutomata {
  ExitingState(appHook) : super(appHook);

  Future<void> wait() async {
    if (appHook.process != null) {
      log.fine('exiting state: killing process');
      appHook.process.kill();
      await appHook.process.exitCode.timeout(
        Duration(seconds: config.processKillWaitingInSeconds),
        onTimeout: () {
          log.warning('process exitCode timeout');
          appHook.process.kill(ProcessSignal.sigkill);
          return -1;
        },
      );
    }
    log.finer('exiting state done');
  }

  Future<AppStateAutomata> next() async {
    return null;
  }
}
