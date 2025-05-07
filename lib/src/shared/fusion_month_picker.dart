import 'package:flutter/material.dart';
import 'package:fusion_date_picker/fusion_date_picker.dart';
import 'package:get/get.dart';
import 'fusion_month_view.dart';

/// Displays a grid of months for a given year and allows the user to select a
/// date.
///
/// Months are arranged in a rectangular grid with one column for each month of the
/// year. Controls are provided to change the year that the grid is
/// showing.
///
/// The month picker widget is rarely used directly. Instead, consider using
/// [showFusionDatePickerDialog], which will create a dialog that uses this.
///
/// See also:
///
///  * [showFusionDatePickerDialog], which creates a Dialog that contains a
///    [DatePicker].
///

class FusionMonthPickerController extends GetxController {
  final DateTime minDate;
  final DateTime maxDate;
  final DateTime? initialDate;
  final DateTime? selectedDate;

  late final PageController pageController;
  final displayedYear = Rxn<DateTime>();
  final selectedMonth = Rxn<DateTime>();

  FusionMonthPickerController({
    required this.minDate,
    required this.maxDate,
    this.initialDate,
    this.selectedDate,
  });

  int get yearsCount => (maxDate.year - minDate.year) + 1;

  @override
  void onInit() {
    final clampedInitialDate = FusionDateUtilsX.clampDateToRange(
      max: maxDate,
      min: minDate,
      date: DateTime.now(),
    );
    // Always clamp and keep the yearOnly for displayedYear
    displayedYear.value = FusionDateUtilsX.yearOnly(initialDate ?? clampedInitialDate);
    selectedMonth.value = selectedDate != null ? FusionDateUtilsX.monthOnly(selectedDate!) : null;
    pageController = PageController(
      initialPage: (displayedYear.value!.year - minDate.year),
    );
    super.onInit();
  }

  void updateDisplayedYear(int yearPage) {
    // Always sync with the actual year from the page index
    displayedYear.value = DateTime(minDate.year + yearPage);
  }

  void jumpToInitialDate(DateTime? newInitialDate) {
    final clampedInitialDate = FusionDateUtilsX.clampDateToRange(
      max: maxDate,
      min: minDate,
      date: DateTime.now(),
    );
    final init = FusionDateUtilsX.yearOnly(newInitialDate ?? clampedInitialDate);
    displayedYear.value = init;
    pageController.jumpToPage(init.year - minDate.year);
  }

  void updateSelectedMonth(DateTime? newSelectedDate) {
    selectedMonth.value = newSelectedDate != null ? FusionDateUtilsX.monthOnly(newSelectedDate) : null;
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}

/// Widget to display a month picker dialog, managed by the above controller.
class FusionMonthPicker extends StatelessWidget {
  final DateTime? initialDate;
  final DateTime? currentDate;
  final DateTime? selectedDate;
  final ValueChanged<DateTime>? onDateSelected;
  final DateTime minDate;
  final DateTime maxDate;
  final VoidCallback? onLeadingDateTap;
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

  const FusionMonthPicker({
    super.key,
    required this.minDate,
    required this.maxDate,
    this.initialDate,
    this.currentDate,
    this.selectedDate,
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
    this.leadingDateTextStyle,
    this.slidersColor,
    this.slidersSize,
    this.highlightColor,
    this.splashColor,
    this.splashRadius,
    this.centerLeadingDate = false,
    this.previousPageSemanticLabel = 'Previous Month',
    this.nextPageSemanticLabel = 'Next Month',
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FusionMonthPickerController>(
      init: FusionMonthPickerController(
        minDate: minDate,
        maxDate: maxDate,
        initialDate: initialDate,
        selectedDate: selectedDate,
      ),
      global: false,
      builder: (controller) {
        final ColorScheme colorScheme = Theme.of(context).colorScheme;
        final TextTheme textTheme = Theme.of(context).textTheme;

        final TextStyle enabledCellsTextStyle = this.enabledCellsTextStyle ??
            textTheme.titleLarge!.copyWith(
              fontWeight: FontWeight.normal,
              color: colorScheme.onSurface,
            );
        final BoxDecoration enabledCellsDecoration = this.enabledCellsDecoration;
        final TextStyle disabledCellsTextStyle = this.disabledCellsTextStyle ??
            textTheme.titleLarge!.copyWith(
              fontWeight: FontWeight.normal,
              color: colorScheme.onSurface.withValues(alpha:0.30),
            );
        final BoxDecoration disabledCellsDecoration = this.disabledCellsDecoration;
        final TextStyle currentDateTextStyle = this.currentDateTextStyle ??
            textTheme.titleLarge!.copyWith(
              fontWeight: FontWeight.normal,
              color: colorScheme.primary,
            );
        final BoxDecoration currentDateDecoration = this.currentDateDecoration ??
            BoxDecoration(
              border: Border.all(color: colorScheme.primary),
              shape: BoxShape.circle,
            );
        final TextStyle selectedCellTextStyle = this.selectedCellTextStyle ??
            textTheme.titleLarge!.copyWith(
              fontWeight: FontWeight.normal,
              color: colorScheme.onPrimary,
            );
        final BoxDecoration selectedCellDecoration = this.selectedCellDecoration ??
            BoxDecoration(
              color: colorScheme.primary,
              shape: BoxShape.circle,
            );
        final leadingDateTextStyle = this.leadingDateTextStyle ??
            TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: colorScheme.primary,
            );
        final slidersColor = this.slidersColor ?? colorScheme.primary;
        final slidersSize = this.slidersSize ?? 20;
        final splashColor = this.splashColor ??
            selectedCellDecoration.color?.withValues(alpha:0.3) ??
            colorScheme.primary.withValues(alpha:0.3);
        final highlightColor = this.highlightColor ??
            selectedCellDecoration.color?.withValues(alpha:0.3) ??
            colorScheme.primary.withValues(alpha:0.3);

        // Handle orientation (use Fallback to MediaQuery for desktop tests)
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
              // --- Header: Title and navigation ---
              Obx(() => FusionHeader(
                previousPageSemanticLabel: previousPageSemanticLabel,
                nextPageSemanticLabel: nextPageSemanticLabel,
                centerLeadingDate: centerLeadingDate,
                leadingDateTextStyle: leadingDateTextStyle,
                slidersColor: slidersColor,
                slidersSize: slidersSize,
                onDateTap: () => onLeadingDateTap?.call(),
                displayedDate: controller.displayedYear.value?.year.toString() ?? '',
                onNextPage: () {
                  // Only go next if not at the last page
                  final current = controller.pageController.page?.round() ??
                      controller.pageController.initialPage;
                  if (current < controller.yearsCount - 1) {
                    controller.pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.ease,
                    );
                  }
                },
                onPreviousPage: () {
                  // Only go back if not at the first page
                  final current = controller.pageController.page?.round() ??
                      controller.pageController.initialPage;
                  if (current > 0) {
                    controller.pageController.previousPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.ease,
                    );
                  }
                },
              )),
              const SizedBox(height: 10),
              // --- Month Pages ---
              Expanded(
                child: PageView.builder(
                  scrollDirection: Axis.horizontal,
                  controller: controller.pageController,
                  itemCount: controller.yearsCount,
                  onPageChanged: (yearPage) {
                    // fix: always update year based on page index, not on DateTime
                    controller.updateDisplayedYear(yearPage);
                  },
                  itemBuilder: (context, index) {
                    final DateTime year = DateTime(
                      minDate.year + index,
                    );
                    return Obx(() => FusionMonthView(
                      key: ValueKey<DateTime>(year),
                      currentDate: currentDate != null
                          ? FusionDateUtilsX.monthOnly(currentDate!)
                          : FusionDateUtilsX.monthOnly(DateTime.now()),
                      maxDate: FusionDateUtilsX.monthOnly(maxDate),
                      minDate: FusionDateUtilsX.monthOnly(minDate),
                      displayedDate: year,
                      selectedDate: controller.selectedMonth.value,
                      enabledCellsDecoration: enabledCellsDecoration,
                      enabledCellsTextStyle: enabledCellsTextStyle,
                      disabledCellsDecoration: disabledCellsDecoration,
                      disabledCellsTextStyle: disabledCellsTextStyle,
                      currentDateDecoration: currentDateDecoration,
                      currentDateTextStyle: currentDateTextStyle,
                      selectedCellDecoration: selectedCellDecoration,
                      selectedCellTextStyle: selectedCellTextStyle,
                      highlightColor: highlightColor,
                      splashColor: splashColor,
                      splashRadius: splashRadius,
                      onChanged: (value) {
                        final selected = FusionDateUtilsX.monthOnly(value);
                        onDateSelected?.call(selected);
                        controller.updateSelectedMonth(selected);
                      },
                    ));
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}