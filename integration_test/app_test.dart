// / Testing: Basic app startup test.
// /
// / Copyright (C) 2023, Software Innovation Institute, ANU.
// /
// / License: http://www.apache.org/licenses/LICENSE-2.0
// /
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.

// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
// /
// / Authors: Graham Williams

// TODO 20231015 gjw MIGRATE ALL TESTS TO THE ONE APP INSTANCE RATHER THAN A
// COSTLY BUILD EACH INDIVIDUAL TEST!

import 'dart:io';

import 'package:flutter/material.dart';

import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:integration_test/integration_test.dart';

import 'package:rattle/constants/keys.dart';
import 'package:rattle/features/summary/panel.dart';
import 'package:rattle/main.dart' as app;
import 'package:rattle/features/dataset/button.dart';
import 'package:rattle/features/dataset/popup.dart';
import 'package:rattle/tabs/explore.dart';

/// A duration to allow the tester to view/interact with the testing. 5s is
/// good, 10s is useful for development and 0s for ongoing. This is not
/// necessary but it is handy when running interactively for the user running
/// the test to see the widgets for added assurance. The PAUSE environment
/// variable can be used to override the default PAUSE here:
///
/// flutter test --device-id linux --dart-define=PAUSE=0 integration_test/app_test.dart
///
/// 20230712 gjw

const String envPAUSE = String.fromEnvironment('PAUSE', defaultValue: '0');
final Duration pause = Duration(seconds: int.parse(envPAUSE));
const Duration delay = Duration(seconds: 1);

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Home page loads okay.', (WidgetTester tester) async {
    debugPrint('TESTER: Start up the app');

    app.main();

    // Trigger a frame. Finish animation and scheduled microtasks.

    await tester.pumpAndSettle();

    // Leave time to see the first page.

    await tester.pump(pause);

    final datasetButtonFinder = find.byType(DatasetButton);
    expect(datasetButtonFinder, findsOneWidget);
    await tester.pump(pause);

    debugPrint('TESTER: Confirm welcome message on home screen.');

    final welcomeMarkdownFinder = find.byType(Markdown);
    expect(welcomeMarkdownFinder, findsNWidgets(2));

    final welcomeWidget =
        welcomeMarkdownFinder.evaluate().first.widget as Markdown;
    String welcome = welcomeWidget.data;
    expect(welcome, File('assets/markdown/welcome.md').readAsStringSync());

    debugPrint('Check the status bar has the expected contents.');

    final statusBarFinder = find.byKey(statusBarKey);
    expect(statusBarFinder, findsOneWidget);

    ////////////////////////////////////////////////////////////////////////
    // DATASET DEMO (By Kevin)
    ////////////////////////////////////////////////////////////////////////

    debugPrint('TESTER: Tap the Dataset button.');

    final datasetButton = find.byType(DatasetButton);
    expect(datasetButton, findsOneWidget);
    await tester.pump(pause);
    await tester.tap(datasetButton);
    await tester.pumpAndSettle();

    await tester.pump(delay);

    debugPrint('TESTER: Tap the Demo button.');

    final datasetPopup = find.byType(DatasetPopup);
    expect(datasetPopup, findsOneWidget);
    final demoButton = find.text('Demo');
    expect(demoButton, findsOneWidget);
    await tester.tap(demoButton);
    await tester.pumpAndSettle();
    await tester.pump(pause);

    debugPrint('TESTER: Expect the default demo dataset is identified.');

    final dsPathTextFinder = find.byKey(datasetPathKey);
    expect(dsPathTextFinder, findsOneWidget);
    final dsPathText = dsPathTextFinder.evaluate().first.widget as TextField;
    String filename = dsPathText.controller?.text ?? '';
    expect(filename, 'rattle::weather');

    debugPrint('TESTER: Expect the default demo dataset is loaded.');

    // Find the Explore tab by icon and tap on it.

    final exploreIconFinder = find.byIcon(Icons.insights);
    expect(exploreIconFinder, findsOneWidget);

    // Tap the Explore tab.

    await tester.tap(exploreIconFinder);
    await tester.pumpAndSettle();

    // Verify if the ExploreTabs widget is shown.

    expect(find.byType(ExploreTabs), findsOneWidget);

    // Navigate to the Explore tab.

    final exploreTabFinder = find.text('Explore');
    await tester.tap(exploreTabFinder);
    await tester.pumpAndSettle();

    // Find the Summary tab by its title.

    final summaryTabFinder = find.text('Summary');
    expect(summaryTabFinder, findsOneWidget);

    // Tap the Summary tab.

    await tester.tap(summaryTabFinder);
    await tester.pumpAndSettle();

    // Verify that the SummaryPanel is shown.

    expect(find.byType(SummaryPanel), findsOneWidget);

    // Find the button by its text.

    final generateSummaryButtonFinder = find.text('Generate Dataset Summary');
    expect(generateSummaryButtonFinder, findsOneWidget);

    // Tap the button.

    await tester.tap(generateSummaryButtonFinder);
    await tester.pumpAndSettle();

    // Find the right arrow button in the PageIndicator.

    final rightArrowFinder = find.byIcon(Icons.arrow_right_rounded);
    expect(rightArrowFinder, findsOneWidget);

    // Tap the right arrow button to go to "Summary of the Dataset" page.

    await tester.tap(rightArrowFinder);
    await tester.pumpAndSettle();

    // Find the text containing "2007-11-01".

    final dateFinder = find.textContaining('2007-11-01');
    expect(dateFinder, findsOneWidget);

    // Find the text containing "39.800".

    final valueFinder = find.textContaining('39.800');
    expect(valueFinder, findsOneWidget);

    // Tap the right arrow button to go to "Skim of the Dataset" page.

    await tester.tap(rightArrowFinder);
    await tester.pumpAndSettle();

    // Find the text containing "366" as the number of rows.

    final rowsFinder = find.textContaining('366');
    expect(rowsFinder, findsOneWidget);

    // Find the text containing "23" as the number of columns.

    final columnsFinder = find.textContaining('23');
    expect(columnsFinder, findsOneWidget);

    // Tap the right arrow button to go to "Kurtosis and Skewness" page.

    await tester.tap(rightArrowFinder);
    await tester.pumpAndSettle();

    // Find the text containing "-1.12569017" as the min_temp.

    final tempMinFinder = find.textContaining('-1.12569017');
    expect(tempMinFinder, findsOneWidget);

    // Find the text containing "0.347510625" as the max_temp.

    final tempMaxFinder = find.textContaining('0.347510625');
    expect(tempMaxFinder, findsOneWidget);

    debugPrint('TESTER: Finished.');
  });
}
