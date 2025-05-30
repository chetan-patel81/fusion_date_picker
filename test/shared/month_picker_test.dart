
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fusion_date_picker/fusion_date_picker.dart';


void main() {
  group('MonthPicker', () {
    testWidgets('should show the correct leading header date', (WidgetTester tester) async {
      final DateTime initialDate = DateTime(2022, 6, 1);
      final DateTime minDate = DateTime(2022, 1, 1);
      final DateTime maxDate = DateTime(2022, 12, 31);

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: FusionMonthPicker(
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

      final Finder headerFinder = find.byType( FusionHeader);
      expect(headerFinder, findsOneWidget);

      final Text headerTextWidget = tester.widget<Text>(
        find.descendant(
          of: headerFinder,
          matching: find.byType(Text),
        ),
      );
      expect(
        headerTextWidget.data,
        initialDate.year.toString(),
      );
    });

    testWidgets('should change the page forward and backward on drag.', (WidgetTester tester) async {
      final DateTime initialDate = DateTime(2020, 6, 1);
      final DateTime minDate = DateTime(2000, 1, 1);
      final DateTime maxDate = DateTime(2030, 12, 31);

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: FusionMonthPicker(
              initialDate: initialDate,
              minDate: minDate,
              maxDate: maxDate,
              currentDate: initialDate,
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

      final DateTime newDisplayedYear = DateTime(2021, 6, 1);

      await tester.drag(pageViewFinder, const Offset(-600, 0)); // Drag the page forward
      await tester.pumpAndSettle();

      final Finder headerFinder = find.byType(FusionHeader);
      final Text headerTextWidget = tester.widget<Text>(
        find.descendant(
          of: headerFinder,
          matching: find.byType(Text),
        ),
      );
      expect(
        headerTextWidget.data,
        newDisplayedYear.year.toString(),
      );

      await tester.drag(pageViewFinder, const Offset(600, 0)); // Drag the page backward
      await tester.pumpAndSettle();

      final Finder newHeaderFinder = find.byType(FusionHeader);
      final Text newHeaderTextWidget = tester.widget<Text>(
        find.descendant(
          of: newHeaderFinder,
          matching: find.byType(Text),
        ),
      );
      expect(
        newHeaderTextWidget.data,
        initialDate.year.toString(),
      );
    });

    testWidgets('should change the page when tapping on the next page icon and update header.',
        (WidgetTester tester) async {
      final DateTime initialDate = DateTime(2022, 6, 1);
      final DateTime minDate = DateTime(2022, 1, 1);
      final DateTime maxDate = DateTime(2024, 12, 31);

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: FusionMonthPicker(
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

      final int initialPage = tester.widget<PageView>(pageViewFinder).controller!.initialPage;

      final Finder nextPageIconFinder = find.byIcon(Icons.arrow_forward_ios_rounded);
      expect(nextPageIconFinder, findsOneWidget);

      final Finder headerFinder = find.byType(FusionHeader);
      final Text headerTextWidget = tester.widget<Text>(
        find.descendant(
          of: headerFinder,
          matching: find.byType(Text),
        ),
      );
      expect(
        headerTextWidget.data,
        initialDate.year.toString(),
      );

      await tester.tap(nextPageIconFinder);
      await tester.pumpAndSettle();

      final int currentPage = tester.widget<PageView>(pageViewFinder).controller!.page!.round();

      expect(currentPage, equals(initialPage + 1));

      final DateTime newDisplayedYear = DateTime(2023, 7, 1);

      final Finder newHeaderFinder = find.byType(FusionHeader);
      final Text newHeaderTextWidget = tester.widget<Text>(
        find.descendant(
          of: newHeaderFinder,
          matching: find.byType(Text),
        ),
      );
      expect(
        newHeaderTextWidget.data,
        newDisplayedYear.year.toString(),
      );
    });

    testWidgets('should change the page when tapping on the previous page icon and update header.',
        (WidgetTester tester) async {
      final DateTime initialDate = DateTime(2022, 6, 1);
      final DateTime minDate = DateTime(2000, 1, 1);
      final DateTime maxDate = DateTime(2030, 12, 31);

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: FusionMonthPicker(
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

      final int initialPage = tester.widget<PageView>(pageViewFinder).controller!.initialPage;

      final Finder previousPageIconFinder = find.byIcon(Icons.arrow_back_ios_rounded);
      expect(previousPageIconFinder, findsOneWidget);

      final Finder headerFinder = find.byType(FusionHeader);
      final Text headerTextWidget = tester.widget<Text>(
        find.descendant(
          of: headerFinder,
          matching: find.byType(Text),
        ),
      );
      expect(
        headerTextWidget.data,
        initialDate.year.toString(),
      );

      await tester.tap(previousPageIconFinder);
      await tester.pumpAndSettle();

      final int currentPage = tester.widget<PageView>(pageViewFinder).controller!.page!.round();

      expect(currentPage, equals(initialPage - 1));

      final DateTime newDisplayedYear = DateTime(2021, 5, 1);

      final Finder newHeaderFinder = find.byType(FusionHeader);
      final Text newHeaderTextWidget = tester.widget<Text>(
        find.descendant(
          of: newHeaderFinder,
          matching: find.byType(Text),
        ),
      );
      expect(
        newHeaderTextWidget.data,
        newDisplayedYear.year.toString(),
      );
    });

    testWidgets(
        'should NOT change the page when tapping on the previous page icon when the range in max and min date are one year.',
        (WidgetTester tester) async {
      final DateTime initialDate = DateTime(2020, 6, 1);
      final DateTime minDate = DateTime(2020, 1, 1);
      final DateTime maxDate = DateTime(2020, 12, 31);

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: FusionMonthPicker(
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

      final int initialPage = tester.widget<PageView>(pageViewFinder).controller!.initialPage;

      final Finder previousPageIconFinder = find.byIcon(Icons.arrow_back_ios_rounded);
      expect(previousPageIconFinder, findsOneWidget);

      final Finder headerFinder = find.byType(FusionHeader);
      final Text headerTextWidget = tester.widget<Text>(
        find.descendant(
          of: headerFinder,
          matching: find.byType(Text),
        ),
      );
      expect(
        headerTextWidget.data,
        initialDate.year.toString(),
      );

      await tester.tap(previousPageIconFinder);
      await tester.pumpAndSettle();

      final int currentPage = tester.widget<PageView>(pageViewFinder).controller!.page!.round();

      expect(currentPage, equals(initialPage));

      final DateTime newDisplayedYear = DateTime(2020, 5, 1);

      final Finder newHeaderFinder = find.byType(FusionHeader);
      final Text newHeaderTextWidget = tester.widget<Text>(
        find.descendant(
          of: newHeaderFinder,
          matching: find.byType(Text),
        ),
      );
      expect(
        newHeaderTextWidget.data,
        newDisplayedYear.year.toString(),
      );
    });

    testWidgets(
        'should NOT change the page when tapping on the next page icon when the range in max and min date are one year.',
        (WidgetTester tester) async {
      final DateTime initialDate = DateTime(2022, 6, 1);
      final DateTime minDate = DateTime(2022, 1, 1);
      final DateTime maxDate = DateTime(2022, 12, 31);

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: FusionMonthPicker(
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

      final int initialPage = tester.widget<PageView>(pageViewFinder).controller!.initialPage;

      final Finder nextPageIconFinder = find.byIcon(Icons.arrow_forward_ios_rounded);
      expect(nextPageIconFinder, findsOneWidget);

      final Finder headerFinder = find.byType(FusionHeader);
      final Text headerTextWidget = tester.widget<Text>(
        find.descendant(
          of: headerFinder,
          matching: find.byType(Text),
        ),
      );
      expect(
        headerTextWidget.data,
        initialDate.year.toString(),
      );

      await tester.tap(nextPageIconFinder);
      await tester.pumpAndSettle();

      final int currentPage = tester.widget<PageView>(pageViewFinder).controller!.page!.round();

      expect(currentPage, equals(initialPage));

      final DateTime newDisplayedYear = DateTime(2022, 7, 1);

      final Finder newHeaderFinder = find.byType(FusionHeader);
      final Text newHeaderTextWidget = tester.widget<Text>(
        find.descendant(
          of: newHeaderFinder,
          matching: find.byType(Text),
        ),
      );
      expect(
        newHeaderTextWidget.data,
        newDisplayedYear.year.toString(),
      );
    });

    testWidgets(
        'should NOT change the page forward and backward on drag when the range in max and min date are one year.',
        (WidgetTester tester) async {
      final DateTime initialDate = DateTime(2020, 6, 1);
      final DateTime minDate = DateTime(2020, 1, 1);
      final DateTime maxDate = DateTime(2020, 12, 31);

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: FusionMonthPicker(
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

      final DateTime newDisplayedYear = DateTime(2020, 6, 1);

      await tester.drag(pageViewFinder, const Offset(-600, 0)); // Drag the page forward
      await tester.pumpAndSettle();

      final Finder headerFinder = find.byType(FusionHeader);
      final Text headerTextWidget = tester.widget<Text>(
        find.descendant(
          of: headerFinder,
          matching: find.byType(Text),
        ),
      );
      expect(
        headerTextWidget.data,
        newDisplayedYear.year.toString(),
      );

      await tester.drag(pageViewFinder, const Offset(600, 0)); // Drag the page backward
      await tester.pumpAndSettle();

      final Finder newHeaderFinder = find.byType(FusionHeader);
      final Text newHeaderTextWidget = tester.widget<Text>(
        find.descendant(
          of: newHeaderFinder,
          matching: find.byType(Text),
        ),
      );
      expect(
        newHeaderTextWidget.data,
        initialDate.year.toString(),
      );
    });

    testWidgets(
      'Should show the correct month on pick',
      (WidgetTester tester) async {
        final DateTime initialDate = DateTime(2010, 2);
        final DateTime minDate = DateTime(2000);
        final DateTime maxDate = DateTime(2011);
        final DateTime monthToSelect = DateTime(2010);
        late final DateTime expectedMonth;
        const selectedYearColor = Colors.green;

        await tester.pumpWidget(
          MaterialApp(
            home: Material(
              child: FusionMonthPicker(
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
                onDateSelected: (value) {
                  expectedMonth = value;
                },
              ),
            ),
          ),
        );

        final selectedMonthFinder = find.byWidgetPredicate((widget) {
          if (widget is Container && widget.child is Center && (widget.child as Center).child is Text) {
            return ((widget.child as Center).child as Text).data == 'Jan' &&
                ((widget.child as Center).child as Text).style?.color == selectedYearColor;
          }
          return false;
        });

        final monthFinder = find.byWidgetPredicate((widget) {
          if (widget is Container && widget.child is Center && (widget.child as Center).child is Text) {
            return ((widget.child as Center).child as Text).data == 'Jan';
          }
          return false;
        });

        expect(selectedMonthFinder, findsNothing);

        await tester.tap(monthFinder);
        await tester.pumpAndSettle();

        expect(expectedMonth, monthToSelect);
      },
    );

    testWidgets(
      'Should show the correct text style for the leading date',
      (WidgetTester tester) async {
        final DateTime initialDate = DateTime(2010);
        final DateTime minDate = DateTime(2000);
        final DateTime maxDate = DateTime(2011);
        const leadingDayColor = Colors.green;

        await tester.pumpWidget(
          MaterialApp(
            home: Material(
              child: FusionMonthPicker(
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

        final leadingDayFinder = find.byWidgetPredicate((widget) {
          if (widget is Text) {
            return widget.data == '2010' && widget.style?.color == leadingDayColor;
          }
          return false;
        });

        expect(leadingDayFinder, findsOneWidget);
      },
    );

    testWidgets(
      'Should show the correct color and size for page sliders',
      (WidgetTester tester) async {
        final DateTime initialDate = DateTime(2010);
        final DateTime minDate = DateTime(2000);
        final DateTime maxDate = DateTime(2011);
        const slidersColors = Colors.green;
        const slidersSize = 18.0;

        await tester.pumpWidget(
          MaterialApp(
            home: Material(
              child: FusionMonthPicker(
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
            return widget.color == slidersColors &&
                widget.size == slidersSize &&
                widget.icon == Icons.arrow_back_ios_rounded;
          }
          return false;
        });

        expect(leftIconFinder, findsOneWidget);

        final rightIconFinder = find.byWidgetPredicate((widget) {
          if (widget is Icon) {
            return widget.color == slidersColors &&
                widget.size == slidersSize &&
                widget.icon == Icons.arrow_forward_ios_rounded;
          }
          return false;
        });

        expect(rightIconFinder, findsOneWidget);
      },
    );
    testWidgets(
      'Should not throw assertion when initial date at edge of max or min',
      (WidgetTester tester) async {
        final DateTime initialDate = DateTime(2024, 6, 31);
        final DateTime minDate = DateTime(2024, 1, 1);
        final DateTime maxDate = DateTime(2024, 6, 29);


            await tester.pumpWidget(
              MaterialApp(
                home: Material(
                  child: FusionMonthPicker(
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

                    splashColor: Colors.black,
                    highlightColor: Colors.black,
                  ),
                ),
              ),
            );
          },


    );
    testWidgets(
      'Should not scroll when first open',
      (WidgetTester tester) async {
        final DateTime minDate = DateTime(2000);
        final DateTime maxDate = DateTime(2010);

        int numberOfScrollListenerCalled = 0;

        void scrollListener() => numberOfScrollListenerCalled++;

        await tester.pumpWidget(
          MaterialApp(
            home: Material(
              child: FusionMonthPicker(
                minDate: minDate,
                maxDate: maxDate,
              ),
            ),
          ),
        );

        final pageViewWidget = tester.widget<PageView>(find.byType(PageView));
        pageViewWidget.controller!.addListener(scrollListener);

        await tester.pumpAndSettle();

        expect(numberOfScrollListenerCalled, equals(0));
      },
    );
  });
}
