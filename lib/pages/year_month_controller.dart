import 'package:BeerApp/utilities/year_month_picker.dart';

class YearMonthController {
  late YearMonthPicker _picker;
  final Function _onUpdateLink;

  YearMonthController(this._onUpdateLink);

  void setPicker(YearMonthPicker picker) {
    _picker = picker;
  }

  String getMonthYear() {
    return "${_picker.getMonth()}-${_picker.getYear()}";
  }

  void updateLink() {
    _onUpdateLink(getMonthYear());
  }

  void reset() {
    _picker.reset();
  }
}
