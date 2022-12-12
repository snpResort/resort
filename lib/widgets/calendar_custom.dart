import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:resort/constant/app_colors.dart';
import 'package:resort/constant/app_numbers.dart';
import 'package:resort/home_page/model/date_book.dart';
import 'package:resort/home_page/model/room.dart';
import 'package:resort/home_page/repository/p_room.dart';
import 'package:table_calendar/table_calendar.dart';

Future CalendarCustom(context, rangeStart, rangeEnd, List<DateBook> ngayDaDat) {
  return showDialog<void>(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      final _width = MediaQuery.of(context).size.width;
      return AlertDialog(
        backgroundColor: Colors.white,
        insetPadding: EdgeInsets.zero,
        titlePadding: EdgeInsets.symmetric(horizontal: 10),
        contentPadding: EdgeInsets.all(0),
        title: Column(
          children: [
            _calendar(
                rangeStart: rangeStart,
                rangeEnd: rangeEnd,
                ngayDaDat: ngayDaDat),
            const SizedBox(height: 15),
            Container(
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'x',
                        style: TextStyle(
                          fontWeight: FontWeight.w300,
                          color: Colors.red,
                          fontSize: _width / 22,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Không được chọn',
                        style: TextStyle(
                          fontSize: _width / 22,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Text(
                        '_',
                        style: TextStyle(
                          fontWeight: FontWeight.w300,
                          color: Colors.red.shade400,
                          fontSize: _width / 22,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Phòng đã được đặt',
                        style: TextStyle(
                          fontSize: _width / 22,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 15),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 12),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.orange.shade400,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text(
                  'Xác nhận',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: _width / 18,
                  ),
                ),
              ),
            )
          ],
        ),
      );
    },
  );
}

class _calendar extends StatefulWidget {
  _calendar(
      {Key? key,
      required this.rangeStart,
      required this.rangeEnd,
      required this.ngayDaDat})
      : super(key: key);
  DateTime? rangeStart;
  DateTime? rangeEnd;
  List<DateBook> ngayDaDat;

  @override
  State<_calendar> createState() => _calendarState();
}

class _calendarState extends State<_calendar> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode
      .toggledOn; // Can be toggled on/off by longpressing a date
  DateTime _focusedDay = DateTime.now().subtract(Duration(days: 2));
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    if (widget.rangeStart != null && widget.rangeEnd != null) {
      var dateBook = DateBook();
      dateBook
        ..timeCheckin = widget.rangeStart
        ..timeCheckout = widget.rangeEnd;

      Provider.of<PRoom>(context, listen: false).setDateBook(dateBook);
    }
    return Container(
      color: Colors.white,
      height: MediaQuery.of(context).size.height / 2,
      width: MediaQuery.of(context).size.width / 1.2,
      child: TableCalendar(
        locale: 'en_US',
        shouldFillViewport: true,
        daysOfWeekHeight: 30,
        focusedDay: _focusedDay,
        firstDay: DateTime.utc(2010, 10, 16),
        lastDay: DateTime.utc(2030, 3, 14),
        selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
        rangeStartDay: widget.rangeStart,
        rangeEndDay: widget.rangeEnd,
        calendarFormat: _calendarFormat,
        rangeSelectionMode: _rangeSelectionMode,
        onRangeSelected: (start, end, focusedDay) {
          final currentDay = DateTime.now();
          setState(() {
            _selectedDay = null;
            if (focusedDay.compareTo(DateTime(
                    currentDay.year, currentDay.month, currentDay.day)) >=
                0) {
              _focusedDay = focusedDay;
              if (start!.compareTo(DateTime(
                      currentDay.year, currentDay.month, currentDay.day)) <
                  0) {
                widget.rangeStart = null;
              } else {
                widget.rangeStart = start;
                widget.rangeEnd = null;
              }
              print('start null: $start=====================');
              print('end null: $end=====================');

              widget.rangeEnd = end;
              _rangeSelectionMode = RangeSelectionMode.toggledOn;
            }
          });
        },
        onFormatChanged: (format) {
          if (_calendarFormat != format) {
            setState(() {
              _calendarFormat = format;
            });
          }
        },
        onPageChanged: (focusedDay) {
          _focusedDay = focusedDay;
        },
        headerStyle: HeaderStyle(
          titleCentered: true,
          formatButtonVisible: false,
        ),
        calendarStyle: CalendarStyle(
          todayDecoration: BoxDecoration(
            color: Colors.red.shade300,
            shape: BoxShape.circle,
          ),
        ),
        calendarBuilders: CalendarBuilders(
          dowBuilder: (context, day) {
            if (day.weekday == DateTime.sunday) {
              final text = DateFormat.E().format(day);

              return Center(
                child: Text(
                  text,
                  style: TextStyle(color: Colors.red),
                ),
              );
            }
          },
          markerBuilder: (context, day, events) {
            final currentDay = DateTime.now();
            Widget _check = Container(
              width: double.infinity,
              margin: EdgeInsets.symmetric(horizontal: 10),
              child: Icon(
                CupertinoIcons.xmark,
                size: 13,
                color: Colors.red,
              ),
            );

            Room room = Provider.of<PRoom>(context).room!;

            if (day.compareTo(DateTime(
                    currentDay.year, currentDay.month, currentDay.day)) >=
                0) {
              if (widget.ngayDaDat
                      .where((date) =>
                          day.compareTo(date.timeCheckin!) >= 0 &&
                          day.compareTo(date.timeCheckout!) <= 0)
                      .map((e) => e.room)
                      .toSet()
                      .length ==
                  room.soLuongPhong) {
                _check = Container(
                  width: 20,
                  height: 2,
                  color: Colors.red.shade400,
                );
              } else {
                _check = const SizedBox();
              }
            }
            return _check;
          },
          defaultBuilder: (context, day, focusedDay) {
            if (day.weekday == DateTime.sunday) {
              return Center(
                child: Text(
                  '${day.day}',
                  style: TextStyle(color: Colors.red),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
