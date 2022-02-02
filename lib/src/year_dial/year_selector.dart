import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:japanese_year_calculator/src/localization/app_localizations_context.dart';
import 'package:japanese_year_calculator/src/year_dial/dial_wheel_settings.dart';

/// Widget to jump directly to a specific year.
class YearSelector extends StatefulWidget {
  /// Called with the year (an [int]) when the user selects it.
  final ValueSetter<int> onSelected;

  /// Called when the user tries to submit an invalid year.
  final VoidCallback onInvalid;

  const YearSelector(
      {Key? key, required this.onSelected, required this.onInvalid})
      : super(key: key);

  @override
  _YearSelectorState createState() => _YearSelectorState();
}

class _YearSelectorState extends State<YearSelector> {
  final TextEditingController _yearInputController = TextEditingController();
  final FocusNode _yearInputFocusNode = FocusNode();

  @override
  void dispose() {
    _yearInputController.dispose();
    _yearInputFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: TextField(
          autofocus: true,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
          ],
          decoration: InputDecoration(
            hintText: context.loc.enterWesternYearHint(
              DialWheelSettings.firstYear,
              DialWheelSettings.lastYear,
            ),
            filled: true,
            fillColor: Theme.of(context).primaryColorLight,
            suffixIcon: IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                _yearInputController.clear();
              },
            ),
            // Hide the '0/4' helper text that would show because we have [maxLength] set.
            counterText: '',
          ),
          maxLength: 4,
          controller: _yearInputController,
          focusNode: _yearInputFocusNode,
          onEditingComplete: _onSubmit,
        )),
        Container(
            margin: const EdgeInsets.only(left: 10),
            child: ElevatedButton(
              child: Text(context.loc.convertYearButton),
              onPressed: _onSubmit,
              style: ElevatedButton.styleFrom(
                fixedSize: const Size(100, 48),
              ),
            )),
      ],
    );
  }

  void _onSubmit() async {
    final year = int.tryParse(_yearInputController.text);
    if (year != null) {
      widget.onSelected(year);
      _yearInputController.clear();
    } else {
      widget.onInvalid();
      _yearInputFocusNode.requestFocus();
    }
  }
}
