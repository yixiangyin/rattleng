/// Model tree test with demo dataset.
//
// Time-stamp: <Tuesday 2024-10-15 19:22:48 +1100 Graham Williams>
//
/// Copyright (C) 2023-2024, Togaware Pty Ltd
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
/// Authors: Zheyuan Xu, Graham Williams

library;

// Group imports by dart, flutter, packages, local. Then alphabetically.

import 'package:flutter/material.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:rattle/features/tree/panel.dart';
import 'package:rattle/main.dart' as app;
import 'package:rattle/widgets/image_page.dart';
import 'package:rattle/widgets/text_page.dart';

import 'utils/delays.dart';
import 'utils/goto_next_page.dart';
import 'utils/navigate_to_feature.dart';
import 'utils/navigate_to_tab.dart';
import 'utils/load_demo_dataset.dart';
import 'utils/tap_button.dart';
import 'utils/tap_checkbox.dart';
import 'utils/enter_text.dart';
import 'utils/verify_page.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Model Demo Tree:', () {
    // Tested , works well Kevin Wang

    // testWidgets('rpart.', (WidgetTester tester) async {
    //   app.main();
    //   await tester.pumpAndSettle();

    //   await tester.pump(interact);

    //   await loadDemoDataset(tester);

    //   // await tester.pump(hack);

    //   await navigateToTab(tester, 'Model');

    //   await navigateToFeature(tester, 'Tree', TreePanel);

    //   await verifyMarkdown(tester);

    //   // Simulate the presence of a decision tree being built.

    //   await tapButtonByKey(tester, 'Build Decision Tree');

    //   // await tester.pump(hack);

    //   await gotoNextPage(tester);

    //   // Try tapping again as it may not have gone to the second page.

    //   // await tester.pump(hack);

    //   await verifyPage('Decision Tree Model');

    //   // App may raise bugs in loading textPage. Thus, test does not target
    //   // at content.

    //   await verifyExist(TextPage);

    //   await tester.pump(interact);

    //   // Tap the right arrow to go to the third page.

    //   await gotoNextPage(tester);
    //   await gotoNextPage(tester);

    //   await verifyPage('Decision Tree as Rules');

    //   // App may raise bugs in loading textPage. Thus, test does not target
    //   // at content.

    //   await verifyExist(TextPage);

    //   await tester.pump(interact);
    // });

    testWidgets('rpart with different parameter settings.', (
      WidgetTester tester,
    ) async {
      app.main();

      await tester.pumpAndSettle();

      await tester.pump(interact);

      await loadDemoDataset(tester);

      await tester.pump(hack);

      await navigateToTab(tester, 'Model');

      await navigateToFeature(tester, 'Tree', TreePanel);

      await tapCheckbox(tester, 'include_missing');

      // Enter values into text fields

      await enterText(tester, 'minSplitField', '21');
      await enterText(tester, 'maxDepthField', '29');
      await enterText(tester, 'minBucketField', '9');
      await enterText(tester, 'complexityField', '0.0110');
      await enterText(tester, 'priorsField', '0.5,0.5');
      await enterText(tester, 'lossMatrixField', '0,10,1,0');

      await tapButtonByKey(tester, 'Build Decision Tree');

      await tester.pump(delay);
      await gotoNextPage(tester);

      await verifyPage('Decision Tree Model');

      await verifyExist(TextPage);

      await gotoNextPage(tester);

      await verifyImage(tester);

      await gotoNextPage(tester);

      await verifyPage('Decision Tree as Rules');
    });

    // testWidgets('ctree.', (WidgetTester tester) async {
    //   app.main();

    //   await tester.pumpAndSettle();

    //   await tester.pump(interact);

    //   await loadDemoDataset(tester);

    //   // 20240822 TODO gjw NEEDS A WAIT FOR THE R CODE TO FINISH!!!
    //   //
    //   // How do we ensure the R Code is executed before proceeding in Rattle
    //   // itself - we need to deal with the async issue in Rattle.

    //   await tester.pump(hack);

    //   // Tap the model Tab button.

    //   await navigateToTab(tester, 'Model');

    //   // Navigate to the Tree feature.

    //   await navigateToFeature(tester, 'Tree', TreePanel);

    //   // Find the ChoiceChipTip widget for the traditional algorithm type.

    //   final traditionalChip = find.text(
    //     'Traditional',
    //   );
    //   final conditionalChip = find.text('Conditional');

    //   // Verify that both chips exist in the widget tree.

    //   expect(traditionalChip, findsOneWidget);
    //   expect(conditionalChip, findsOneWidget);

    //   // Tap the conditional chip to switch algorithms.

    //   await tester.tap(conditionalChip);

    //   await tester.pumpAndSettle();

    //   // Now switch back to the traditional algorithm.

    //   await tester.tap(traditionalChip);

    //   // Wait for the widget to rebuild and settle.

    //   await tester.pumpAndSettle();

    //   // Tap the conditional chip to switch algorithms.

    //   await tester.tap(conditionalChip);

    //   await tester.pumpAndSettle();
    //   await tester.pump(interact);

    //   // Simulate the presence of a decision tree being built.

    //   final decisionTreeButton = find.byKey(const Key('Build Decision Tree'));

    //   await tester.tap(decisionTreeButton);

    //   await tester.pumpAndSettle();

    //   await tester.pump(hack);

    //   // Tap the right arrow to go to the second page.

    //   final rightArrowButton = find.byIcon(Icons.arrow_right_rounded);
    //   expect(rightArrowButton, findsOneWidget);
    //   // await tester.tap(rightArrowButton);
    //   await tester.pumpAndSettle();

    //   // 20241001 kev: The underlying code is failing on a manual test on kev's macos build. The test is commented out.

    //   final secondPageTitleFinder = find.text('Decision Tree Model');
    //   expect(secondPageTitleFinder, findsOneWidget);

    //   await tester.pump(interact);

    //   // Tap the right arrow to go to the third page.

    //   await tester.tap(rightArrowButton);
    //   await tester.pumpAndSettle();

    //   final thirdPageTitleFinder = find.text('Tree');
    //   expect(thirdPageTitleFinder, findsOneWidget);

    //   final imageFinder = find.byType(ImagePage);

    //   // Assert that the image is present.
    //   expect(imageFinder, findsOneWidget);

    //   await tester.pump(interact);
    // }

    // );
  });
}
