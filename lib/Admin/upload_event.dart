import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:random_string/random_string.dart';
import '../Services/database.dart';

class UploadEvent extends StatefulWidget {
  const UploadEvent({super.key});

  @override
  State<UploadEvent> createState() => _UploadEventState();
}

class _UploadEventState extends State<UploadEvent> {
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  File? _selectedImage;
  String? dropdownValue;
  var eventName = TextEditingController();
  var ticketPrice = TextEditingController();
  var eventDetail = TextEditingController();
  var eventLocation = TextEditingController();

  var categories = [
    'Music',
    'Clothing',
    'Festival',
    'Food',
  ];

  void _pickImage() async {
    final imagePicker = ImagePicker();
    final _pickImage = await imagePicker.pickImage(source: ImageSource.gallery);
    _selectedImage = File(_pickImage!.path);
    setState(() {});
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null && pickedTime != _selectedTime) {
      setState(() {
        _selectedTime = pickedTime;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Upload Event',
          style: TextStyle(
              fontSize: 30,
              color: Color(0xFF4133FF),
              fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.arrow_back_ios_new_outlined,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: ListView(
          children: [
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: _selectedImage != null
                    ? Image.file(
                        _selectedImage!,
                        fit: BoxFit.cover,
                        height: 150,
                        width: 150,
                      )
                    : Center(
                        child: InkWell(
                          onTap: _pickImage,
                          child: Container(
                            height: 150,
                            width: 150,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(color: Colors.black),
                            ),
                            child: const Icon(Icons.camera_alt_outlined),
                          ),
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Event Name',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Color(0xFFEADDDD),
              ),
              child: TextField(
                controller: eventName,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Enter Event Name',
                ),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Color(0xFFEADDDD),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Ticket Price',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Color(0xFFEADDDD),
              ),
              child: TextField(
                keyboardType: TextInputType.number,
                controller: ticketPrice,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Enter Price',
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Event Location',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Color(0xFFEADDDD),
              ),
              child: TextField(
                controller: eventLocation,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Enter Location',
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Select Category',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: const Color(0xFFEADDDD),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: dropdownValue,
                  icon: const Icon(Icons.keyboard_arrow_down),
                  items: categories.map((String items) {
                    return DropdownMenuItem(
                      value: items,
                      child: Text(
                        items,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  }).toList(),
                  hint: const Text('Select Category'),
                  onChanged: (String? newValue) {
                    setState(() {
                      dropdownValue = newValue!;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                IconButton(
                  onPressed: () => _selectDate(context),
                  icon: const Icon(
                    Icons.calendar_month,
                    color: Color(0xFF4133FF),
                    size: 25,
                  ),
                ),
                Text(
                  _selectedDate == null
                      ? "No date selected"
                      : DateFormat('yyyy-MM-dd').format(_selectedDate!),
                  style:
                      const TextStyle(fontSize: 18, color: Color(0xFF4133FF)),
                ),
                IconButton(
                  onPressed: () => _selectTime(context),
                  icon: const Icon(
                    Icons.access_time,
                    color: Color(0xFF4133FF),
                    size: 25,
                  ),
                ),
                Text(
                  _selectedTime == null
                      ? 'No time selected'
                      : _selectedTime!.format(context),
                  style: const TextStyle(
                    fontSize: 18,
                    color: Color(0xFF4133FF),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Event Detail',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Color(0xFFEADDDD),
              ),
              child: TextField(
                controller: eventDetail,
                maxLines: 6,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'What will be on event...',
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: const ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(Color(0xFF4133FF)),
              ),
              onPressed: () async {
                if (eventName.text.isEmpty ||
                    ticketPrice.text.isEmpty ||
                    dropdownValue == null ||
                    eventDetail.text.isEmpty ||
                    _selectedImage == null ||
                    _selectedDate == null ||
                    _selectedTime == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      backgroundColor: Colors.orange,
                      content:
                          Text('Please fill all fields and upload an image.'),
                    ),
                  );
                  return;
                }

                bool confirm = await showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text("Confirmation"),
                    content: const Text(
                        "Are you sure you want to upload this event?"),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text("Cancel",
                            style: TextStyle(color: Colors.amber)),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text("Submit",
                            style: TextStyle(color: Colors.amber)),
                      ),
                    ],
                  ),
                );

                if (!confirm) return;

                try {
                  String id = randomAlphaNumeric(10);
                  String formattedDate =
                      DateFormat('dd MMM').format(_selectedDate!);
                  String formattedTime = DateFormat('hh:mm a').format(DateTime(
                      0, 0, 0, _selectedTime!.hour, _selectedTime!.minute));

                  await DatabaseMethods().addEventDetails({
                    "Image": "", // Handle image upload separately
                    "Name": eventName.text,
                    "Price": ticketPrice.text,
                    "Category": dropdownValue,
                    "Event Details": eventDetail.text,
                    "Location": eventLocation.text,
                    "Date": formattedDate,
                    "Time": formattedTime,
                  }, id);

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      backgroundColor: Colors.green,
                      content: Text('Event Uploaded Successfully!'),
                    ),
                  );
                  setState(() {
                    eventName.clear();
                    ticketPrice.clear();
                    eventDetail.clear();
                    eventLocation.clear();
                    dropdownValue = null;
                    _selectedImage = null;
                    _selectedDate = null;
                    _selectedTime = null;
                  });
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: Colors.red,
                      content: Text('Error uploading event: $e'),
                    ),
                  );
                }
              },
              child: const Text(
                'Upload',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
      ),
    );
  }
}
