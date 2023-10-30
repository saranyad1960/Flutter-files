import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:MobileAppNew/app/otp_screen.dart';

import 'otp_screen.dart';

class MobileScreen extends StatefulWidget {
  const MobileScreen();


  @override
  State<MobileScreen> createState() => MobileScreenState();
}

class MobileScreenState extends State<MobileScreen> {
  String selectedCountryCode = "+91";
  TextEditingController phoneNumberController = TextEditingController();
  bool isFocused = false;
  bool notEmpty = false;

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 30),
            child: Container(
              height: 200,
              width: 500,
              child: Center(
                  child: Image.asset(
                    'assets/KJ-store-image.jpg', height: 200, width: 500,)),
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 20, left: 10, right: 10, bottom: 20),
              child: Text("WELCOME!",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,),
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text("Enter your phone number here",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.5,),
              ),
            ),
          ),
          SizedBox(height: 20,),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButton<String>(
                  value: selectedCountryCode,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedCountryCode = newValue!;
                    });
                  },
                  items: <String>["+91", "+1", "+44", "+81", "+86"]
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: isFocused ? Colors.red : Colors
                            .grey,
                      ),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: TextField(
                      cursorColor: Colors.red,
                      controller: phoneNumberController,
                      maxLength: 10,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                      ],
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        hintText: "Enter your phone number",
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(10.0),
                        counterText: "",
                      ),
                      onChanged: (value) {
                        setState(() {
                          notEmpty == true ?
                          phoneNumberController.text.length == 10 ?
                          notEmpty = false : notEmpty = true : null;
                        });
                      },
                      onTap: () {
                        setState(() {
                          isFocused = true;
                        });
                      },
                      onSubmitted: (value) {
                        setState(() {
                          isFocused = false;
                        });
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
          Visibility(
              visible: notEmpty == true,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: MediaQuery
                      .of(context)
                      .size
                      .width * 0.2),
                  child: Text("Please enter your phone number",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.red,
                    ),),
                ),
              )
          ),
          SizedBox(height: 30,),
          GestureDetector(
            onTap: () {
              setState(() {
                phoneNumberController.text.length == 10
                    ?
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) {
                      return OTPScreen();
                    },
                  ),
                ) :
                setState(() {
                  notEmpty = true;
                });
              });
            },
            child: Container(
              height: 30,
              width: 100,
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Center(
                child: Text("Get OTP",
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Colors.white),),
              ),
            ),
          ),
          Spacer(),
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(200),
                  ),
                  color: Colors.green,
                ),
                width: 195,
                height: 200,
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(200),),
                  color: Colors.blue[300],
                ),
                width: 196,
                height: 200,
              ),
            ],
          )
        ],
      ),
    );
  }
}
