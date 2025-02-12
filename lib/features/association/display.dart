/// Widget to display the ASSOCIATION introduction or output.
///
/// Copyright (C) 2024, Togaware Pty Ltd.
///
/// License: GNU General Public License, Version 3 (the "License")
/// https://www.gnu.org/licenses/gpl-3.0.en.html
//
// Time-stamp: <Saturday 2024-12-28 17:07:56 +1100 Graham Williams>
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
/// Authors: Graham Williams, Zheyuan Xu

library;

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rattle/constants/markdown.dart';
import 'package:rattle/constants/temp_dir.dart';
import 'package:rattle/providers/association.dart';
import 'package:rattle/providers/page_controller.dart';
import 'package:rattle/providers/stdout.dart';
import 'package:rattle/r/extract.dart';
import 'package:rattle/r/extract_association.dart';
import 'package:rattle/utils/image_exists.dart';
import 'package:rattle/utils/show_markdown_file_image.dart';
import 'package:rattle/widgets/page_viewer.dart';
import 'package:rattle/widgets/image_page.dart';
import 'package:rattle/widgets/text_page.dart';

/// The Association panel displays the associate instructions and then output
/// for the bult model.

class AssociationDisplay extends ConsumerStatefulWidget {
  const AssociationDisplay({super.key});

  @override
  ConsumerState<AssociationDisplay> createState() => _AssociationDisplayState();
}

class _AssociationDisplayState extends ConsumerState<AssociationDisplay> {
  @override
  Widget build(BuildContext context) {
    // Get the PageController from Riverpod.

    final pageController = ref.watch(
      associationControllerProvider,
    );

    String stdout = ref.watch(stdoutProvider);

    bool associationBaskets = ref.read(basketsAssociationProvider);

    // Begin the list of pages to display with the introduction markdown text.

    List<Widget> pages = [
      showMarkdownFile(
        context,
        associationIntroFile,
        'assets/svg/associations.svg',
      ),
    ];

    String content = '';

    ////////////////////////////////////////////////////////////////////////

    // Default arules summary output

    content = rExtractAssociation(stdout, true);

    if (content.isNotEmpty) {
      pages.add(
        TextPage(
          title: '''

          # Association Rules - Meta Summary

          Built using [arules::apriori()](https://www.rdocumentation.org/packages/arules/topics/apriori).

          ''',
          content: '\n$content',
        ),
      );
    }

    ////////////////////////////////////////////////////////////////////////

    // Show the actual rules.

    content = rExtract(stdout, 'inspect(top_rules)');

    if (content.isNotEmpty) {
      pages.add(
        TextPage(
          title: '''

          # Association Rules - Discovered Rules

          Built using [arules::inspect()](https://www.rdocumentation.org/packages/arules/topics/inspect).

          ''',
          content: '\n$content',
        ),
      );
    }

    ////////////////////////////////////////////////////////////////////////

    // TODO 20241211 gjw WHAT IS THIS - NOT WORKING?

    content = rExtractAssociation(stdout, false);

    if (content.isNotEmpty && !associationBaskets) {
      pages.add(
        TextPage(
          title: '''

          # Interestingness Measures

          Built using `apriori()`

          ''',
          content: '\n$content',
        ),
      );
    }

    ////////////////////////////////////////////////////////////////////////

    // 20241212 gjw This SVG does not load into Flutter. Yet it can be displayed
    // on Ubuntu. It is probably a PNG encapsulated within an SVG? It uses the
    // filter element that is not supported by
    // flutter_svg. https://github.com/dnfield/flutter_svg/issues/53

    // String image = '$tempDir/model_arules_viz.svg';
    String image = '$tempDir/model_arules_viz.png';

    if (imageExists(image)) {
      pages.add(
        ImagePage(
          title: '''

          # Association Rules  &#8212; Graph of Associations

          Visit $image.

          ''',
          path: image,
        ),
      );
    }

    ////////////////////////////////////////////////////////////////////////

    // 20241212 gjw This SVG does load into Flutter and does not utilise the
    // filter element.

    image = '$tempDir/model_arules_para.svg';

    if (imageExists(image)) {
      pages.add(
        ImagePage(
          title: '''

          # Association Rules  &#8212; Parrallel Coordinates Plot

          Visit $image.

          ''',
          path: image,
        ),
      );
    }

    ////////////////////////////////////////////////////////////////////////

    image = '$tempDir/model_arules_item_frequency.svg';

    if (imageExists(image)) {
      pages.add(
        ImagePage(
          title: '''

          # Association Rules  &#8212; Item Frequency

          ''',
          path: image,
        ),
      );
    }

    ////////////////////////////////////////////////////////////////////////

    return PageViewer(
      pageController: pageController,
      pages: pages,
    );
  }
}
