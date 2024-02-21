import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:intl/intl.dart';
import 'package:jhijri_picker/_src/_jWidgets.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class CalendarConverterScreen extends StatefulWidget {
  const CalendarConverterScreen({super.key});

  @override
  State<CalendarConverterScreen> createState() =>
      _CalendarConverterScreenState();
}

class _CalendarConverterScreenState extends State<CalendarConverterScreen> {
  final List<String> _engMonths = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];
  final List<String> _hijriMonths = [
    'Muharram',
    'Safar',
    'Rabi\' al-Awwal',
    'Rabi\' al-Thani',
    'Jumada al-Awwal',
    'Jumada al-Thani',
    'Rajab',
    'Sha\'ban',
    'Ramadan',
    'Shawwal',
    'Dhu al-Qi\'dah',
    'Dhu al-Hijjah'
  ];
  final List<String> _engYear =
      List.generate(2047 - 1950, (index) => (index + 1950).toString());
  final List<String> _engDays =
      List.generate(31 - 0, (index) => (index + 1).toString());
  final List<String> _hijriYear =
      List.generate(1450 - 1407, (index) => (index + 1407).toString());
  final List<String> _hijriDays =
      List.generate(31 - 0, (index) => (index + 1).toString());

  String? engselectedMth;
  String? engselectedYear;
  String? engselectedDays;
  String? hijriselectedMth;
  String? hijriselectedYear;
  String? hijriselectedDays;
  int? engSelectedMthIndex;
  int? hijriSelectedMthIndex;
  String? _convertedHijriDate;
  final engDateinputController = TextEditingController();
  String selectedDateTime = '';
  String selectedDateTimeHijri = '';
  String? _convertedEngDate;
  bool _isChanged = false;

  @override
  Widget build(BuildContext context) {
    // _isChanged = false;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green.shade300,
        title: const Text('Converter'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              // height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.green.shade300,
                  borderRadius: BorderRadius.circular(10)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      height: 40,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(10)),
                      child: const Text(
                        'Gregorian To Hijri',
                        style: TextStyle(color: Colors.white),
                      )),
                  // Row(
                  //   children: [
                  //     DropdownButtonHideUnderline(
                  //       child: DropdownButton2<String>(
                  //         isExpanded: true,
                  //         hint: Text(
                  //           'Months',
                  //           style: TextStyle(
                  //             fontSize: 14,
                  //             color: Theme.of(context).hintColor,
                  //           ),
                  //         ),
                  //         items: _engMonths
                  //             .map((String item) => DropdownMenuItem<String>(
                  //                   value: item,
                  //                   child: Text(
                  //                     item,
                  //                     style: const TextStyle(
                  //                       fontSize: 14,
                  //                     ),
                  //                   ),
                  //                 ))
                  //             .toList(),
                  //         value: engselectedMth,
                  //         onChanged: (String? value) {
                  //           setState(() {
                  //             engselectedMth = value;
                  //             engSelectedMthIndex =
                  //                 _engMonths.indexOf(value!) + 1;
                  //           });
                  //         },
                  //         buttonStyleData: const ButtonStyleData(
                  //           padding: EdgeInsets.symmetric(horizontal: 16),
                  //           height: 40,
                  //           width: 130,
                  //         ),
                  //         dropdownStyleData: DropdownStyleData(
                  //           maxHeight: 400,
                  //           width: 150,
                  //           decoration: BoxDecoration(
                  //             borderRadius: BorderRadius.circular(14),
                  //             // color: Colors.redAccent,
                  //           ),
                  //           offset: const Offset(-20, 0),
                  //           scrollbarTheme: ScrollbarThemeData(
                  //             radius: const Radius.circular(40),
                  //             thickness: MaterialStateProperty.all(6),
                  //             thumbVisibility: MaterialStateProperty.all(true),
                  //           ),
                  //         ),
                  //         menuItemStyleData: const MenuItemStyleData(
                  //           height: 40,
                  //         ),
                  //       ),
                  //     ),
                  //     DropdownButtonHideUnderline(
                  //       child: DropdownButton2<String>(
                  //         isExpanded: true,
                  //         hint: Text(
                  //           'Year',
                  //           style: TextStyle(
                  //             fontSize: 14,
                  //             color: Theme.of(context).hintColor,
                  //           ),
                  //         ),
                  //         items: _engYear
                  //             .map((String item) => DropdownMenuItem<String>(
                  //                   value: item,
                  //                   child: Text(
                  //                     item,
                  //                     style: const TextStyle(
                  //                       fontSize: 14,
                  //                     ),
                  //                   ),
                  //                 ))
                  //             .toList(),
                  //         value: engselectedYear,
                  //         onChanged: (String? value) {
                  //           setState(() {
                  //             engselectedYear = value;
                  //           });
                  //         },
                  //         buttonStyleData: const ButtonStyleData(
                  //           padding: EdgeInsets.symmetric(horizontal: 16),
                  //           height: 40,
                  //           width: 100,
                  //         ),
                  //         dropdownStyleData: DropdownStyleData(
                  //           maxHeight: 500,
                  //           width: 100,
                  //           decoration: BoxDecoration(
                  //             borderRadius: BorderRadius.circular(14),
                  //             // color: Colors.redAccent,
                  //           ),
                  //           offset: const Offset(-20, 0),
                  //           scrollbarTheme: ScrollbarThemeData(
                  //             radius: const Radius.circular(40),
                  //             thickness: MaterialStateProperty.all(6),
                  //             thumbVisibility: MaterialStateProperty.all(true),
                  //           ),
                  //         ),
                  //         menuItemStyleData: const MenuItemStyleData(
                  //           height: 40,
                  //         ),
                  //       ),
                  //     ),
                  //     DropdownButtonHideUnderline(
                  //       child: DropdownButton2<String>(
                  //         isExpanded: true,
                  //         hint: Text(
                  //           'Days',
                  //           style: TextStyle(
                  //             fontSize: 14,
                  //             color: Theme.of(context).hintColor,
                  //           ),
                  //         ),
                  //         items: _engDays
                  //             .map((String item) => DropdownMenuItem<String>(
                  //                   value: item,
                  //                   child: Text(
                  //                     item,
                  //                     style: const TextStyle(
                  //                       fontSize: 14,
                  //                     ),
                  //                   ),
                  //                 ))
                  //             .toList(),
                  //         value: engselectedDays,
                  //         onChanged: (String? value) {
                  //           setState(() {
                  //             engselectedDays = value;
                  //           });
                  //         },
                  //         buttonStyleData: const ButtonStyleData(
                  //           padding: EdgeInsets.symmetric(horizontal: 16),
                  //           height: 40,
                  //           width: 100,
                  //         ),
                  //         dropdownStyleData: DropdownStyleData(
                  //           maxHeight: 400,
                  //           width: 100,
                  //           decoration: BoxDecoration(
                  //             borderRadius: BorderRadius.circular(14),
                  //             // color: Colors.redAccent,
                  //           ),
                  //           offset: const Offset(-20, 0),
                  //           scrollbarTheme: ScrollbarThemeData(
                  //             radius: const Radius.circular(40),
                  //             thickness: MaterialStateProperty.all(6),
                  //             thumbVisibility: MaterialStateProperty.all(true),
                  //           ),
                  //         ),
                  //         menuItemStyleData: const MenuItemStyleData(
                  //           height: 40,
                  //         ),
                  //       ),
                  //     ),
                  //   ],
                  // ),

                  // Container(
                  //   padding: EdgeInsets.all(15),
                  //   height: MediaQuery.of(context).size.width / 3,
                  //   child: Center(
                  //       child: TextField(
                  //     onTap: () => _showDatePicker(),
                  //     controller: engDateinputController,
                  //     decoration: const InputDecoration(
                  //         icon: Icon(Icons.calendar_today), //icon of text field
                  //         labelText: "Pick Date" //label text of field
                  //         ),
                  //     readOnly: true,
                  //   )),
                  // ),
                  // Text('$_convertedHijriDate'),

                  InkWell(
                    onTap: () => _showDatePicker(),
                    child: Container(
                        margin: const EdgeInsets.only(
                          top: 10,
                        ),
                        padding: const EdgeInsets.only(
                            left: 12, right: 12, top: 8, bottom: 8),
                        decoration: BoxDecoration(
                            border: Border.all(
                                color:
                                    const Color.fromARGB(255, 224, 223, 223)),
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.white,
                            boxShadow: const [
                              BoxShadow(
                                  color: Color.fromRGBO(218, 218, 218, 0.45),
                                  blurRadius: 1,
                                  spreadRadius: 0,
                                  offset: Offset(1, 1)),
                              BoxShadow(
                                  color: Color.fromRGBO(218, 218, 218, 0.45),
                                  blurRadius: 1,
                                  spreadRadius: 0,
                                  offset: Offset(-1, -1)),
                            ]),
                        child: Row(
                          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Icon(LineAwesomeIcons.calendar,
                                size: 28, color: Colors.green),
                            const SizedBox(
                              width: 6,
                            ),
                            selectedDateTime != ''
                                ? Text(selectedDateTime,
                                    style: const TextStyle(fontSize: 16))
                                : const Text('Select date',
                                    style: TextStyle(fontSize: 16)),
                          ],
                        )),
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  Visibility(
                      visible: selectedDateTime != '',
                      child: Text('$_convertedHijriDate',
                          style: const TextStyle(fontSize: 18)))
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              padding: const EdgeInsets.all(10),
              // height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.green.shade300,
                  borderRadius: BorderRadius.circular(10)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      height: 40,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(10)),
                      child: const Text(
                        'Hijri To Gregorian',
                        style: TextStyle(color: Colors.white),
                      )),
                  // Row(
                  //   children: [
                  //     DropdownButtonHideUnderline(
                  //       child: DropdownButton2<String>(
                  //         isExpanded: true,
                  //         hint: Text(
                  //           'Months',
                  //           style: TextStyle(
                  //             fontSize: 14,
                  //             color: Theme.of(context).hintColor,
                  //           ),
                  //         ),
                  //         items: _hijriMonths
                  //             .map((String item) => DropdownMenuItem<String>(
                  //                   value: item,
                  //                   child: Text(
                  //                     item,
                  //                     style: const TextStyle(
                  //                       fontSize: 14,
                  //                     ),
                  //                   ),
                  //                 ))
                  //             .toList(),
                  //         value: hijriselectedMth,
                  //         onChanged: (String? value) {
                  //           setState(() {
                  //             hijriselectedMth = value;
                  //             hijriSelectedMthIndex =
                  //                 _hijriMonths.indexOf(value!) + 1;
                  //           });
                  //         },
                  //         buttonStyleData: const ButtonStyleData(
                  //           padding: EdgeInsets.symmetric(horizontal: 16),
                  //           height: 40,
                  //           width: 165,
                  //         ),
                  //         dropdownStyleData: DropdownStyleData(
                  //           maxHeight: 400,
                  //           width: 150,
                  //           decoration: BoxDecoration(
                  //             borderRadius: BorderRadius.circular(14),
                  //             // color: Colors.redAccent,
                  //           ),
                  //           offset: const Offset(-20, 0),
                  //           scrollbarTheme: ScrollbarThemeData(
                  //             radius: const Radius.circular(40),
                  //             thickness: MaterialStateProperty.all(6),
                  //             thumbVisibility: MaterialStateProperty.all(true),
                  //           ),
                  //         ),
                  //         menuItemStyleData: const MenuItemStyleData(
                  //           height: 40,
                  //         ),
                  //       ),
                  //     ),
                  //     DropdownButtonHideUnderline(
                  //       child: DropdownButton2<String>(
                  //         isExpanded: true,
                  //         hint: Text(
                  //           'Year',
                  //           style: TextStyle(
                  //             fontSize: 14,
                  //             color: Theme.of(context).hintColor,
                  //           ),
                  //         ),
                  //         items: _hijriYear
                  //             .map((String item) => DropdownMenuItem<String>(
                  //                   value: item,
                  //                   child: Text(
                  //                     item,
                  //                     style: const TextStyle(
                  //                       fontSize: 14,
                  //                     ),
                  //                   ),
                  //                 ))
                  //             .toList(),
                  //         value: hijriselectedYear,
                  //         onChanged: (String? value) {
                  //           setState(() {
                  //             hijriselectedYear = value;
                  //           });
                  //         },
                  //         buttonStyleData: const ButtonStyleData(
                  //           padding: EdgeInsets.symmetric(horizontal: 16),
                  //           height: 40,
                  //           width: 90,
                  //         ),
                  //         dropdownStyleData: DropdownStyleData(
                  //           maxHeight: 500,
                  //           width: 100,
                  //           decoration: BoxDecoration(
                  //             borderRadius: BorderRadius.circular(14),
                  //             // color: Colors.redAccent,
                  //           ),
                  //           offset: const Offset(-20, 0),
                  //           scrollbarTheme: ScrollbarThemeData(
                  //             radius: const Radius.circular(40),
                  //             thickness: MaterialStateProperty.all(6),
                  //             thumbVisibility: MaterialStateProperty.all(true),
                  //           ),
                  //         ),
                  //         menuItemStyleData: const MenuItemStyleData(
                  //           height: 40,
                  //         ),
                  //       ),
                  //     ),
                  //     DropdownButtonHideUnderline(
                  //       child: DropdownButton2<String>(
                  //         isExpanded: true,
                  //         hint: Text(
                  //           'Days',
                  //           style: TextStyle(
                  //             fontSize: 14,
                  //             color: Theme.of(context).hintColor,
                  //           ),
                  //         ),
                  //         items: _hijriDays
                  //             .map((String item) => DropdownMenuItem<String>(
                  //                   value: item,
                  //                   child: Text(
                  //                     item,
                  //                     style: const TextStyle(
                  //                       fontSize: 14,
                  //                     ),
                  //                   ),
                  //                 ))
                  //             .toList(),
                  //         value: hijriselectedDays,
                  //         onChanged: (String? value) {
                  //           setState(() {
                  //             hijriselectedDays = value;
                  //           });
                  //         },
                  //         buttonStyleData: const ButtonStyleData(
                  //           padding: EdgeInsets.symmetric(horizontal: 16),
                  //           height: 40,
                  //           width: 90,
                  //         ),
                  //         dropdownStyleData: DropdownStyleData(
                  //           maxHeight: 400,
                  //           width: 100,
                  //           decoration: BoxDecoration(
                  //             borderRadius: BorderRadius.circular(14),
                  //             // color: Colors.redAccent,
                  //           ),
                  //           offset: const Offset(-20, 0),
                  //           scrollbarTheme: ScrollbarThemeData(
                  //             radius: const Radius.circular(40),
                  //             thickness: MaterialStateProperty.all(6),
                  //             thumbVisibility: MaterialStateProperty.all(true),
                  //           ),
                  //         ),
                  //         menuItemStyleData: const MenuItemStyleData(
                  //           height: 40,
                  //         ),
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  InkWell(
                    onTap: () => openDialog(context),
                    child: Container(
                        margin: const EdgeInsets.only(
                          top: 10,
                        ),
                        padding: const EdgeInsets.only(
                            left: 12, right: 12, top: 8, bottom: 8),
                        decoration: BoxDecoration(
                            border: Border.all(
                                color:
                                    const Color.fromARGB(255, 224, 223, 223)),
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.white,
                            boxShadow: const [
                              BoxShadow(
                                  color: Color.fromRGBO(218, 218, 218, 0.45),
                                  blurRadius: 1,
                                  spreadRadius: 0,
                                  offset: Offset(1, 1)),
                              BoxShadow(
                                  color: Color.fromRGBO(218, 218, 218, 0.45),
                                  blurRadius: 1,
                                  spreadRadius: 0,
                                  offset: Offset(-1, -1)),
                            ]),
                        child: Row(
                          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Icon(LineAwesomeIcons.calendar,
                                size: 28, color: Colors.green),
                            const SizedBox(
                              width: 6,
                            ),
                            selectedDateTimeHijri != ''
                                ? Text(selectedDateTimeHijri,
                                    style: const TextStyle(fontSize: 16))
                                : const Text('Select date',
                                    style: TextStyle(fontSize: 16)),
                          ],
                        )),
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  Visibility(
                      visible: selectedDateTimeHijri != '',
                      child: Text('$_convertedEngDate',
                          style: const TextStyle(fontSize: 18)))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Future openDialog(BuildContext context) async {
    setState(() {
      _isChanged = false;
    });
    return await showGlobalDatePicker(
      context: context,
      startDate: JDateModel(dateTime: DateTime.parse("1974-12-24")),
      selectedDate: JDateModel(dateTime: DateTime.now()),
      endDate: JDateModel(dateTime: DateTime.parse("2040-12-20")),
      pickerType: PickerType.JHijri,
      pickerMode: DatePickerMode.day,
      pickerTheme: Theme.of(context),
      primaryColor: Colors.green,
      // textDirection: TextDirection.rtl,
      buttons: ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green, elevation: 0),
          onPressed: () {
            if (!_isChanged) {
              var cDate = convertToGregorian(currdate: true);
              String formattedDateTime = DateFormat.yMMMMEEEEd().format(cDate);
              setState(() {
                _isChanged = false;
                selectedDateTimeHijri =
                    HijriCalendar.fromDate(DateTime.now()).fullDate();
                _convertedEngDate = formattedDateTime;
              });
            }
            Navigator.pop(context);
          },
          child: const Text('Ok')),
      onChange: (datetime) {
        var cDate = convertToHijri(
          datetime.date.year,
          datetime.date.month,
          datetime.date.day,
        );
        String formattedDateTime =
            DateFormat.yMMMMEEEEd().format(datetime.jhijri.dateTime);

        setState(() {
          _isChanged = true;
          selectedDateTimeHijri = cDate;
          _convertedEngDate = formattedDateTime;
        });
      },
    );
  }

  convertToHijri(int year, int month, int day) =>
      HijriCalendar.fromDate(DateTime(year, month, day)).fullDate();

  convertToGregorian({int? year, int? month, int? day, bool? currdate}) {
    var gDate = HijriCalendar.now();
    return !currdate!
        ? HijriCalendar().hijriToGregorian(year, month, day)
        : HijriCalendar()
            .hijriToGregorian(gDate.hYear, gDate.hMonth, gDate.hDay);
  }

  Future _showDatePicker() async {
    DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1910),
        builder: (context, child) {
          return Theme(
            data: ThemeData.light().copyWith(
              colorScheme: const ColorScheme.light(
                primary: Colors.green,
                onPrimary: Colors.white, 
                onSurface: Colors.black, 
              ),
              dialogBackgroundColor: Colors.white, // Background color
            ),
            child: child!,
          );
        },
        //DateTime.now() - not to allow to choose before today.
        lastDate: DateTime(2050));

    if (pickedDate != null) {
      // print(pickedDate);
      String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
      String formattedDateTime = DateFormat.yMMMMEEEEd().format(pickedDate);
      int year = int.parse(formattedDate.substring(0, 4));
      int month = int.parse(formattedDate.substring(5, 7));
      int day = int.parse(formattedDate.substring(8, 10));
      var cDate = convertToHijri(year, month, day);
      setState(() {
        selectedDateTime = formattedDateTime;
        _convertedHijriDate = cDate;
      });
    } else {}
  }
}
