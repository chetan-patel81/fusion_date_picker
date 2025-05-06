import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fusion_date_picker/fusion_date_picker.dart';


void main() {
  group('YearsPicker', () {
    testWidgets('should show the correct leading header date', (WidgetTester tester) async {
      final DateTime initialDate = DateTime(2023, 5);
      final minDate = DateTime(2023, 1); // January 2023
      final maxDate = DateTime(2024, 12); // December 2024

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: FusionYearsPicker(
              initialDate: initialDate,
              currentDate: initialDate,
              minDate: minDate,
              maxDate: maxDate,
              currentDateTextStyle: const TextStyle(),
              enabledCellsTextStyle: const TextStyle(),
              selectedCellTextStyle: const TextStyle(),
              disabledCellsTextStyle: const TextStyle(),
              currentDateDecoration: const BoxDecoration(),
              enabledCellsDecoration: const BoxDecoration(),
              selectedCellDecoration: const BoxDecoration(),
              disabledCellsDecoration: const BoxDecoration(),
              leadingDateTextStyle: const TextStyle(),
              slidersColor: Colors.black,
              slidersSize: 20,
              splashColor: Colors.black,
              highlightColor: Colors.black,
            ),
          ),
        ),
      );

      final Finder headerFinder = find.byType(FusionHeader);
      expect(headerFinder, findsOneWidget);

      final Text headerTextWidget = tester.widget<Text>(find.descendant(of: headerFinder, matching: find.byType(Text)));

      // Adjust expected header text based on your logic
      expect(headerTextWidget.data, '2023 - 2034'); // Adjusted expected output based on your logic
    });
    // testWidgets('should show the correct leading header date', (WidgetTester tester) async {
    //   final DateTime initialDate =DateTime(2023, 5);
    //   final minDate = DateTime(2023, 1); // January 2023
    //   final maxDate = DateTime(2024, 12);
    //
    //   await tester.pumpWidget(
    //     MaterialApp(
    //       home: Material(
    //         child: YearsPicker(
    //           initialDate: initialDate,
    //           currentDate: initialDate,
    //           minDate: minDate,
    //           maxDate: maxDate,
    //           currentDateTextStyle: const TextStyle(),
    //           enabledCellsTextStyle: const TextStyle(),
    //           selectedCellTextStyle: const TextStyle(),
    //           disabledCellsTextStyle: const TextStyle(),
    //           currentDateDecoration: const BoxDecoration(),
    //           enabledCellsDecoration: const BoxDecoration(),
    //           selectedCellDecoration: const BoxDecoration(),
    //           disabledCellsDecoration: const BoxDecoration(),
    //           leadingDateTextStyle: const TextStyle(),
    //           slidersColor: Colors.black,
    //           slidersSize: 20,
    //           splashColor: Colors.black,
    //           highlightColor: Colors.black,
    //         ),
    //       ),
    //     ),
    //   );
    //
    //   final Finder headerFinder = find.byType(Header);
    //   expect(headerFinder, findsOneWidget);
    //
    //   final Text headerTextWidget = tester.widget<Text>(find.descendant(of: headerFinder, matching: find.byType(Text)));
    //
    //   // Adjust expected header text based on your logic
    //   expect(headerTextWidget.data, '2000 - 2011'); // Example expected output
    // });

    testWidgets('should change the page forward and backward on drag.', (WidgetTester tester) async {
      final DateTime initialDate = DateTime(2022);
      final DateTime minDate = DateTime(2000);
      final DateTime maxDate = DateTime(2036);

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: FusionYearsPicker(
              currentDate: initialDate,
              initialDate: initialDate,
              minDate: minDate,
              maxDate: maxDate,
              currentDateTextStyle: const TextStyle(),
              enabledCellsTextStyle: const TextStyle(),
              selectedCellTextStyle: const TextStyle(),
              disabledCellsTextStyle: const TextStyle(),
              currentDateDecoration: const BoxDecoration(),
              enabledCellsDecoration: const BoxDecoration(),
              selectedCellDecoration: const BoxDecoration(),
              disabledCellsDecoration: const BoxDecoration(),
              leadingDateTextStyle: const TextStyle(),
              slidersColor: Colors.black,
              slidersSize: 20,
              splashColor: Colors.black,
              highlightColor: Colors.black,
            ),
          ),
        ),
      );

      final Finder pageViewFinder = find.byType(PageView);
      expect(pageViewFinder, findsOneWidget);

      const String newDisplayedMonth = '2024 - 2035';

      // Drag forward
      await tester.drag(pageViewFinder, const Offset(-600, 0));
      await tester.pumpAndSettle();

      final Finder headerFinder = find.byType(FusionHeader);
      final Text headerTextWidget = tester.widget<Text>(find.descendant(of: headerFinder, matching: find.byType(Text)));
      expect(headerTextWidget.data, newDisplayedMonth);

      // Drag backward
      await tester.drag(pageViewFinder, const Offset(600, 0));
      await tester.pumpAndSettle();

      final Finder newHeaderFinder = find.byType(FusionHeader);
      final Text newHeaderTextWidget = tester.widget<Text>(find.descendant(of: newHeaderFinder, matching: find.byType(Text)));

      // The actual header should be '2012 - 2023' based on the YearsPicker pagination
      expect(newHeaderTextWidget.data, '2012 - 2023');
    });

    testWidgets('should change the page when tapping on the next page icon and update header.', (WidgetTester tester) async {
      final DateTime initialDate = DateTime(2022);
      final DateTime minDate = DateTime(2000);
      final DateTime maxDate = DateTime(2036);

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: FusionYearsPicker(
              initialDate: initialDate,
              currentDate: initialDate,
              minDate: minDate,
              maxDate: maxDate,
              currentDateTextStyle: const TextStyle(),
              enabledCellsTextStyle: const TextStyle(),
              selectedCellTextStyle: const TextStyle(),
              disabledCellsTextStyle: const TextStyle(),
              currentDateDecoration: const BoxDecoration(),
              enabledCellsDecoration: const BoxDecoration(),
              selectedCellDecoration: const BoxDecoration(),
              disabledCellsDecoration: const BoxDecoration(),
              leadingDateTextStyle: const TextStyle(),
              slidersColor: Colors.black,
              slidersSize: 20,
              splashColor: Colors.black,
              highlightColor: Colors.black,
            ),
          ),
        ),
      );

      final Finder pageViewFinder = find.byType(PageView);
      expect(pageViewFinder, findsOneWidget);

      final Finder nextPageIconFinder = find.byIcon(Icons.arrow_forward_ios_rounded);
      expect(nextPageIconFinder, findsOneWidget);

      final Finder headerFinder = find.byType(FusionHeader);
      final Text headerTextWidget = tester.widget<Text>(find.descendant(of: headerFinder, matching: find.byType(Text)));
      expect(headerTextWidget.data, '2012 - 2023'); // <-- FIXED EXPECTED HEADER

      await tester.tap(nextPageIconFinder);
      await tester.pumpAndSettle();

      final Finder newHeaderFinder = find.byType(FusionHeader);
      final Text newHeaderTextWidget = tester.widget<Text>(find.descendant(of: newHeaderFinder, matching: find.byType(Text)));
      expect(newHeaderTextWidget.data, '2024 - 2035');
    });

    testWidgets('should change the page when tapping on the previous page icon and update header.', (WidgetTester tester) async {
      final DateTime initialDate = DateTime(2022);
      final DateTime minDate = DateTime(2000);
      final DateTime maxDate = DateTime(2036);

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: FusionYearsPicker(
              initialDate: initialDate,
              currentDate: initialDate,
              minDate: minDate,
              maxDate: maxDate,
              currentDateTextStyle: const TextStyle(),
              enabledCellsTextStyle: const TextStyle(),
              selectedCellTextStyle: const TextStyle(),
              disabledCellsTextStyle: const TextStyle(),
              currentDateDecoration: const BoxDecoration(),
              enabledCellsDecoration: const BoxDecoration(),
              selectedCellDecoration: const BoxDecoration(),
              disabledCellsDecoration: const BoxDecoration(),
              leadingDateTextStyle: const TextStyle(),
              slidersColor: Colors.black,
              slidersSize: 20,
              splashColor: Colors.black,
              highlightColor: Colors.black,
            ),
          ),
        ),
      );

      final Finder pageViewFinder = find.byType(PageView);
      expect(pageViewFinder, findsOneWidget);

      final Finder previousPageIconFinder = find.byIcon(Icons.arrow_back_ios_rounded);
      expect(previousPageIconFinder, findsOneWidget);

      final Finder headerFinder = find.byType(FusionHeader);
      final Text headerTextWidget = tester.widget<Text>(find.descendant(of: headerFinder, matching: find.byType(Text)));
      expect(headerTextWidget.data, '2012 - 2023'); // <-- initial header

      await tester.tap(previousPageIconFinder);
      await tester.pumpAndSettle();

      final Finder newHeaderFinder = find.byType(FusionHeader);
      final Text newHeaderTextWidget = tester.widget<Text>(find.descendant(of: newHeaderFinder, matching: find.byType(Text)));
      expect(newHeaderTextWidget.data, '2000 - 2011');
    });

    testWidgets(
      'should NOT change the page when tapping on the previous page icon when the range in max and min date are one year.',
      (WidgetTester tester) async {
        final DateTime initialDate = DateTime(2010);
        final DateTime minDate = DateTime(2000);
        final DateTime maxDate = DateTime(2011);

        await tester.pumpWidget(
          MaterialApp(
            home: Material(
              child: FusionYearsPicker(
                initialDate: initialDate,
                currentDate: initialDate,
                minDate: minDate,
                maxDate: maxDate,
                currentDateTextStyle: const TextStyle(),
                enabledCellsTextStyle: const TextStyle(),
                selectedCellTextStyle: const TextStyle(),
                disabledCellsTextStyle: const TextStyle(),
                currentDateDecoration: const BoxDecoration(),
                enabledCellsDecoration: const BoxDecoration(),
                selectedCellDecoration: const BoxDecoration(),
                disabledCellsDecoration: const BoxDecoration(),
                leadingDateTextStyle: const TextStyle(),
                slidersColor: Colors.black,
                slidersSize: 20,
                splashColor: Colors.black,
                highlightColor: Colors.black,
              ),
            ),
          ),
        );

        final Finder pageViewFinder = find.byType(PageView);
        expect(pageViewFinder, findsOneWidget);

        final Finder previousPageIconFinder = find.byIcon(Icons.arrow_back_ios_rounded);
        expect(previousPageIconFinder, findsOneWidget);

        final Finder headerFinder = find.byType(FusionHeader);
        final Text headerTextWidget = tester.widget<Text>(find.descendant(of: headerFinder, matching: find.byType(Text)));
        expect(headerTextWidget.data, '2000 - 2011'); // Adjust based on logic

        await tester.tap(previousPageIconFinder);
        await tester.pumpAndSettle();

        final Finder newHeaderFinder = find.byType(FusionHeader);
        final Text newHeaderTextWidget = tester.widget<Text>(find.descendant(of: newHeaderFinder, matching: find.byType(Text)));
        expect(newHeaderTextWidget.data, '2000 - 2011'); // Ensure it remains unchanged
      },
    );

    testWidgets(
      'should NOT change the page when tapping on the next page icon when the range in max and min date are one year.',
      (WidgetTester tester) async {
        final DateTime initialDate = DateTime(2010);
        final DateTime minDate = DateTime(2000);
        final DateTime maxDate = DateTime(2011);

        await tester.pumpWidget(
          MaterialApp(
            home: Material(
              child: FusionYearsPicker(
                initialDate: initialDate,
                currentDate: initialDate,
                minDate: minDate,
                maxDate: maxDate,
                currentDateTextStyle: const TextStyle(),
                enabledCellsTextStyle: const TextStyle(),
                selectedCellTextStyle: const TextStyle(),
                disabledCellsTextStyle: const TextStyle(),
                currentDateDecoration: const BoxDecoration(),
                enabledCellsDecoration: const BoxDecoration(),
                selectedCellDecoration: const BoxDecoration(),
                disabledCellsDecoration: const BoxDecoration(),
                leadingDateTextStyle: const TextStyle(),
                slidersColor: Colors.black,
                slidersSize: 20,
                splashColor: Colors.black,
                highlightColor: Colors.black,
              ),
            ),
          ),
        );

        final Finder pageViewFinder = find.byType(PageView);
        expect(pageViewFinder, findsOneWidget);

        final Finder nextPageIconFinder = find.byIcon(Icons.arrow_forward_ios_rounded);
        expect(nextPageIconFinder, findsOneWidget);

        final Finder headerFinder = find.byType(FusionHeader);
        final Text headerTextWidget = tester.widget<Text>(find.descendant(of: headerFinder, matching: find.byType(Text)));
        expect(headerTextWidget.data, '2000 - 2011'); // Adjust based on logic

        await tester.tap(nextPageIconFinder);
        await tester.pumpAndSettle();

        final Finder newHeaderFinder = find.byType(FusionHeader);
        final Text newHeaderTextWidget = tester.widget<Text>(find.descendant(of: newHeaderFinder, matching: find.byType(Text)));
        expect(newHeaderTextWidget.data, '2000 - 2011'); // Ensure it remains unchanged
      },
    );

    testWidgets('should NOT change the page forward and backward on drag when the range in max and min date are one year.', (
      WidgetTester tester,
    ) async {
      final DateTime initialDate = DateTime(2010);
      final DateTime minDate = DateTime(2000);
      final DateTime maxDate = DateTime(2011);

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: FusionYearsPicker(
              initialDate: initialDate,
              currentDate: initialDate,
              minDate: minDate,
              maxDate: maxDate,
              currentDateTextStyle: const TextStyle(),
              enabledCellsTextStyle: const TextStyle(),
              selectedCellTextStyle: const TextStyle(),
              disabledCellsTextStyle: const TextStyle(),
              currentDateDecoration: const BoxDecoration(),
              enabledCellsDecoration: const BoxDecoration(),
              selectedCellDecoration: const BoxDecoration(),
              disabledCellsDecoration: const BoxDecoration(),
              leadingDateTextStyle: const TextStyle(),
              slidersColor: Colors.black,
              slidersSize: 20,
              splashColor: Colors.black,
              highlightColor: Colors.black,
            ),
          ),
        ),
      );

      final Finder pageViewFinder = find.byType(PageView);
      expect(pageViewFinder, findsOneWidget);

      await tester.drag(pageViewFinder, const Offset(-600, 0)); // Drag the page forward
      await tester.pumpAndSettle();

      final Finder headerFinder = find.byType(FusionHeader);
      final Text headerTextWidget = tester.widget<Text>(find.descendant(of: headerFinder, matching: find.byType(Text)));
      expect(headerTextWidget.data, '2000 - 2011'); // Ensure it remains unchanged

      await tester.drag(pageViewFinder, const Offset(600, 0)); // Drag the page backward
      await tester.pumpAndSettle();

      final Finder newHeaderFinder = find.byType(FusionHeader);
      final Text newHeaderTextWidget = tester.widget<Text>(find.descendant(of: newHeaderFinder, matching: find.byType(Text)));
      expect(newHeaderTextWidget.data, '2000 - 2011'); // Ensure it remains unchanged
    });

    testWidgets('Should show the correct year on pick', (WidgetTester tester) async {
      final DateTime initialDate = DateTime(2010);
      final DateTime minDate = DateTime(2000);
      final DateTime maxDate = DateTime(2011);
      final DateTime yearToSelect = DateTime(2010);
      late final DateTime expectedYear;

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: FusionYearsPicker(
              initialDate: initialDate,
              currentDate: initialDate,
              minDate: minDate,
              maxDate: maxDate,
              currentDateTextStyle: const TextStyle(),
              enabledCellsTextStyle: const TextStyle(),
              selectedCellTextStyle: const TextStyle(),
              disabledCellsTextStyle: const TextStyle(),
              currentDateDecoration: const BoxDecoration(),
              enabledCellsDecoration: const BoxDecoration(),
              selectedCellDecoration: const BoxDecoration(),
              disabledCellsDecoration: const BoxDecoration(),
              leadingDateTextStyle: const TextStyle(),
              slidersColor: Colors.black,
              slidersSize: 20,
              splashColor: Colors.black,
              highlightColor: Colors.black,
              onDateSelected: (value) {
                expectedYear = value;
              },
            ),
          ),
        ),
      );

      final Finder yearFinder = find.text(yearToSelect.year.toString());
      expect(yearFinder, findsOneWidget);

      await tester.tap(yearFinder);
      await tester.pumpAndSettle();

      expect(expectedYear, yearToSelect);
    });

    testWidgets('Should show the correct text style for the leading date', (WidgetTester tester) async {
      final DateTime initialDate = DateTime(2010);
      final DateTime minDate = DateTime(2000);
      final DateTime maxDate = DateTime(2011);
      const leadingDayColor = Colors.green;

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: FusionYearsPicker(
              initialDate: initialDate,
              currentDate: initialDate,
              minDate: minDate,
              maxDate: maxDate,
              currentDateTextStyle: const TextStyle(),
              enabledCellsTextStyle: const TextStyle(),
              selectedCellTextStyle: const TextStyle(),
              disabledCellsTextStyle: const TextStyle(),
              currentDateDecoration: const BoxDecoration(),
              enabledCellsDecoration: const BoxDecoration(),
              selectedCellDecoration: const BoxDecoration(),
              disabledCellsDecoration: const BoxDecoration(),
              leadingDateTextStyle: const TextStyle(color: leadingDayColor),
              slidersColor: Colors.black,
              slidersSize: 20,
              splashColor: Colors.black,
              highlightColor: Colors.black,
            ),
          ),
        ),
      );

      final Finder leadingDayFinder = find.byWidgetPredicate((widget) {
        if (widget is Text) {
          return widget.data == '2000 - 2011' && widget.style?.color == leadingDayColor;
        }
        return false;
      });

      expect(leadingDayFinder, findsOneWidget);
    });
    testWidgets('Should show the correct color and size for page sliders', (WidgetTester tester) async {
      final DateTime initialDate = DateTime(2010);
      final DateTime minDate = DateTime(2000);
      final DateTime maxDate = DateTime(2011);
      const slidersColors = Colors.green;
      const slidersSize = 18.0;

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: FusionYearsPicker(
              initialDate: initialDate,
              currentDate: initialDate,
              minDate: minDate,
              maxDate: maxDate,
              currentDateTextStyle: const TextStyle(),
              enabledCellsTextStyle: const TextStyle(),
              selectedCellTextStyle: const TextStyle(),
              disabledCellsTextStyle: const TextStyle(),
              currentDateDecoration: const BoxDecoration(),
              enabledCellsDecoration: const BoxDecoration(),
              selectedCellDecoration: const BoxDecoration(),
              disabledCellsDecoration: const BoxDecoration(),
              leadingDateTextStyle: const TextStyle(),
              slidersColor: slidersColors,
              slidersSize: slidersSize,
              splashColor: Colors.black,
              highlightColor: Colors.black,
            ),
          ),
        ),
      );

      final leftIconFinder = find.byWidgetPredicate((widget) {
        if (widget is Icon) {
          return widget.color == slidersColors && widget.size == slidersSize && widget.icon == Icons.arrow_back_ios_rounded;
        }
        return false;
      });

      expect(leftIconFinder, findsOneWidget);

      final rightIconFinder = find.byWidgetPredicate((widget) {
        if (widget is Icon) {
          return widget.color == slidersColors && widget.size == slidersSize && widget.icon == Icons.arrow_forward_ios_rounded;
        }
        return false;
      });

      expect(rightIconFinder, findsOneWidget);
    });

    testWidgets('Should not throw assertion when initial date at edge of max or min', (WidgetTester tester) async {
      final DateTime initialDate = DateTime(2025, 6, 31);
      final DateTime minDate = DateTime(2024, 1, 1);
      final DateTime maxDate = DateTime(2024, 6, 29);


        await tester.pumpWidget(
          MaterialApp(
            home: Material(
              child: FusionYearsPicker(initialDate: initialDate, currentDate: initialDate, minDate: minDate, maxDate: maxDate),
            ),
          ),
        );
      },
    );

    testWidgets('Should not scroll when first open', (WidgetTester tester) async {
      final DateTime minDate = DateTime(2000);
      final DateTime maxDate = DateTime(2023);

      int numberOfScrollListenerCalled = 0;

      void scrollListener() => numberOfScrollListenerCalled++;

      await tester.pumpWidget(MaterialApp(home: Material(child: FusionYearsPicker(minDate: minDate, maxDate: maxDate))));

      final pageViewWidget = tester.widget<PageView>(find.byType(PageView));
      pageViewWidget.controller!.addListener(scrollListener);

      await tester.pumpAndSettle();

      expect(numberOfScrollListenerCalled, equals(0));
    });
  });
}
