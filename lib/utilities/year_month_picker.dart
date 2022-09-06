import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../pages/year_month_controller.dart';

class YearMonthPicker extends StatefulWidget {
  late final MonthPicker monthPicker;
  late final CustomYearPicker yearPicker;
  final YearMonthController controller;

  YearMonthPicker(this.controller, {super.key}) {
    controller.setPicker(this);
    monthPicker = MonthPicker(controller: controller);
    yearPicker = CustomYearPicker(controller: controller);
  }

  @override
  State<YearMonthPicker> createState() => _YearMonthPickerState();

  int getMonth() {
    return monthPicker._month;
  }

  int getYear() {
    return yearPicker._year;
  }

  void reset() {
    yearPicker.reset();
  }
}

class _YearMonthPickerState extends State<YearMonthPicker> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        widget.monthPicker,
        const Padding(padding: EdgeInsets.all(20)),
        widget.yearPicker,
      ],
    );
  }
}

class CustomYearPicker extends StatefulWidget {
  int _year = DateTime
      .now()
      .year;
  final YearMonthController controller;
  final TextEditingController textController = TextEditingController();

  CustomYearPicker({super.key, required this.controller});

  @override
  State<CustomYearPicker> createState() => _CustomYearPickerState();

  void reset() {
    textController.clear();
  }
}

class _CustomYearPickerState extends State<CustomYearPicker> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 80,
      child: TextFormField(
        decoration: const InputDecoration(
          label: Text("Year"),
        ),
        keyboardType: TextInputType.number,
        onChanged: (String value) {
          if (value == "") {
            return;
          }

          widget._year = int.parse(value);
          widget.controller.updateLink();
        },
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
        ],
        controller: widget.textController,
      ),
    );
  }
}

class MonthPicker extends StatefulWidget {
  int _month = DateTime
      .now()
      .month;
  final YearMonthController controller;

  MonthPicker({super.key, required this.controller});

  @override
  State<MonthPicker> createState() => _MonthPickerState();

  int getSelectedMonth() {
    return _month;
  }
}

class _MonthPickerState extends State<MonthPicker> {
  final List<String> months = [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December"
  ];

  @override
  Widget build(BuildContext context) {
    return DropdownButton<int>(
      value: widget._month,
      items: [
        for (var i = 0; i < months.length; i++)
          DropdownMenuItem(
            value: i + 1,
            child: Text(months[i]),
          )
      ],
      onChanged: (value) {
        widget.controller.updateLink();
        setState(() {
          widget._month = value!;
        });
      },
    );
  }
}
