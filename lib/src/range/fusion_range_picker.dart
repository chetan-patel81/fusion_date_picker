import 'package:flutter/material.dart';

import 'package:fusion_date_picker/fusion_date_picker.dart';
import 'fusion_range_days_picker.dart';
import 'package:get/get.dart';
class FusionRangeDatePickerController extends GetxController {
  final FusionRangeDatePicker widget;

  late Rx<PickerType> pickerType;
  late Rx<DateTime?> displayedDate;
  late Rx<DateTime?> selectedStartDate;
  late Rx<DateTime?> selectedEndDate;

  FusionRangeDatePickerController(this.widget);

  DateTime get _initialClampedDate {
    final nowClamped = FusionDateUtilsX.clampDateToRange(
      max: widget.maxDate,
      min: widget.minDate,
      date: DateTime.now(),
    );
    return widget.initialDate ?? nowClamped;
  }

  @override
  void onInit() {
    pickerType = widget.initialPickerType.obs;
    displayedDate = DateUtils.dateOnly(_initialClampedDate).obs;
    if (widget.selectedRange != null) {
      selectedStartDate = DateUtils.dateOnly(widget.selectedRange!.start).obs;
      selectedEndDate = DateUtils.dateOnly(widget.selectedRange!.end).obs;
    } else {
      selectedStartDate = Rx<DateTime?>(null);
      selectedEndDate = Rx<DateTime?>(null);
    }
    super.onInit();
  }

  void updatePickerType(PickerType type) {
    pickerType.value = type;
  }

  void updateDisplayedDate(DateTime date) {
    displayedDate.value = date;
  }

  void updateSelectedStartDate(DateTime? date) {
    selectedStartDate.value = date;
    // If starting selection over, clear end date
    selectedEndDate.value = null;
  }

  void updateSelectedEndDate(DateTime? date) {
    selectedEndDate.value = date;
  }

  void updateFromWidget(FusionRangeDatePicker oldWidget, FusionRangeDatePicker newWidget) {
    if (oldWidget.initialPickerType != newWidget.initialPickerType) {
      pickerType.value = newWidget.initialPickerType;
    }

    if (oldWidget.selectedRange != newWidget.selectedRange) {
      if (newWidget.selectedRange == null) {
        selectedStartDate.value = null;
        selectedEndDate.value = null;
      } else {
        selectedStartDate.value =
            DateUtils.dateOnly(newWidget.selectedRange!.start);
        selectedEndDate.value =
            DateUtils.dateOnly(newWidget.selectedRange!.end);
      }
    }

    if (oldWidget.initialDate != newWidget.initialDate) {
      final clampedInitialDate = FusionDateUtilsX.clampDateToRange(
        max: newWidget.maxDate,
        min: newWidget.minDate,
        date: DateTime.now(),
      );
      displayedDate.value =
          DateUtils.dateOnly(newWidget.initialDate ?? clampedInitialDate);
    }
  }
}
/// Displays a grid of days for a given month and allows the user to select a
/// range of dates.
///
/// Days are arranged in a rectangular grid with one column for each day of the
/// week. Controls are provided to change the year and month that the grid is
/// showing.
///
/// The range picker widget is rarely used directly. Instead, consider using
/// [showRangeDatePickerDialog], which will create a dialog that uses this.
///
/// See also:
///
///  * [showRangeDatePickerDialog], which creates a Dialog that contains a
///    [FusionRangeDatePicker].
///
class FusionRangeDatePicker extends StatefulWidget {
  /// Creates a calendar range picker.
  ///
  /// It will display a grid of days for the [initialDate]'s month. If [initialDate]
  /// is null, `DateTime.now()` will be used. If `DateTime.now()` does not fall within
  /// the valid range of [minDate] and [maxDate], it will fall back to the nearest
  /// valid date from `DateTime.now()`, selecting the [maxDate] if `DateTime.now()` is
  /// after the valid range, or [minDate] if before.
  ///
  /// The day indicated by [selectedRange] will be selected if provided.
  ///
  /// The optional [onRangeSelected] callback will be called if provided
  /// when a range is selected.
  ///
  /// The user interface provides a way to change the year and the month being
  /// displayed. By default it will show the day grid, but this can be changed
  /// with [initialPickerType].
  ///
  /// The [minDate] is the earliest allowable date. The [maxDate] is the latest
  /// allowable date. [initialDate] and [selectedRange] must either fall between
  /// these dates, or be equal to one of them.
  ///
  /// The [currentDate] represents the current day (i.e. today). This
  /// date will be highlighted in the day grid. If null, the date of
  /// `DateTime.now()` will be used.
  ///
  /// For each of these [DateTime] parameters, only
  /// their dates are considered. Their time fields are ignored.
  FusionRangeDatePicker({
    super.key,
    required this.maxDate,
    required this.minDate,
    this.onRangeSelected,
    this.onLeadingDateTap,
    this.onStartDateChanged,
    this.onEndDateChanged,
    this.currentDate,
    this.initialDate,
    this.selectedRange,
    this.padding = const EdgeInsets.all(16),
    this.initialPickerType = PickerType.days,
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
    this.leadingDateTextStyle,
    this.slidersColor,
    this.slidersSize,
    this.highlightColor,
    this.splashColor,
    this.splashRadius,
    this.centerLeadingDate = false,
    this.previousPageSemanticLabel,
    this.nextPageSemanticLabel,
  }) {
    assert(!minDate.isAfter(maxDate), "minDate can't be after maxDate");
  }

  /// The initially selected date range when the picker is first opened.
  /// If the specified range contains the [initialDate], that range will be selected.
  ///
  /// Note that only dates are considered. time fields are ignored.
  final DateTimeRange? selectedRange;

  /// The date to which the picker will consider as current date. e.g (today).
  /// If not specified, the picker will default to today's date.
  ///
  /// Note that only dates are considered. time fields are ignored.
  final DateTime? currentDate;

  /// The date which will be displayed on first opening. If not specified, the picker
  /// will default to `DateTime.now()`. If `DateTime.now()` does not fall within the
  /// valid range of [minDate] and [maxDate], it will automatically adjust to the nearest
  /// valid date, selecting [maxDate] if `DateTime.now()` is after the valid range, or
  /// [minDate] if it is before.
  ///
  /// Note that only dates are considered. time fields are ignored.
  final DateTime? initialDate;

  /// Called when the user picks a range.
  final ValueChanged<DateTimeRange>? onRangeSelected;

  /// Called when the user selects between months/years/days
  final VoidCallback? onLeadingDateTap;

  /// Called when the user picks a new start date to the range
  final ValueChanged<DateTime>? onStartDateChanged;

  /// Called when the user picks an end date to the range
  final ValueChanged<DateTime>? onEndDateChanged;

  /// The earliest date the user is permitted to pick.
  ///
  /// This date must be on or before the [maxDate].
  ///
  /// Note that only dates are considered. time fields are ignored.
  final DateTime minDate;

  /// The latest date the user is permitted to pick.
  ///
  /// This date must be on or after the [minDate].
  ///
  /// Note that only dates are considered. time fields are ignored.
  final DateTime maxDate;

  /// The initial display of the calendar picker.
  final PickerType initialPickerType;

  /// The amount of padding to be added around the [DatePicker].
  final EdgeInsets padding;

  /// The text style of the week days name in the header.
  ///
  /// defaults to [TextTheme.titleSmall] with a [FontWeight.bold],
  /// a `14` font size, and a [ColorScheme.onSurface] with 30% opacity.
  final TextStyle? daysOfTheWeekTextStyle;

  /// The text style of cells which are selectable.
  ///
  /// defaults to [TextTheme.titleLarge] with a [FontWeight.normal]
  /// and [ColorScheme.onSurface] color.
  final TextStyle? enabledCellsTextStyle;

  /// The cell decoration of cells which are selectable.
  ///
  /// defaults to empty [BoxDecoration].
  final BoxDecoration enabledCellsDecoration;

  /// The text style of cells which are not selectable.
  ///
  /// defaults to [TextTheme.titleLarge] with a [FontWeight.normal]
  /// and [ColorScheme.onSurface] color with 30% opacity.
  final TextStyle? disabledCellsTextStyle;

  /// The cell decoration of cells which are not selectable.
  ///
  /// defaults to empty [BoxDecoration].
  final BoxDecoration disabledCellsDecoration;

  /// The text style of the current date.
  ///
  /// defaults to [TextTheme.titleLarge] with a [FontWeight.normal]
  /// and [ColorScheme.primary] color.
  ///
  /// ### Note:
  /// If [currentDate] is within the selected range this will
  /// be override by [selectedCellsTextStyle]
  final TextStyle? currentDateTextStyle;

  /// The cell decoration of the current date.
  ///
  /// defaults to circle stroke border with [ColorScheme.primary] color.
  ///
  /// ### Note:
  /// If [currentDate] is within the selected range this will
  /// be override by [selectedCellsDecoration]
  final BoxDecoration? currentDateDecoration;

  /// The text style of selected cells within the range.
  ///
  /// defaults to [TextTheme.titleLarge] with a [FontWeight.normal]
  /// and [ColorScheme.onPrimaryContainer] color.
  final TextStyle? selectedCellsTextStyle;

  /// The cell decoration of selected cells within the range.
  ///
  /// defaults to circle with [ColorScheme.primaryContainer] color.
  final BoxDecoration? selectedCellsDecoration;

  /// The text style for a cell representing:
  ///
  /// 1. A single cell when initially selected.
  /// 2. The leading/trailing cell of a selected range.
  ///
  /// defaults to [TextTheme.titleLarge] with a [FontWeight.normal]
  /// and [ColorScheme.onPrimary] color
  final TextStyle? singleSelectedCellTextStyle;

  /// The decoration for a cell representing:
  ///
  /// 1. A single cell when initially selected.
  /// 2. The leading/trailing cell of a selected range.
  ///
  /// If not provided, `singleSelectedCellDecoration` is a circle with the color specified
  /// in `selectedCellsDecoration`, using [ColorScheme.primary].
  final BoxDecoration? singleSelectedCellDecoration;

  /// The text style of leading date showing in the header.
  ///
  /// defaults to `18px` with a [FontWeight.bold]
  /// and [ColorScheme.primary] color.
  final TextStyle? leadingDateTextStyle;

  /// The color of the page sliders.
  ///
  /// defaults to [ColorScheme.primary] color.
  final Color? slidersColor;

  /// The size of the page sliders.
  ///
  /// defaults to `20px`.
  final double? slidersSize;

  /// The splash color of the ink response.
  ///
  /// defaults to the color of [selectedCellsDecoration],
  /// if null will fall back to [ColorScheme.onPrimary] with 30% opacity.
  final Color? splashColor;

  /// The highlight color of the ink response when pressed.
  ///
  /// defaults to the color of [selectedCellsDecoration],
  /// if null will fall back to [ColorScheme.onPrimary] with 30% opacity.
  final Color? highlightColor;

  /// The radius of the ink splash.
  final double? splashRadius;

  /// Centring the leading date. e.g:
  ///
  /// <       December 2023      >
  ///
  final bool centerLeadingDate;

  /// Semantic label for button to go to the previous page.
  ///
  /// defaults to `Previous Day/Month/Year` according to picker type.
  final String? previousPageSemanticLabel;

  /// Semantic label for button to go to the next page.
  ///
  /// defaults to `Next Day/Month/Year` according to picker type.
  final String? nextPageSemanticLabel;

  @override
  State<FusionRangeDatePicker> createState() => _FusionRangeDatePickerState();
}

class _FusionRangeDatePickerState extends State<FusionRangeDatePicker> {
  late final FusionRangeDatePickerController controller;

  @override
  void initState() {
    super.initState();
    controller = FusionRangeDatePickerController(widget);
    controller.onInit();
  }

  @override
  void didUpdateWidget(covariant FusionRangeDatePicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    controller.updateFromWidget(oldWidget, widget);
  }
  @override
  Widget build(BuildContext context) {
  return  Obx(() {
      final pickerType = controller.pickerType.value;
      final displayedDate = controller.displayedDate.value;
      final selectedStartDate = controller.selectedStartDate.value;
      final selectedEndDate = controller.selectedEndDate.value;
    switch (pickerType) {
      case PickerType.days:
        return Padding(
          padding: widget.padding,
          child: FusionRangeDaysPicker(
            centerLeadingDate: widget.centerLeadingDate,
            currentDate:
                DateUtils.dateOnly(widget.currentDate ?? DateTime.now()),
            initialDate: displayedDate,
            selectedEndDate: selectedEndDate,
            selectedStartDate: selectedStartDate,
            maxDate: DateUtils.dateOnly(widget.maxDate),
            minDate: DateUtils.dateOnly(widget.minDate),
            daysOfTheWeekTextStyle: widget.daysOfTheWeekTextStyle,
            enabledCellsTextStyle: widget.enabledCellsTextStyle,
            enabledCellsDecoration: widget.enabledCellsDecoration,
            disabledCellsTextStyle: widget.disabledCellsTextStyle,
            disabledCellsDecoration: widget.disabledCellsDecoration,
            currentDateDecoration: widget.currentDateDecoration,
            currentDateTextStyle: widget.currentDateTextStyle,
            selectedCellsDecoration: widget.selectedCellsDecoration,
            selectedCellsTextStyle: widget.selectedCellsTextStyle,
            singleSelectedCellTextStyle: widget.singleSelectedCellTextStyle,
            singleSelectedCellDecoration: widget.singleSelectedCellDecoration,
            slidersColor: widget.slidersColor,
            slidersSize: widget.slidersSize,
            leadingDateTextStyle: widget.leadingDateTextStyle,
            splashColor: widget.splashColor,
            highlightColor: widget.highlightColor,
            splashRadius: widget.splashRadius,
            previousPageSemanticLabel: widget.previousPageSemanticLabel,
            nextPageSemanticLabel: widget.nextPageSemanticLabel,
            onLeadingDateTap: () {
              controller.updatePickerType(PickerType.months);
              widget.onLeadingDateTap?.call();
            },
            onEndDateChanged: (date) {
              controller.updateSelectedEndDate(date);
              widget.onEndDateChanged?.call(date);
              if (controller.selectedStartDate.value != null) {
                widget.onRangeSelected?.call(DateTimeRange(
                  start: controller.selectedStartDate.value!,
                  end: controller.selectedEndDate.value!,
                ));
              }
            },
            onStartDateChanged: (date) {
              controller.updateSelectedStartDate(date);
              widget.onStartDateChanged?.call(date);
            },
          ),
        );
      case PickerType.months:
        return Padding(
          padding: widget.padding,
          child: FusionMonthPicker(
            centerLeadingDate: widget.centerLeadingDate,
            initialDate: displayedDate,
            selectedDate: null,
            maxDate: DateUtils.dateOnly(widget.maxDate),
            minDate: DateUtils.dateOnly(widget.minDate),
            currentDate:
                DateUtils.dateOnly(widget.currentDate ?? DateTime.now()),
            currentDateDecoration: widget.currentDateDecoration,
            currentDateTextStyle: widget.currentDateTextStyle,
            disabledCellsDecoration: widget.disabledCellsDecoration,
            disabledCellsTextStyle: widget.disabledCellsTextStyle,
            enabledCellsDecoration: widget.enabledCellsDecoration,
            enabledCellsTextStyle: widget.enabledCellsTextStyle,
            selectedCellDecoration: widget.singleSelectedCellDecoration,
            selectedCellTextStyle: widget.singleSelectedCellTextStyle,
            slidersColor: widget.slidersColor,
            slidersSize: widget.slidersSize,
            leadingDateTextStyle: widget.leadingDateTextStyle,
            splashColor: widget.splashColor,
            highlightColor: widget.highlightColor,
            splashRadius: widget.splashRadius,
            previousPageSemanticLabel: widget.previousPageSemanticLabel,
            nextPageSemanticLabel: widget.nextPageSemanticLabel,
            onLeadingDateTap: () {
              controller.updatePickerType(PickerType.years);
            },
            onDateSelected: (selectedMonth) {
              final clampedSelectedMonth = FusionDateUtilsX.clampDateToRange(
                min: widget.minDate,
                max: widget.maxDate,
                date: selectedMonth,
              );
              controller.updateDisplayedDate(clampedSelectedMonth);
              controller.updatePickerType(PickerType.days);
            },
          ),
        );
      case PickerType.years:
        return Padding(
          padding: widget.padding,
          child: FusionYearsPicker(
            centerLeadingDate: widget.centerLeadingDate,
            selectedDate: null,
            initialDate: displayedDate,
            maxDate: DateUtils.dateOnly(widget.maxDate),
            minDate: DateUtils.dateOnly(widget.minDate),
            currentDate:
                DateUtils.dateOnly(widget.currentDate ?? DateTime.now()),
            currentDateDecoration: widget.currentDateDecoration,
            currentDateTextStyle: widget.currentDateTextStyle,
            disabledCellsDecoration: widget.disabledCellsDecoration,
            disabledCellsTextStyle: widget.disabledCellsTextStyle,
            enabledCellsDecoration: widget.enabledCellsDecoration,
            enabledCellsTextStyle: widget.enabledCellsTextStyle,
            selectedCellDecoration: widget.singleSelectedCellDecoration,
            selectedCellTextStyle: widget.singleSelectedCellTextStyle,
            slidersColor: widget.slidersColor,
            slidersSize: widget.slidersSize,
            leadingDateTextStyle: widget.leadingDateTextStyle,
            splashColor: widget.splashColor,
            highlightColor: widget.highlightColor,
            splashRadius: widget.splashRadius,
            previousPageSemanticLabel: widget.previousPageSemanticLabel,
            nextPageSemanticLabel: widget.nextPageSemanticLabel,
            onDateSelected: (selectedYear) {
              final clampedSelectedYear = FusionDateUtilsX.clampDateToRange(
                min: widget.minDate,
                max: widget.maxDate,
                date: selectedYear,
              );
              controller.updateDisplayedDate(clampedSelectedYear);
              controller.updatePickerType(PickerType.months);
            },
          ),
        );}
    });
  }
}
