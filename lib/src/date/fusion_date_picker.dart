import 'package:flutter/material.dart';
import 'package:fusion_date_picker/fusion_date_picker.dart';

import 'package:get/get.dart';

class FusionDatePickerController extends GetxController {
  late Rx<PickerType> pickerType;
  late Rx<DateTime?> displayedDate;
  late Rx<DateTime?> selectedDate;

  final FusionDatePicker widget;

  FusionDatePickerController(this.widget);

  /// Returns either the widget's initialDate or today's date clamped between minDate and maxDate.
  DateTime get _initialClampedDate {
    final nowClamped = FusionDateUtilsX.clampDateToRange(max: widget.maxDate, min: widget.minDate, date: DateTime.now());
    return widget.initialDate ?? nowClamped;
  }

  @override
  void onInit() {
    // Ensure displayedDate is normalized (date-only) and within allowed range.
    displayedDate = DateUtils.dateOnly(_initialClampedDate).obs;
    pickerType = widget.initialPickerType.obs;
    selectedDate = (widget.selectedDate != null ? DateUtils.dateOnly(widget.selectedDate!) : null).obs;
    super.onInit();
  }

  /// Set currently displayed (navigated-to) date.
  void updateDisplayedDate(DateTime date) {
    displayedDate.value = date;
  }

  /// Set currently selected date.
  void updateSelectedDate(DateTime? date) {
    selectedDate.value = date;
  }

  /// Set picker display type (days/months/years).
  void updatePickerType(PickerType type) {
    pickerType.value = type;
  }

  /// Reset displayed date to initial or default value.
  void resetDisplayedDate() {
    displayedDate.value = DateUtils.dateOnly(_initialClampedDate);
  }

  /// Update the controller whenever the widget is rebuilt with new parameters.
  /// Handles changed initialDate, pickerType or selectedDate.
  void updateFromWidget(FusionDatePicker oldWidget, FusionDatePicker newWidget) {
    final bool initialDateChanged = oldWidget.initialDate != newWidget.initialDate;
    final bool pickerTypeChanged = oldWidget.initialPickerType != newWidget.initialPickerType;
    final bool selectedDateChanged = oldWidget.selectedDate != newWidget.selectedDate;

    if (initialDateChanged) {
      resetDisplayedDate();
    }
    if (pickerTypeChanged) {
      pickerType.value = newWidget.initialPickerType;
    }
    if (selectedDateChanged) {
      selectedDate.value = (newWidget.selectedDate != null ? DateUtils.dateOnly(newWidget.selectedDate!) : null);
    }
  }
}

/// Calendar Date Picker using GetX for state management
class FusionDatePicker extends StatefulWidget {
  /// ... All your existing documentation ...
  FusionDatePicker({
    super.key,
    required this.maxDate,
    required this.minDate,
    this.onDateSelected,
    this.initialDate,
    this.selectedDate,
    this.currentDate,
    this.padding = const EdgeInsets.all(16),
    this.initialPickerType = PickerType.days,
    this.daysOfTheWeekTextStyle,
    this.enabledCellsTextStyle,
    this.enabledCellsDecoration = const BoxDecoration(),
    this.disabledCellsTextStyle,
    this.disabledCellsDecoration = const BoxDecoration(),
    this.currentDateTextStyle,
    this.currentDateDecoration,
    this.selectedCellTextStyle,
    this.selectedCellDecoration,
    this.leadingDateTextStyle,
    this.slidersColor,
    this.slidersSize,
    this.highlightColor,
    this.splashColor,
    this.splashRadius,
    this.centerLeadingDate = false,
    this.previousPageSemanticLabel,
    this.nextPageSemanticLabel,
    this.disabledDayPredicate,
    this.onOk,
    this.onCancel,
    this.showOkCancel = true,
  }) {
    assert(!minDate.isAfter(maxDate), "minDate can't be after maxDate");
  }

  final DateTime? initialDate;
  final DateTime? currentDate;
  final DateTime? selectedDate;
  final ValueChanged<DateTime>? onDateSelected;
  final DateTime minDate;
  final DateTime maxDate;
  final PickerType initialPickerType;
  final EdgeInsets padding;
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
  final VoidCallback? onOk; // Callback for OK button
  final VoidCallback? onCancel; // Callback for Cancel button
  final bool showOkCancel; // Control to show/hide buttons

  @override
  State<FusionDatePicker> createState() => _DatePickerGetXState();
}

class _DatePickerGetXState extends State<FusionDatePicker> {
  late final FusionDatePickerController controller;

  @override
  void initState() {
    super.initState();
    controller = FusionDatePickerController(widget);
    controller.onInit();
  }

  @override
  void didUpdateWidget(covariant FusionDatePicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    controller.updateFromWidget(oldWidget, widget);
  }

  // Double tap: Confirm selection immediately.
  void _handleDoubleTap(DateTime date) {
    controller.updateDisplayedDate(date);
    controller.updateSelectedDate(date);
    widget.onDateSelected?.call(date);
    widget.onOk?.call();
  }

  // Single tap: only update controller state, wait for OK.
  void _handleSingleTap(DateTime date) {
    controller.updateDisplayedDate(date);
    controller.updateSelectedDate(date);
    // No callbacks here!
  }

  // OK button: Confirm selection from controller and call callbacks.
  void _handleOk() {
    final picked = controller.selectedDate.value;
    if (picked != null) {
      widget.onDateSelected?.call(picked);
    }
    widget.onOk?.call();
  }

  // Cancel button: Discard tentative selection and call cancel callback.
  void _handleCancel() {
    // Optional: Clear selection in controller (depends on your UI/UX).
    controller.updateSelectedDate(null);
    widget.onCancel?.call();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final pickerType = controller.pickerType.value;
      final displayedDate = controller.displayedDate.value;
      final selectedDate = controller.selectedDate.value;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: widget.padding,
            child: GestureDetector(
              onDoubleTap: () {
                if (selectedDate != null) {
                  _handleDoubleTap(selectedDate);
                }
              },
              child: Builder(builder: (context) {
                switch (pickerType) {
                  case PickerType.days:
                    return Padding(
                      padding: widget.padding,
                      child: FusionDaysPicker(
                        centerLeadingDate: widget.centerLeadingDate,
                        initialDate: displayedDate,
                        selectedDate: selectedDate,
                        currentDate: DateUtils.dateOnly(widget.currentDate ?? DateTime.now()),
                        maxDate: DateUtils.dateOnly(widget.maxDate),
                        minDate: DateUtils.dateOnly(widget.minDate),
                        daysOfTheWeekTextStyle: widget.daysOfTheWeekTextStyle,
                        enabledCellsTextStyle: widget.enabledCellsTextStyle,
                        enabledCellsDecoration: widget.enabledCellsDecoration,
                        disabledCellsTextStyle: widget.disabledCellsTextStyle,
                        disabledCellsDecoration: widget.disabledCellsDecoration,
                        currentDateDecoration: widget.currentDateDecoration,
                        currentDateTextStyle: widget.currentDateTextStyle,
                        selectedCellDecoration: widget.selectedCellDecoration,
                        selectedCellTextStyle: widget.selectedCellTextStyle,
                        slidersColor: widget.slidersColor,
                        slidersSize: widget.slidersSize,
                        leadingDateTextStyle: widget.leadingDateTextStyle,
                        splashColor: widget.splashColor,
                        highlightColor: widget.highlightColor,
                        splashRadius: widget.splashRadius,
                        previousPageSemanticLabel: widget.previousPageSemanticLabel,
                        nextPageSemanticLabel: widget.nextPageSemanticLabel,
                        disabledDayPredicate: widget.disabledDayPredicate,
                        onLeadingDateTap: () {
                          controller.updatePickerType(PickerType.months);
                        },
                        onDateSelected: _handleSingleTap, // Single tap = select only
                      ),
                    );
                  case PickerType.months:
                    return Padding(
                      padding: widget.padding,
                      child: FusionMonthPicker(
                        centerLeadingDate: widget.centerLeadingDate,
                        initialDate: displayedDate,
                        selectedDate: selectedDate,
                        currentDate: DateUtils.dateOnly(widget.currentDate ?? DateTime.now()),
                        maxDate: DateUtils.dateOnly(widget.maxDate),
                        minDate: DateUtils.dateOnly(widget.minDate),
                        currentDateDecoration: widget.currentDateDecoration,
                        currentDateTextStyle: widget.currentDateTextStyle,
                        disabledCellsDecoration: widget.disabledCellsDecoration,
                        disabledCellsTextStyle: widget.disabledCellsTextStyle,
                        enabledCellsDecoration: widget.enabledCellsDecoration,
                        enabledCellsTextStyle: widget.enabledCellsTextStyle,
                        selectedCellDecoration: widget.selectedCellDecoration,
                        selectedCellTextStyle: widget.selectedCellTextStyle,
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
                        initialDate: displayedDate,
                        selectedDate: selectedDate,
                        currentDate: DateUtils.dateOnly(widget.currentDate ?? DateTime.now()),
                        maxDate: DateUtils.dateOnly(widget.maxDate),
                        minDate: DateUtils.dateOnly(widget.minDate),
                        currentDateDecoration: widget.currentDateDecoration,
                        currentDateTextStyle: widget.currentDateTextStyle,
                        disabledCellsDecoration: widget.disabledCellsDecoration,
                        disabledCellsTextStyle: widget.disabledCellsTextStyle,
                        enabledCellsDecoration: widget.enabledCellsDecoration,
                        enabledCellsTextStyle: widget.enabledCellsTextStyle,
                        selectedCellDecoration: widget.selectedCellDecoration,
                        selectedCellTextStyle: widget.selectedCellTextStyle,
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
                    );
                }
              }),
            ),
          ),
          if (widget.showOkCancel)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: _handleCancel,
                  child: Text('Cancel'),
                ),
                TextButton(
                  onPressed: _handleOk,
                  child: Text('OK'),
                ),
              ],
            ),
        ],
      );
    });
  }
}