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

import '../state.dart';

Widget buildLoading(BuildContext context, LoadingState state) {
  return Scaffold(
    // appBar: AppBar(
    //   // title: Text(widget.title),
    //   title: Text('WOW'),
    // ),
    body: new Container
    (
      padding: const EdgeInsets.all(10.0),
      color: Colors.black,
      child: Align
      (
        alignment: Alignment.topLeft,
        child: Column
        (
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>
          [
            new Expanded
            (
              flex: 1,
              child: new SingleChildScrollView
              (
                child: Text
                (
                  state.status,
                  style: TextStyle
                  (
                    fontFamily: 'RobotoMono',
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Colors.green.withOpacity(1.0),
                  ),
                )
              )
            )
          ],
        ),
      ),
    ),
  );
}
