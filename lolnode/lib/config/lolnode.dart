/*

Copyright 2019 fuwa

This file is part of LOLnode.

LOLnode is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

LOLnode is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with LOLnode.  If not, see <https://www.gnu.org/licenses/>.

*/

import 'package:flutter/material.dart';

import 'prototype.dart';

// const crtGreen = Color.fromRGBO(0, 255, 102, 1);
const crtGreen = Color.fromRGBO(51, 255, 51, 1);

final _theme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: crtGreen,
  hintColor: Colors.yellow,
  accentColor: crtGreen,
  cursorColor: crtGreen,
  backgroundColor: Colors.black,
  scaffoldBackgroundColor: Colors.black,
  textTheme: TextTheme(
    headline4: TextStyle(
      fontFamily: 'RobotoMono',
      fontSize: 35,
      fontWeight: FontWeight.bold,
    ),
    headline3: TextStyle(
      fontFamily: 'RobotoMono',
      fontSize: 22,
    ),
    headline6: TextStyle(
      fontFamily: 'VT323',
      fontSize: 22,
    ),
    subtitle1: TextStyle(
      fontFamily: 'RobotoMono',
      fontSize: 17,
      fontWeight: FontWeight.bold,
    ),
    bodyText2: TextStyle(
      fontFamily: 'VT323',
      fontSize: 17,
      height: 1,
    ),
    bodyText1: TextStyle(
      fontFamily: 'RobotoMono',
      fontSize: 12.5,
    ),
  ).apply(
    bodyColor: crtGreen,
    displayColor: crtGreen,
  ),
);

final config = CryptoConfig(
  'liblolnerod.so',
  'lolnerod',
  'Is this a test, sir?',
  70,
  _theme,
  45679,
  [
    '--p2p-use-ipv6',
  ],
  '[1337@lol]: ',
  6,
);
