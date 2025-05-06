import 'package:flutter/material.dart';

import 'fusion_year_view.dart';
import 'package:fusion_date_picker/fusion_date_picker.dart';


class FusionYearsPickerController extends GetxController {
  final DateTime minDate;
  final DateTime maxDate;
  final DateTime? initialDate;
  final DateTime? selectedDate;

  late final PageController pageController;
  final displayedRange = Rxn<DateTimeRange>();
  final selectedYear = Rxn<DateTime>();

  FusionYearsPickerController({
    required this.minDate,
    required this.maxDate,
    this.initialDate,
    this.selectedDate,
  });

  static const int yearsPerPage = 12;

  int get pageCount => ((maxDate.year - minDate.year + 1) / yearsPerPage).ceil();

  // Returns the page index for a given initial/current date.
  int get initialPageNumber {
    final clampedInit = FusionDateUtilsX.clampDateToRange(
        max: maxDate, min: minDate, date: DateTime.now());
    final DateTime init = initialDate ?? clampedInit;
    final int page = ((init.year - minDate.year + 1) / yearsPerPage).ceil() - 1;
    return page < 0 ? 0 : page;
  }

  DateTimeRange calculateDateRange(int pageIndex) {
    return DateTimeRange(
      start: DateTime(minDate.year + pageIndex * yearsPerPage),
      end: DateTime(minDate.year + pageIndex * yearsPerPage + yearsPerPage - 1),
    );
  }

  @override
  void onInit() {
    pageController = PageController(initialPage: initialPageNumber);

    displayedRange.value = calculateDateRange(initialPageNumber);

    selectedYear.value = selectedDate != null
        ? FusionDateUtilsX.yearOnly(selectedDate!)
        : null;

    super.onInit();
  }

  void updateDisplayedRange(int pageIndex) {
    displayedRange.value = calculateDateRange(pageIndex);
  }

  void jumpToInitialPage(DateTime? newInitialDate) {
    final clampedInit = FusionDateUtilsX.clampDateToRange(
        max: maxDate, min: minDate, date: DateTime.now());
    final init = newInitialDate ?? clampedInit;
    final int page = ((init.year - minDate.year + 1) / yearsPerPage).ceil() - 1;
    final int pageNum = page < 0 ? 0 : page;
    pageController.jumpToPage(pageNum);
    displayedRange.value = calculateDateRange(pageNum);
  }

  void updateSelectedYear(DateTime? newSelectedDate) {
    selectedYear.value = newSelectedDate != null ? FusionDateUtilsX.yearOnly(newSelectedDate) : null;
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}

class FusionYearsPicker extends StatelessWidget {
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

  const FusionYearsPicker({
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
    this.previousPageSemanticLabel = 'Previous Year',
    this.nextPageSemanticLabel = 'Next Year',
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FusionYearsPickerController>(
      init: FusionYearsPickerController(
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
              // --- Header updates with displayed range ---
              Obx(() {
                final range = controller.displayedRange.value;
                return FusionHeader(
                  previousPageSemanticLabel: previousPageSemanticLabel,
                  nextPageSemanticLabel: nextPageSemanticLabel,
                  centerLeadingDate: centerLeadingDate,
                  leadingDateTextStyle: leadingDateTextStyle,
                  slidersColor: slidersColor,
                  slidersSize: slidersSize,
                  onDateTap: () => onLeadingDateTap?.call(),
                  displayedDate:
                  (range != null)
                      ? '${range.start.year} - ${range.end.year}'
                      : '',
                  onNextPage: () {
                    final current = controller.pageController.page?.round() ??
                        controller.pageController.initialPage;
                    if (current < controller.pageCount - 1) {
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
                );
              }),
              const SizedBox(height: 10),
              Flexible(
                child: PageView.builder(
                  scrollDirection: Axis.horizontal,
                  controller: controller.pageController,
                  itemCount: controller.pageCount,
                  onPageChanged: (yearPage) {
                    controller.updateDisplayedRange(yearPage);
                  },
                  itemBuilder: (context, index) {
                    final yearRange = controller.calculateDateRange(index);

                    return Obx(() =>
                        FusionYearView(
                          key: ValueKey<DateTimeRange>(yearRange),
                          currentDate: currentDate != null
                              ? FusionDateUtilsX.yearOnly(currentDate!)
                              : FusionDateUtilsX.yearOnly(DateTime.now()),
                          maxDate: FusionDateUtilsX.yearOnly(maxDate),
                          minDate: FusionDateUtilsX.yearOnly(minDate),
                          displayedYearRange: yearRange,
                          selectedDate: controller.selectedYear.value,
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
                            final selected = FusionDateUtilsX.yearOnly(value);
                            onDateSelected?.call(selected);
                            controller.updateSelectedYear(selected);
                          },
                        )
                    );
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

