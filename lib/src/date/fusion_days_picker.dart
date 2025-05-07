import 'package:flutter/material.dart';
import 'package:fusion_date_picker/fusion_date_picker.dart';

import 'package:get/get.dart';

import 'fusion_days_view.dart';



class FusionDaysPickerController extends GetxController {
  final DateTime minDate;
  final DateTime maxDate;
  final DateTime? initialDate;
  final DateTime? currentDate;
  final DateTime? selectedDate;
  final ValueChanged<DateTime>? onDateSelected;
  final ValueChanged<DateTime>? onDoubleTap;
  final VoidCallback? onLeadingDateTap;
  final DatePredicate? disabledDayPredicate;
  final TextStyle? daysOfTheWeekTextStyle;
  final TextStyle? enabledCellsTextStyle;
  final BoxDecoration enabledCellsDecoration;
  final TextStyle? disabledCellsTextStyle;
  final BoxDecoration disabledCellsDecoration;
  final TextStyle? currentDateTextStyle;
  final BoxDecoration? currentDateDecoration;
  final TextStyle? selectedCellTextStyle;
  final BoxDecoration? selectedCellDecoration;
  final TextStyle? leadingDateTextStyle;
  final Color? slidersColor;
  final double? slidersSize;
  final Color? splashColor;
  final Color? highlightColor;
  final double? splashRadius;
  final bool centerLeadingDate;
  final String? previousPageSemanticLabel;
  final String? nextPageSemanticLabel;
  final bool showOkCancel;
  late Rx<DateTime?> displayedMonth;
  late Rx<DateTime?> selectedDay;
  late PageController pageController;

  FusionDaysPickerController({
    required this.minDate,
    required this.maxDate,
    this.initialDate,
    this.currentDate,
    this.selectedDate,
    this.daysOfTheWeekTextStyle,
    this.enabledCellsTextStyle,
    this.enabledCellsDecoration = const BoxDecoration(),
    this.disabledCellsTextStyle,
    this.disabledCellsDecoration = const BoxDecoration(),
    this.currentDateTextStyle,
    this.currentDateDecoration,
    this.selectedCellTextStyle,
    this.selectedCellDecoration,
    this.onLeadingDateTap,
    this.onDateSelected,
    this.onDoubleTap,
    this.showOkCancel = true,
    this.leadingDateTextStyle,
    this.slidersColor,
    this.slidersSize,
    this.splashColor,
    this.highlightColor,
    this.splashRadius,
    this.centerLeadingDate = false,
    this.previousPageSemanticLabel = 'Previous Day',
    this.nextPageSemanticLabel = 'Next Day',
    this.disabledDayPredicate,
  });

  @override
  void onInit() {
    final clampedInitialDate = FusionDateUtilsX.clampDateToRange(
      max: maxDate,
      min: minDate,
      date: DateTime.now(),
    );
    displayedMonth = DateUtils.dateOnly(initialDate ?? clampedInitialDate).obs;
    selectedDay = (selectedDate != null ? DateUtils.dateOnly(selectedDate!) : null).obs;
    pageController = PageController(
      initialPage: DateUtils.monthDelta(minDate, displayedMonth.value!),
    );
    super.onInit();
  }

  void onPageChanged(int monthPage) {
    final DateTime monthDate = DateUtils.addMonthsToMonthDate(minDate, monthPage);
    displayedMonth.value = monthDate;
  }

  // void onSelectedDay(DateTime value) {
  //   selectedDay.value = value;
  //   onDateSelected?.call(value);
  // }

  /// Called when a day is single-tapped.
  void onUserSelectedDay(DateTime value) {
    selectedDay.value = value;

    if (!showOkCancel) {
      // Immediate confirmation if there are no OK/Cancel buttons
      onDateSelected?.call(value);
    }
    // else: only update selection (tentative), actual confirmation on OK/double-tap
  }

  /// Called when a day is double-tapped (always confirms immediately).
  void onUserDoubleTapDay(DateTime value) {
    selectedDay.value = value;
    // Always confirm immediately on double tap
    onDateSelected?.call(value);
    onDoubleTap?.call(value); // This can let the parent trigger onOk too if desired
  }

  void jumpToInitialPage(DateTime? newInitialDate) {
    final clampedInitialDate = FusionDateUtilsX.clampDateToRange(
      max: maxDate,
      min: minDate,
      date: DateTime.now(),
    );
    final DateTime initial = DateUtils.dateOnly(newInitialDate ?? clampedInitialDate);
    displayedMonth.value = initial;
    pageController.jumpToPage(
      DateUtils.monthDelta(minDate, initial),
    );
  }

  void updateSelectedDayFromWidget(DateTime? v) {
    selectedDay.value = v != null ? DateUtils.dateOnly(v) : null;
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}

class FusionDaysPicker extends StatelessWidget {
  FusionDaysPicker({
    super.key,
    required this.minDate,
    required this.maxDate,
    this.initialDate,
    this.currentDate,
    this.selectedDate,
    this.daysOfTheWeekTextStyle,
    this.enabledCellsTextStyle,
    this.enabledCellsDecoration = const BoxDecoration(),
    this.disabledCellsTextStyle,
    this.disabledCellsDecoration = const BoxDecoration(),
    this.currentDateTextStyle,
    this.currentDateDecoration,
    this.selectedCellTextStyle,
    this.selectedCellDecoration,
    this.onLeadingDateTap,
    this.onDateSelected,
    this.onDoubleTap,
    required this.showOkCancel ,
    this.leadingDateTextStyle,
    this.slidersColor,
    this.slidersSize,
    this.highlightColor,
    this.splashColor,
    this.splashRadius,
    this.centerLeadingDate = false,
    this.previousPageSemanticLabel = 'Previous Day',
    this.nextPageSemanticLabel = 'Next Day',
    this.disabledDayPredicate,

  }) {
    assert(!minDate.isAfter(maxDate), "minDate can't be after maxDate");
    assert(
        () {
      if (initialDate == null) return true;
      final init = DateTime(initialDate!.year, initialDate!.month, initialDate!.day);
      final min = DateTime(minDate.year, minDate.month, minDate.day);
      return init.isAfter(min) || init.isAtSameMomentAs(min);
    }(),
    'initialDate $initialDate must be on or after minDate $minDate.',
    );
    assert(
        () {
      if (initialDate == null) return true;
      final init = DateTime(initialDate!.year, initialDate!.month, initialDate!.day);
      final max = DateTime(maxDate.year, maxDate.month, maxDate.day);
      return init.isBefore(max) || init.isAtSameMomentAs(max);
    }(),
    'initialDate $initialDate must be on or before maxDate $maxDate.',
    );
  }

  final DateTime? initialDate;
  final DateTime? currentDate;
  final DateTime? selectedDate;
  final ValueChanged<DateTime>? onDateSelected;
  final ValueChanged<DateTime>? onDoubleTap;
  final bool showOkCancel;
  final DateTime minDate;
  final DateTime maxDate;
  final VoidCallback? onLeadingDateTap;
  final TextStyle? daysOfTheWeekTextStyle;
  final TextStyle? enabledCellsTextStyle;
  final BoxDecoration enabledCellsDecoration;
  final TextStyle? disabledCellsTextStyle;
  final BoxDecoration disabledCellsDecoration;
  final TextStyle? currentDateTextStyle;
  final BoxDecoration? currentDateDecoration;
  final TextStyle? selectedCellTextStyle;
  final BoxDecoration? selectedCellDecoration;
  final TextStyle? leadingDateTextStyle;
  final Color? slidersColor;
  final double? slidersSize;
  final Color? splashColor;
  final Color? highlightColor;
  final double? splashRadius;
  final bool centerLeadingDate;
  final String? previousPageSemanticLabel;
  final String? nextPageSemanticLabel;
  final DatePredicate? disabledDayPredicate;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FusionDaysPickerController>(
      init: FusionDaysPickerController(
        minDate: minDate,
        maxDate: maxDate,
        initialDate: initialDate,
        currentDate: currentDate,
        selectedDate: selectedDate,
        onDoubleTap: onDoubleTap,
        daysOfTheWeekTextStyle: daysOfTheWeekTextStyle,
        enabledCellsTextStyle: enabledCellsTextStyle,
        enabledCellsDecoration: enabledCellsDecoration,
        disabledCellsTextStyle: disabledCellsTextStyle,
        disabledCellsDecoration: disabledCellsDecoration,
        currentDateTextStyle: currentDateTextStyle,
        currentDateDecoration: currentDateDecoration,
        selectedCellTextStyle: selectedCellTextStyle,
        selectedCellDecoration: selectedCellDecoration,
        onLeadingDateTap: onLeadingDateTap,
        onDateSelected: onDateSelected,
        leadingDateTextStyle: leadingDateTextStyle,
        slidersColor: slidersColor,
        slidersSize: slidersSize,
        splashColor: splashColor,
        highlightColor: highlightColor,
        splashRadius: splashRadius,
        centerLeadingDate: centerLeadingDate,
        previousPageSemanticLabel: previousPageSemanticLabel,
        nextPageSemanticLabel: nextPageSemanticLabel,
        disabledDayPredicate: disabledDayPredicate,
      ),
      global: false,
      builder: (controller) {
        final ColorScheme colorScheme = Theme.of(context).colorScheme;
        final TextTheme textTheme = Theme.of(context).textTheme;

        final TextStyle daysOfTheWeekTextStyleLocal = daysOfTheWeekTextStyle ??
            textTheme.titleSmall!.copyWith(
              color: colorScheme.onSurface.withValues(alpha:0.30),
              fontWeight: FontWeight.bold,
              fontSize: 14,
            );
        final TextStyle enabledCellsTextStyleLocal = enabledCellsTextStyle ??
            textTheme.titleLarge!.copyWith(
              fontWeight: FontWeight.normal,
              color: colorScheme.onSurface,
            );
        final BoxDecoration enabledCellsDecorationLocal = enabledCellsDecoration;

        final TextStyle disabledCellsTextStyleLocal = disabledCellsTextStyle ??
            textTheme.titleLarge!.copyWith(
              fontWeight: FontWeight.normal,
              color: colorScheme.onSurface.withValues(alpha:0.30),
            );
        final BoxDecoration disabledCellsDecorationLocal = disabledCellsDecoration;

        final TextStyle currentDateTextStyleLocal = currentDateTextStyle ??
            textTheme.titleLarge!.copyWith(
              fontWeight: FontWeight.normal,
              color: colorScheme.primary,
            );
        final BoxDecoration currentDateDecorationLocal = currentDateDecoration ??
            BoxDecoration(
              border: Border.all(color: colorScheme.primary),
              shape: BoxShape.circle,
            );

        final TextStyle selectedCellTextStyleLocal = selectedCellTextStyle ??
            textTheme.titleLarge!.copyWith(
              fontWeight: FontWeight.normal,
              color: colorScheme.onPrimary,
            );
        final BoxDecoration selectedCellDecorationLocal = selectedCellDecoration ??
            BoxDecoration(
              color: colorScheme.primary,
              shape: BoxShape.circle,
            );

        final leadingDateTextStyleLocal = leadingDateTextStyle ??
            TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: colorScheme.primary,
            );
        final slidersColorLocal = slidersColor ?? colorScheme.primary;
        final slidersSizeLocal = slidersSize ?? 20;
        final splashColorLocal = splashColor ??
            selectedCellDecorationLocal.color?.withValues(alpha:0.3) ??
            colorScheme.primary.withValues(alpha:0.3);
        final highlightColorLocal = highlightColor ??
            selectedCellDecorationLocal.color?.withValues(alpha:0.3) ??
            colorScheme.primary.withValues(alpha:0.3);

        return Obx(() {
          final displayedMonth = controller.displayedMonth.value!;
          final selectedDate = controller.selectedDay.value;

          final itemCount = DateUtils.monthDelta(minDate, maxDate) + 1;
          final Size size = MediaQuery.of(context).orientation == Orientation.portrait
              ? const Size(328.0, 402.0)
              : const Size(328.0, 300.0);

          return LimitedBox(
            maxHeight: size.height,
            maxWidth: size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                FusionHeader(
                  centerLeadingDate: centerLeadingDate,
                  leadingDateTextStyle: leadingDateTextStyleLocal,
                  slidersColor: slidersColorLocal,
                  slidersSize: slidersSizeLocal,
                  onDateTap: () => onLeadingDateTap?.call(),
                  displayedDate: MaterialLocalizations.of(context)
                      .formatMonthYear(displayedMonth)
                      .replaceAll('٩', '9')
                      .replaceAll('٨', '8')
                      .replaceAll('٧', '7')
                      .replaceAll('٦', '6')
                      .replaceAll('٥', '5')
                      .replaceAll('٤', '4')
                      .replaceAll('٣', '3')
                      .replaceAll('٢', '2')
                      .replaceAll('١', '1')
                      .replaceAll('٠', '0'),
                  onNextPage: () {
                    final current = controller.pageController.page?.round() ??
                        controller.pageController.initialPage;
                    if (current < itemCount - 1) {
                      controller.pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.ease,
                      );
                    }
                  },
                  onPreviousPage: () {
                    final current = controller.pageController.page?.round() ??
                        controller.pageController.initialPage;
                    if (current > 0) {
                      controller.pageController.previousPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.ease,
                      );
                    }
                  },
                  previousPageSemanticLabel: previousPageSemanticLabel,
                  nextPageSemanticLabel: nextPageSemanticLabel,
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: PageView.builder(
                    scrollDirection: Axis.horizontal,
                    controller: controller.pageController,
                    itemCount: itemCount,
                    onPageChanged: (monthPage) {
                      // Clamp index for robustness.
                      final totalMonths = DateUtils.monthDelta(minDate, maxDate);
                      final clampedPage = monthPage.clamp(0, totalMonths);
                      controller.onPageChanged(clampedPage);
                    },
                    itemBuilder: (context, index) {
                      final DateTime month = DateUtils.addMonthsToMonthDate(minDate, index);
                      return FusionDaysView(
                        key: ValueKey<DateTime>(month),
                        currentDate: DateUtils.dateOnly(currentDate ?? DateTime.now()),
                        maxDate: DateUtils.dateOnly(maxDate),
                        minDate: DateUtils.dateOnly(minDate),
                        displayedMonth: month,
                        selectedDate: selectedDate,
                        daysOfTheWeekTextStyle: daysOfTheWeekTextStyleLocal,
                        enabledCellsTextStyle: enabledCellsTextStyleLocal,
                        enabledCellsDecoration: enabledCellsDecorationLocal,
                        disabledCellsTextStyle: disabledCellsTextStyleLocal,
                        disabledCellsDecoration: disabledCellsDecorationLocal,
                        currentDateDecoration: currentDateDecorationLocal,
                        currentDateTextStyle: currentDateTextStyleLocal,
                        selectedDayDecoration: selectedCellDecorationLocal,
                        selectedDayTextStyle: selectedCellTextStyleLocal,
                        highlightColor: highlightColorLocal,
                        splashColor: splashColorLocal,
                        splashRadius: splashRadius,
                        disabledDayPredicate: disabledDayPredicate,
                        onChanged: controller.onUserSelectedDay,
                        onDoubleTap: controller.onUserDoubleTapDay,
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        });
      },
    );
  }
}