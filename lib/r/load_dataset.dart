/// Call upon R to load a dataset.
///
/// Time-stamp: <Monday 2024-10-07 06:40:00 +1100 Graham Williams>
///
/// Copyright (C) 2023-2024, Togaware Pty Ltd.
///
/// Licensed under the GNU General Public License, Version 3 (the "License");
///
/// License: https://www.gnu.org/licenses/gpl-3.0.en.html
///
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
/// Authors: Graham Williams, Yixiang Yin

library;

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rattle/constants/app.dart';
import 'package:rattle/providers/path.dart';
import 'package:rattle/r/source.dart';
import 'package:rattle/utils/debug_text.dart';

/// Load the specified dataset using the appropriate R script.
///
/// The R script is expected to load the data into the template variable `ds`,
/// and define `dsname` as the dataset name and `vnames` as a named list of the
/// original variable names having as values the current variable names, being
/// different in the case where the dataset variables have been normalised,
/// which is the default.

Future<void> rLoadDataset(BuildContext context, WidgetRef ref) async {
  // On loading a dataset we run the main R script to set things up and then

//  if (context.mounted) await rSource(context, ref, ['session_setup']);

  // Get the path from the provider to identify either a filename or a R package
  // dataset.

  String path = ref.read(pathProvider);

  // TODO 20231018 gjw IF A DATASET HAS ALREADY BEEN LOADED AND NOT YET
  // PROCESSED (dataset_template.R) THEN PROCESS ELSE ASK IF WE CAN OVERWRITE IT
  // AND IF SO DO SO OTHERWISE DO NOTHING.

  debugText('R LOAD', path);

  // Ensure there is no extraneous white space.

  path = path.trim();

  // R Scripts.

  String ss = 'session_setup';
  String dw = 'dataset_load_weather';
  String dc = 'dataset_load_csv';
  String dx = 'dataset_load_txt';
  String dt = 'dataset_template';

  if (path == '' || path == weatherDemoFile) {
    // The default, when we get here and no path has been specified yet, is to
    // load the weather dataset as the demo dataset from R's rattle package.

    if (context.mounted) await rSource(context, ref, [ss, dw, dt]);
  } else if (path.endsWith('.csv')) {
    if (context.mounted) await rSource(context, ref, [ss, dc, dt]);
  } else if (path.endsWith('.txt')) {
    if (context.mounted) await rSource(context, ref, [ss, dx]);
  } else {
    debugPrint('LOAD_DATASET: PATH NOT RECOGNISED -> ABORT: $path.');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('PATH NOT RECOGNISED'),
        content: const Text('Unable to load dataset'),
        actions: <Widget>[
          ElevatedButton(
            child: const Text('OK'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );

    return;
  }

  debugText('R LOADED', path);

  // 20240615 gjw Move this `names(ds)` command into `dataset_prep` otherwise on
  // moving to the asset load with async it actually gets executed before the
  // `dataset_prep` and thus results in vars not being found at this time and
  // target becomes `found` as in `ds not found`.
  //
  // 20240814 gjw the asyn asset load is no longer required as the R scripts are
  // loaded on startup so we should be able to do rExecute and get the result
  // from rExtract now.

  // rExecute(ref, 'names(ds)');

  // this shows the data 20240916 gjw This is redundent as it is done in
  // dataset_prep or dataset_template.

  // if (context.mounted) await rSource(context, ref, ['dataset_glimpse']);

  return;
}
