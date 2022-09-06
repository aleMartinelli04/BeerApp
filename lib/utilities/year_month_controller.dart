import 'package:BeerApp/utilities/year_month_picker.dart';

class YearMonthController {
  late YearMonthPicker _picker;

  void setPicker(YearMonthPicker picker) {
    _picker = picker;
  }

  int getMonth() {
    return _picker.getMonth();
  }

  int? getYear() {
    return _picker.getYear();
  }

  void reset() {
    _picker.reset();
  }
}
