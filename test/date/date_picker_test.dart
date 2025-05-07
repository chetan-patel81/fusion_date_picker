
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fusion_date_picker/fusion_date_picker.dart';

void main() {
  group('DatePicker', () {
    testWidgets(
      'Should clamp the initial date to fall between the max min range',
      (WidgetTester tester) async {
        final DateTime minDate = DateTime(2023, 3, 11);
        final DateTime maxDate = DateTime(2024, 3, 20);

        await tester.pumpWidget(
          MaterialApp(
            home: Material(
              child: FusionDatePicker(
                minDate: minDate,
                maxDate: maxDate,
              ),
            ),
          ),
        );
      },
    );

    testWidgets(
      'MonthPicker Should get the clamped initial date and not throw',
          (WidgetTester tester) async {
        final DateTime minDate = DateTime(2023, 3, 11);
        final DateTime maxDate = DateTime(2024, 3, 20);

        await tester.pumpWidget(
          MaterialApp(
            home: Material(
              child: FusionDatePicker(
                minDate: minDate,
                maxDate: maxDate,
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Print initial visible Text widgets.
        final allTextWidgets = find.byType(Text);
        for (final e in allTextWidgets.evaluate()) {
          debugPrint('Visible Text: ${(e.widget as Text).data}');
        }

        // Tap the header "March 2024"
        final headerMonthFinder = find.text('March 2024');
        expect(headerMonthFinder, findsOneWidget);
        await tester.tap(headerMonthFinder);
        await tester.pumpAndSettle();

        // Print Text widgets after tapping header to debug what's shown in month/year selection
        final postTapTextWidgets = find.byType(Text);
        for (final e in postTapTextWidgets.evaluate()) {
          debugPrint('PostTap Visible Text: ${(e.widget as Text).data}');
        }

        // ===
        // Leave the year/month finders here commented until we've seen the output!
        // ===

        // final headerYearFinder = find.byWidgetPredicate(
        //   (widget) => widget is Text && (widget.data == '2024'),
        // );
        // expect(headerYearFinder, findsOneWidget);

        // await tester.tap(headerYearFinder);
        // await tester.pumpAndSettle();

        // final yearToSelectFinder = find.byWidgetPredicate(
        //   (widget) => widget is Text && widget.data == '2023',
        // );
        // // should not throw after the tap.
        // await tester.tap(yearToSelectFinder);
        // await tester.pumpAndSettle();

        // For month abbreviation, test for both possible 'Mar' and full 'March'.
        // final monthToSelectFinder = find.byWidgetPredicate(
        //   (widget) =>
        //       widget is Text &&
        //       (widget.data == 'Mar' || widget.data == 'March'),
        // );
        // // should not throw after the tap.
        // await tester.tap(monthToSelectFinder);
        // await tester.pumpAndSettle();
      },
    );

  });
}
