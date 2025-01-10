import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:random_string/random_string.dart';
import '../Services/database.dart';

class UploadEvent extends StatefulWidget {
  const UploadEvent({super.key});

  @override
  State<UploadEvent> createState() => _UploadEventState();
}

class _UploadEventState extends State<UploadEvent> {
  File? _selectedImage;
  String? dropdownValue;
  var eventName = TextEditingController();
  var ticketPrice = TextEditingController();
  var eventDetail = TextEditingController();

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
                  color: Colors.black, fontSize: 20, fontWeight: FontWeight.w500),
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
                  color: Colors.black, fontSize: 20, fontWeight: FontWeight.w500),
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
                controller: ticketPrice,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Enter Price',
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Select Category',
              style: TextStyle(
                  color: Colors.black, fontSize: 20, fontWeight: FontWeight.w500),
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
            const Text(
              'Event Detail',
              style: TextStyle(
                  color: Colors.black, fontSize: 20, fontWeight: FontWeight.w500),
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
                if (eventName.text.isNotEmpty &&
                    ticketPrice.text.isNotEmpty &&
                    dropdownValue != null &&
                    eventDetail.text.isNotEmpty &&
                    _selectedImage != null) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text("Confirmation"),
                        content: const Text(
                            "Are you sure you want to upload this event?"),
                        actions: [
                          TextButton(
                            child: const Text(
                              "Cancel",
                              style: TextStyle(color: Colors.amber),
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          TextButton(
                            child: const Text(
                              "Submit",
                              style: TextStyle(color: Colors.amber),
                            ),
                            onPressed: () async {
                              Navigator.of(context)
                                  .pop(); // Close the dialog before proceeding
                              try {
                                String id = randomAlphaNumeric(10);
                                Map<String, dynamic> uploadEvent = {
                                  "Image":
                                      "", // You might need to add image upload logic
                                  "Name": eventName.text,
                                  "Price": ticketPrice.text,
                                  "Category": dropdownValue,
                                  "Event Details": eventDetail.text,
                                };
                                await DatabaseMethods()
                                    .addEventDetails(uploadEvent, id);

                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    backgroundColor: Colors.green,
                                    behavior: SnackBarBehavior.floating,
                                    margin: EdgeInsets.all(10),
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5)),
                                    ),
                                    content: Text(
                                      'Event Uploaded Successfully!',
                                      style: TextStyle(fontSize: 15),
                                    ),
                                  ),
                                );
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    backgroundColor: Colors.red,
                                    behavior: SnackBarBehavior.floating,
                                    margin: const EdgeInsets.all(10),
                                    shape: const RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5)),
                                    ),
                                    content: Text(
                                      'Error uploading event: $e',
                                      style: const TextStyle(fontSize: 15),
                                    ),
                                  ),
                                );
                              }
                            },
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      backgroundColor: Colors.orange,
                      behavior: SnackBarBehavior.floating,
                      margin: EdgeInsets.all(10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                      ),
                      content: Text(
                        'Please fill all the fields and upload an image.',
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                  );
                }
              },
              child: const Text(
                'Upload',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
