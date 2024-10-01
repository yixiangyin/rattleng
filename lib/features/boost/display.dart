/// Widget to display the BOOST introduction or output.
///
/// Copyright (C) 2024, Togaware Pty Ltd.
///
/// License: GNU General Public License, Version 3 (the "License")
/// https://www.gnu.org/licenses/gpl-3.0.en.html
//
// Time-stamp: <Tuesday 2024-10-01 09:06:06 +1000 Graham Williams>
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
//
// Note: The "Dataset" button is not present in this file. It might be located
// in another file responsible for the app's navigation or main layout.
///
/// Authors: Graham Williams

library;

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rattle/constants/markdown.dart';
import 'package:rattle/constants/temp_dir.dart';
import 'package:rattle/providers/stdout.dart';
import 'package:rattle/r/extract.dart';
import 'package:rattle/utils/image_exists.dart';
import 'package:rattle/widgets/image_page.dart';
import 'package:rattle/widgets/pages.dart';
import 'package:rattle/widgets/show_markdown_file.dart';
import 'package:rattle/widgets/text_page.dart';

/// The panel displays the instructions or the output.

class BoostDisplay extends ConsumerStatefulWidget {
  const BoostDisplay({super.key});

  @override
  ConsumerState<BoostDisplay> createState() => _BoostDisplayState();
}

class _BoostDisplayState extends ConsumerState<BoostDisplay> {
  @override
  Widget build(BuildContext context) {
    String stdout = ref.watch(stdoutProvider);

    List<Widget> pages = [showMarkdownFile(boostIntroFile, context)];

    String content =
        rExtract(stdout, 'print(importance_dt, row.names = FALSE)');

    if (content.isNotEmpty) {
      pages.add(
        TextPage(
          title: '''

          # XGBoost - Summary

          Visit the 
          [Guide](https://xgboost.readthedocs.io/en/stable/R-package/xgboostPresentation.html). Built
          using
          [xgb::xgb.train()](https://www.rdocumentation.org/packages/xgboost/topics/xgb.train).

            ''',
          content: '\n$content',
        ),
      );
    }

    String image = '$tempDir/model_xgb_importance.svg';

    if (imageExists(image)) {
      pages.add(
        ImagePage(
          title: '''

          # Variable Importance

          Generated using
          [xgb::xgb.importance()](https://www.rdocumentation.org/packages/xgboost/topics/xgb.importance).
          
          ''',
          path: image,
        ),
      );
    }

    return Pages(
      children: pages,
    );
  }
}
