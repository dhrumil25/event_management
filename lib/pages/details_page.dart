import 'package:flutter/material.dart';

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
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  margin: const EdgeInsets.only(top: 30, left: 15),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30)),
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
                  decoration: const BoxDecoration(
                    color: Colors.black45,
                  ),
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
                          const Icon(
                            Icons.calendar_month,
                            color: Colors.white,
                          ),
                          Text(
                            widget.date,
                            style: const TextStyle(
                              color: Color(0xFFFAF9F6),
                              fontSize: 20,
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Icon(
                            Icons.location_on_outlined,
                            color: Colors.white,
                          ),
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
                  fontWeight: FontWeight.w400),
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
                margin: EdgeInsets.only(left: 30),
                width: 50,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: Colors.black)),
                child: const Column(
                  children: [
                    Text(
                      '+',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                          color: Colors.black),
                    ),
                    Text(
                      '3',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                          color: Colors.black),
                    ),
                    Text(
                      '-',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                          color: Colors.black),
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
                  'Amount: \₹${widget.price}',
                  style: const TextStyle(
                      color: Color(0xFF4D68EE),
                      fontSize: 25,
                      fontWeight: FontWeight.bold),
                ),
                Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4D68EE),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: const Text(
                    '  Book Now  ',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.bold),
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
