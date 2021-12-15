import 'package:eckit/utilties/time_formater.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

typedef RangePickedChanged = void Function(DateTime from, DateTime to);

class DateRangePicker extends StatefulWidget {
  final DateTime from;
  final DateTime to;
  final RangePickedChanged onChanged;
  const DateRangePicker({
    Key key,
    @required this.onChanged,
    this.from,
    this.to,
  }) : super(key: key);

  @override
  State<DateRangePicker> createState() => _DateRangePickerState();
}

class _DateRangePickerState extends State<DateRangePicker> {
  DateTime from;
  DateTime to;

  void _openRangePicker() async {
    BoxConstraints boxConstraints = BoxConstraints(
      maxHeight: MediaQuery.of(context).size.height / 1.5,
    );
    if (kIsWeb) {
      boxConstraints = BoxConstraints(
        maxHeight: MediaQuery.of(context).size.width * .5,
        maxWidth: MediaQuery.of(context).size.width * 0.5,
      );
    }
    final result = await showDateRangePicker(
      context: context,
      firstDate: DateTime(1970),
      lastDate: DateTime(2030),
      // initialDateRange: DateTimeRange(
      //   start: widget.from ?? DateTime(1970),
      //   end: widget.to ?? DateTime(1970, 2),
      // ),
      builder: (context, child) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: ConstrainedBox(
              constraints: boxConstraints,
              child: child,
            ),
          ),
        );
      },
    );
    if (result == null) return;
    if (mounted) {
      from = result.start;
      to = result.end;
      setState(() {});
    }
    widget.onChanged(from, to);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _openRangePicker,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'startFrom'.tr(),
                    style: TextStyle(color: Colors.blue),
                  ),
                  if (from == null) ...[
                    Text(
                      "اختر التاريخ الابتدائي",
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ] else
                    Text(formateDateWithoutTime(from))
                ],
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'endAt'.tr(),
                    style: TextStyle(color: Colors.blue),
                  ),
                  if (to == null) ...[
                    Text(
                      "اختر التاريخ النهائي",
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                      ),
                    )
                  ] else
                    Text(formateDateWithoutTime(to))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
