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

import 'config/prototype.dart';
import 'config/lolnode.dart' as cryptoConfig;

final c = cryptoConfig.config;

enum Arch { arm64, x86_64 }

const arch = Arch.arm64;
// const arch = 'x86_64';
const minimumHeight = 60;

const isEmu = identical(arch, Arch.x86_64);
const emuHost = '192.168.10.100';

const host = isEmu ? emuHost : '127.0.0.1';

const stdoutLineBufferSize = 200;
const bannerShownKey = 'banner-shown';

const int maxPoolTxSize = 5000;

