import 'dart:convert';
import 'dart:developer';
import 'package:event_booking_app/Services/database.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

import '../Services/data.dart';
import '../Services/shared_pref.dart';

class DetailPage extends StatefulWidget {
  final String image;
  final String name;
  final String location;
  final String date;
  final String eventDetails;
  final String price;

  const DetailPage({
    super.key,
    required this.image,
    required this.name,
    required this.location,
    required this.date,
    required this.eventDetails,
    required this.price,
  });

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  Map<String, dynamic>? paymentIntent;
  int ticket = 1;
  int total = 0;
  String? name, image, id;

  @override
  void initState() {
    super.initState();
    total = int.parse(widget.price);
    onTheLoad();
  }

  onTheLoad() async {
    name = await SharedPrefsHelper.getUsername();
    image = await SharedPrefsHelper.getUserImage();
    id = await SharedPrefsHelper.getUserId();
    setState(() {});
  }

  Future<void> makePayment() async {
  try {
    paymentIntent = await createPaymentIntent(total.toString(), "INR");
    if (paymentIntent == null) return;

    await Stripe.instance.initPaymentSheet(
      paymentSheetParameters: SetupPaymentSheetParameters(
        merchantDisplayName: 'Maxima',
        paymentIntentClientSecret: paymentIntent!['client_secret'],
        style: ThemeMode.light,
        // Remove googlePay to allow only card payments
      ),
    );

    await displayPaymentSheet();
  } catch (e) {
    log("Error in makePayment: ${e.toString()}");

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Something went wrong during payment setup.")),
    );
  }
}


  Future<void> displayPaymentSheet() async {
  try {
    await Stripe.instance.presentPaymentSheet();

    Map<String, dynamic> bookingDetails = {
      "Number": ticket.toString(),
      "Total": total.toString(),
      "Event": widget.name,
      "Location": widget.location,
      "Date": widget.date,
      "Name": name,
      "Image": image,
    };

    await DatabaseMethods().addUserBooking(id!, bookingDetails);
    await DatabaseMethods().addAdminTicket(bookingDetails);

    paymentIntent = null;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Payment Successful"),
          content: const Text("Your ticket has been booked successfully!"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );

    // Show success snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Payment completed successfully!")),
    );
  } on StripeException catch (e) {
    log("StripeException: ${e.toString()}");

    // Show error snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Payment failed. Please try again.")),
    );
  } catch (e) {
    log("Error in displayPaymentSheet: ${e.toString()}");

    // Show generic error snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Something went wrong.")),
    );
  }
}

  Future<Map<String, dynamic>?> createPaymentIntent(
      String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'currency': currency,
        'amount': (int.parse(amount) * 100).toString(),
        'payment_method_types[]': 'card',
      };

      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        body: body,
        headers: {
          'Authorization': 'Bearer $secretKey',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
      );

      return jsonDecode(response.body);
    } catch (e) {
      log("Error creating payment intent: ${e.toString()}");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Image.asset(
                'images/Event.jpg',
                fit: BoxFit.cover,
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 2,
              ),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  margin: const EdgeInsets.only(top: 30, left: 15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Icon(
                    Icons.arrow_back_ios_new_outlined,
                    color: Colors.black,
                  ),
                ),
              ),
              Positioned(
                bottom: 10,
                child: Container(
                  padding: const EdgeInsets.only(left: 10),
                  color: Colors.black45,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.name,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.bold),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.calendar_month, color: Colors.white),
                          Text(
                            widget.date,
                            style: const TextStyle(
                              color: Color(0xFFFAF9F6),
                              fontSize: 20,
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Icon(Icons.location_on_outlined,
                              color: Colors.white),
                          Text(
                            widget.location,
                            style: const TextStyle(
                              color: Color(0xFFFAF9F6),
                              fontSize: 20,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          const Padding(
            padding: EdgeInsets.only(left: 20),
            child: Text(
              'About Event',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 29,
                  color: Colors.black),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Text(
              widget.eventDetails,
              style: const TextStyle(
                fontSize: 17,
                color: Colors.black,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          const Spacer(),
          Row(
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 20),
                child: Text(
                  'Number of Tickets',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.black),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 30),
                width: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: Colors.black),
                ),
                child: Column(
                  children: [
                    TextButton(
                      onPressed: () {
                        total += int.parse(widget.price);
                        ticket += 1;
                        setState(() {});
                      },
                      child: const Text(
                        '+',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                            color: Colors.black),
                      ),
                    ),
                    Text(
                      ticket.toString(),
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                          color: Colors.black),
                    ),
                    TextButton(
                      onPressed: () {
                        if (ticket > 1) {
                          total -= int.parse(widget.price);
                          ticket -= 1;
                          setState(() {});
                        }
                      },
                      child: const Text(
                        '-',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                            color: Colors.black),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Amount: ₹$total',
                  style: const TextStyle(
                      color: Color(0xFF4D68EE),
                      fontSize: 25,
                      fontWeight: FontWeight.bold),
                ),
                ElevatedButton(
                  onPressed: makePayment,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4D68EE),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 8),
                    elevation: 0,
                  ),
                  child: const Text(
                    '  Book Now  ',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
