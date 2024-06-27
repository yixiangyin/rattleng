/// Widget to display the Tree introduction or built tree.
///
/// Copyright (C) 2023-2024, Togaware Pty Ltd.
///
/// License: GNU General Public License, Version 3 (the "License")
/// https://www.gnu.org/licenses/gpl-3.0.en.html
//
// Time-stamp: <Tuesday 2024-06-18 17:22:57 +1000 Graham Williams>
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
/// Authors: Graham Williams

library;

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rattle/constants/app.dart';
import 'package:rattle/constants/markdown.dart';
import 'package:rattle/constants/sunken_box_decoration.dart';
import 'package:rattle/providers/stdout.dart';
import 'package:rattle/r/extract_tree.dart';
import 'package:rattle/widgets/show_markdown_file.dart';

import '../../widgets/pages.dart';

/// The tree panel displays the tree instructions or the tree biuld output.

class TreeDisplay extends ConsumerStatefulWidget {
  const TreeDisplay({super.key});

  @override
  ConsumerState<TreeDisplay> createState() => TreeDisplayState();
}

class TreeDisplayState extends ConsumerState<TreeDisplay> {
  // number of pages available
  // calculate from the pages number
  // int numPages = 2;


  @override
  Widget build(BuildContext context) {
    String stdout = ref.watch(stdoutProvider);
    String content = rExtractTree(stdout);

    return Pages(
            children: [
    showMarkdownFile(treeIntroFile, context),
    Container(
      decoration: sunkenBoxDecoration,
      width: double.infinity,
      padding: const EdgeInsets.only(left: 10),
      child: content.isEmpty
          ? const Center(
              child: Text(
                'Click the build button to see the result',
              ),
            )
          : SingleChildScrollView(
              child: SelectableText(
                content,
                style: monoTextStyle,
              ),
            ),
    ),
            ],
          );
  }
}
