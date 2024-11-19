/// EVALUATE Tab
//
// Time-stamp: <Friday 2024-11-15 09:59:33 +1100 Graham Williams>
//
/// Copyright (C) 2024, Togaware Pty Ltd
///
/// Licensed under the GNU General Public License, Version 3 (the "License");
///
/// License: https://www.gnu.org/licenses/gpl-3.0.en.html
//
// This program is free software: you can redistribute it and/or modify it under
// the terms of the GNU General Public License as published by the Free Software
// Foundation, either version 3 of the License, or (at your option) any later
// version.
//
// This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
// details.
//
// You should have received a copy of the GNU General Public License along with
// this program.  If not, see <https://www.gnu.org/licenses/>.
///
/// Authors: Zheyuan Xu

library;

import 'package:flutter/material.dart';

import 'package:rattle/constants/spacing.dart';
import 'package:rattle/features/evaluate/config.dart';
import 'package:rattle/features/evaluate/display.dart';

class EvaluatePanel extends StatelessWidget {
  const EvaluatePanel({super.key});

  @override
  Widget build(BuildContext context) {
    // A per the RattleNG pattern, a Tab consists of a Config bar and the
    // results Display().

    return const Scaffold(
      body: Column(
        children: [
          EvaluateConfig(),

          // Add a little space blow the config widgets so that things like any
          // underline is not lost not buttons,looking chopped off. We include
          // this here rather than within config to avoid an extra Column
          // widget().  Logically we add the spacer here as part of the tab.

          panelGap,

          // We add the Display() which may be a text view that takes up the
          // remaining space to introduce this particular tab's functionality
          // which is then replaced with the output of the build.

          Expanded(child: EvaluateDisplay()),
        ],
      ),
    );
  }
}