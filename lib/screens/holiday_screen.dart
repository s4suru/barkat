import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jhijri_picker/jhijri_picker.dart';
import 'package:tasbih/screens/calendar_converter_screen.dart';

class HolidayScreen extends StatefulWidget {
  const HolidayScreen({super.key});

  @override
  State<HolidayScreen> createState() => _HolidayScreenState();
}

class _HolidayScreenState extends State<HolidayScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green.shade300,
          title: const Text('Calendar'),
          actions: [
            Row(
              children: [
                IconButton(
                    onPressed: () =>
                        Get.to(() => const CalendarConverterScreen()),
                    icon: const Icon(Icons.calendar_today)),
                const SizedBox(
                  width: 10,
                )
              ],
            )
          ],
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              const SizedBox(
                height: 8,
              ),
              const Text('Hijri Calendar'),
              _JHijriAsWidget(1),
              const Spacer(),
              const Text('English Calendar'),
              _JHijriAsWidget(0),
            ],
          ),
        ));
  }

  _JHijriAsWidget(int type) {
    return JGlobalDatePicker(
      widgetType: WidgetType.JContainer,
      pickerType: type == 1 ? PickerType.JHijri : PickerType.JNormal,
      buttons: const SizedBox(),
      primaryColor: Colors.blue.shade300,
      calendarTextColor: Colors.white,
      backgroundColor: Colors.green.shade300,
      borderRadius: const Radius.circular(10),
      // headerTitle: const Center(
      //   child: Text("التقويم الهجري"),
      // ),
      startDate: JDateModel(dateTime: DateTime.parse("1984-12-24")),
      selectedDate: JDateModel(dateTime: DateTime.now()),
      endDate: JDateModel(dateTime: DateTime.parse("2030-09-20")),
      pickerMode: DatePickerMode.day,
      pickerTheme: Theme.of(context),
      textDirection: type == 1 ? TextDirection.rtl : TextDirection.ltr,
      onChange: (val) {
        debugPrint(val.toString());
      },
    );
  }
}
