import 'package:flutter/material.dart';
import 'package:fusion_date_picker/fusion_date_picker.dart';


import 'fusion_range_days_view.dart';
class FusionRangeDaysPickerController extends GetxController {
  final FusionRangeDaysPicker widget;
  late Rx<DateTime?> displayedMonth;
  late PageController pageController;

  FusionRangeDaysPickerController(this.widget);

  @override
  void onInit() {
    super.onInit();
    final clampedInitailDate = FusionDateUtilsX.clampDateToRange(
        max: widget.maxDate, min: widget.minDate, date: DateTime.now());
    displayedMonth = DateUtils.dateOnly(widget.initialDate ?? clampedInitailDate).obs;
    pageController = PageController(
      initialPage: DateUtils.monthDelta(widget.minDate, displayedMonth.value!),
    );
  }

  void onPageChanged(int monthPage) {
    final totalMonths = DateUtils.monthDelta(widget.minDate, widget.maxDate);
    final clampedPage = monthPage.clamp(0, totalMonths);
    final DateTime monthDate = DateUtils.addMonthsToMonthDate(widget.minDate, clampedPage);
    displayedMonth.value = monthDate;
  }

  void jumpToInitialPage() {
    final clampedInitailDate = FusionDateUtilsX.clampDateToRange(
      max: widget.maxDate,
      min: widget.minDate,
      date: DateTime.now(),
    );
    displayedMonth.value = DateUtils.dateOnly(widget.initialDate ?? clampedInitailDate);
    pageController.jumpToPage(
      DateUtils.monthDelta(widget.minDate, displayedMonth.value!),
    );
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}

class FusionRangeDaysPicker extends StatefulWidget {
  FusionRangeDaysPicker({
    super.key,
    required this.minDate,
    required this.maxDate,
    this.initialDate,
    this.currentDate,
    this.selectedStartDate,
    this.selectedEndDate,
    this.daysOfTheWeekTextStyle,
    this.enabledCellsTextStyle,
    this.enabledCellsDecoration = const BoxDecoration(),
    this.disabledCellsTextStyle,
    this.disabledCellsDecoration = const BoxDecoration(),
    this.currentDateTextStyle,
    this.currentDateDecoration,
    this.selectedCellsTextStyle,
    this.selectedCellsDecoration,
    this.singleSelectedCellTextStyle,
    this.singleSelectedCellDecoration,
    this.onLeadingDateTap,
    this.onStartDateChanged,
    this.onEndDateChanged,
    this.leadingDateTextStyle,
    this.slidersColor,
    this.slidersSize,
    this.highlightColor,
    this.splashColor,
    this.splashRadius,
    this.centerLeadingDate = false,
    this.previousPageSemanticLabel = 'Previous Day',
    this.nextPageSemanticLabel = 'Next Day',
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
  final DateTime? selectedStartDate;
  final DateTime? selectedEndDate;
  final ValueChanged<DateTime>? onStartDateChanged;
  final ValueChanged<DateTime>? onEndDateChanged;
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
  final TextStyle? selectedCellsTextStyle;
  final BoxDecoration? selectedCellsDecoration;
  final TextStyle? singleSelectedCellTextStyle;
  final BoxDecoration? singleSelectedCellDecoration;
  final TextStyle? leadingDateTextStyle;
  final Color? slidersColor;
  final double? slidersSize;
  final Color? splashColor;
  final Color? highlightColor;
  final double? splashRadius;
  final bool centerLeadingDate;
  final String? previousPageSemanticLabel;
  final String? nextPageSemanticLabel;

  @override
  State<FusionRangeDaysPicker> createState() => _RangeDaysPickerGetXState();
}

class _RangeDaysPickerGetXState extends State<FusionRangeDaysPicker> {
  late final FusionRangeDaysPickerController controller;
  final GlobalKey _pageViewKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    controller = FusionRangeDaysPickerController(widget);
    controller.onInit();
  }

  @override
  void didUpdateWidget(covariant FusionRangeDaysPicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialDate != widget.initialDate) {
      controller.jumpToInitialPage();
    }
  }

  @override
  void dispose() {
    controller.onClose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;

    final TextStyle daysOfTheWeekTextStyle = widget.daysOfTheWeekTextStyle ??
        textTheme.titleSmall!.copyWith(
          color: colorScheme.onSurface.withValues(alpha :0.30),
          fontWeight: FontWeight.bold,
          fontSize: 14,
        );
    final TextStyle enabledCellsTextStyle = widget.enabledCellsTextStyle ??
        textTheme.titleLarge!.copyWith(
          fontWeight: FontWeight.normal,
          color: colorScheme.onSurface,
        );
    final BoxDecoration enabledCellsDecoration = widget.enabledCellsDecoration;

    final TextStyle disabledCellsTextStyle = widget.disabledCellsTextStyle ??
        textTheme.titleLarge!.copyWith(
          fontWeight: FontWeight.normal,
          color: colorScheme.onSurface.withValues(alpha:0.30),
        );
    final BoxDecoration disbaledCellsDecoration = widget.disabledCellsDecoration;

    final TextStyle currentDateTextStyle = widget.currentDateTextStyle ??
        textTheme.titleLarge!.copyWith(
          fontWeight: FontWeight.normal,
          color: colorScheme.primary,
        );

    final BoxDecoration currentDateDecoration = widget.currentDateDecoration ??
        BoxDecoration(
          border: Border.all(color: colorScheme.primary),
          shape: BoxShape.circle,
        );

    final TextStyle selectedCellsTextStyle = widget.selectedCellsTextStyle ??
        textTheme.titleLarge!.copyWith(
          fontWeight: FontWeight.normal,
          color: colorScheme.onPrimaryContainer,
        );

    final BoxDecoration selectedCellsDecoration = widget.selectedCellsDecoration ??
        BoxDecoration(
          color: colorScheme.primaryContainer,
          shape: BoxShape.rectangle,
        );

    final TextStyle singleSelectedCellTextStyle = widget.singleSelectedCellTextStyle ??
        textTheme.titleLarge!.copyWith(
          fontWeight: FontWeight.normal,
          color: colorScheme.onPrimary,
        );

    final BoxDecoration singleSelectedCellDecoration = widget.singleSelectedCellDecoration ??
        BoxDecoration(
          color: colorScheme.primary,
          shape: BoxShape.circle,
        );

    final leadingDateTextStyle = widget.leadingDateTextStyle ??
        TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: colorScheme.primary,
        );
    final slidersColor = widget.slidersColor ?? colorScheme.primary;
    final slidersSize = widget.slidersSize ?? 20;

    final splashColor = widget.splashColor ?? singleSelectedCellDecoration.color?.withValues(alpha:0.3) ?? colorScheme.primary.withValues(alpha:0.3);
    final highlightColor = widget.highlightColor ?? singleSelectedCellDecoration.color?.withValues(alpha:0.3) ?? colorScheme.primary.withValues(alpha:0.3);

    return Obx(() {
      final displayedMonth = controller.displayedMonth.value!;

      return DeviceOrientationBuilder(builder: (context, o) {
        late final Size size;
        switch (o) {
          case Orientation.portrait:
            size = const Size(328.0, 402.0);
            break;
          case Orientation.landscape:
            size = const Size(328.0, 300.0);
            break;
        }

        return LimitedBox(
          maxHeight: size.height,
          maxWidth: size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              FusionHeader(
                previousPageSemanticLabel: widget.previousPageSemanticLabel,
                nextPageSemanticLabel: widget.nextPageSemanticLabel,
                centerLeadingDate: widget.centerLeadingDate,
                leadingDateTextStyle: leadingDateTextStyle,
                slidersColor: slidersColor,
                slidersSize: slidersSize,
                onDateTap: () => widget.onLeadingDateTap?.call(),
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
                  controller.pageController.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.ease,
                  );
                },
                onPreviousPage: () {
                  controller.pageController.previousPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.ease,
                  );
                },
              ),
              const SizedBox(height: 10),
              Expanded(
                child: PageView.builder(
                  scrollDirection: Axis.horizontal,
                  key: _pageViewKey,
                  controller: controller.pageController,
                  itemCount: DateUtils.monthDelta(widget.minDate, widget.maxDate) + 1,
                  onPageChanged: controller.onPageChanged,
                  itemBuilder: (context, index) {
                    final DateTime month = DateUtils.addMonthsToMonthDate(widget.minDate, index);

                    return FusionRangeDaysView(
                      key: ValueKey<DateTime>(month),
                      currentDate: DateUtils.dateOnly(widget.currentDate ?? DateTime.now()),
                      minDate: DateUtils.dateOnly(widget.minDate),
                      maxDate: DateUtils.dateOnly(widget.maxDate),
                      displayedMonth: month,
                      selectedEndDate: widget.selectedEndDate == null
                          ? null
                          : DateUtils.dateOnly(widget.selectedEndDate!),
                      selectedStartDate: widget.selectedStartDate == null
                          ? null
                          : DateUtils.dateOnly(widget.selectedStartDate!),
                      daysOfTheWeekTextStyle: daysOfTheWeekTextStyle,
                      enabledCellsTextStyle: enabledCellsTextStyle,
                      enabledCellsDecoration: enabledCellsDecoration,
                      disabledCellsTextStyle: disabledCellsTextStyle,
                      disabledCellsDecoration: disbaledCellsDecoration,
                      currentDateDecoration: currentDateDecoration,
                      currentDateTextStyle: currentDateTextStyle,
                      selectedCellsDecoration: selectedCellsDecoration,
                      selectedCellsTextStyle: selectedCellsTextStyle,
                      singleSelectedCellTextStyle: singleSelectedCellTextStyle,
                      singleSelectedCellDecoration: singleSelectedCellDecoration,
                      highlightColor: highlightColor,
                      splashColor: splashColor,
                      splashRadius: widget.splashRadius,
                      onEndDateChanged: (value) => widget.onEndDateChanged?.call(value),
                      onStartDateChanged: (value) => widget.onStartDateChanged?.call(value),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      });
    });
  }
}

