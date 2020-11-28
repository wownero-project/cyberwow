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

import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart';

import 'dart:io';
import 'dart:async';
import 'dart:convert';

import '../../../config.dart' as config;
import '../../../logging.dart';
import '../../sensor/helper.dart' as helper;

typedef ShouldExit = bool Function();

Future<Process> runBinary(
  final String name, {
  final List<String> userArgs = const [],
}) async {
  final binPath = await helper.getBinaryPath(name);

  final appDocDir = await getApplicationDocumentsDirectory();
  final binDir = Directory(appDocDir.path + "/" + config.c.appPath);

  await binDir.create();

  // print('binDir: ' + binDir.path);
  const List<String> debugArgs = [];
  const List<String> releaseArgs = [];

  const extraArgs = kReleaseMode ? releaseArgs : debugArgs;

  final args = [
        "--data-dir",
        binDir.path,
      ] +
      extraArgs +
      config.c.extraArgs +
      userArgs;

  log.info('args: ' + args.toString());

  return Process.start(binPath, args);
}
