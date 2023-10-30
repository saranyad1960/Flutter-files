import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:MobileAppNew/app/registration_screen.dart';

import 'custom_loader.dart';
import 'mobile_no_screen.dart';

class OTPScreen extends StatefulWidget {
  const OTPScreen();


  @override
  State<OTPScreen> createState() => OTPScreenState();
}

class OTPScreenState extends State<OTPScreen> {
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());
  final List<TextEditingController> _controllers = List.generate(6, (index) => TextEditingController());
  int countdown = 60;
  bool isCounting = false;
  late Timer _timer;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  int OTP = 444444;
  int? enteredOTP1;
  bool verifyOTP = false;
  bool enterOTP = false;
  bool correctOTP = false;

  void _showCustomSnackbar(BuildContext context) {
    final overlayState = Overlay.of(context);
    OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) {
        return Positioned(
          top: 30,
          left: 10,
          right: 10,
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: 200, 
              height: 100,
              child: ShakeTransition(
                offset: 20,
                duration: 500,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Center(
                    child: Text(
                      'Your 6-digit OTP is - \n $OTP',
                      style: TextStyle(color: Colors.white,fontSize: 15,fontWeight: FontWeight.w500),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );

    overlayState.insert(overlayEntry);
    Future.delayed(Duration(seconds: 3), () {
      overlayEntry.remove();
    });
  }

  void _showCustomSnackbar1(BuildContext context) {
    final overlayState = Overlay.of(context);
    OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) {
        return Positioned(
          top: 30,
          left: 10,
          right: 10,
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: 200,
              height: 100,
              child: ShakeTransition(
                offset: 20,
                duration: 500,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Center(
                    child: Text(
                      'Please enter the correct OTP',
                      style: TextStyle(color: Colors.white,fontSize: 15,fontWeight: FontWeight.w500),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );

    overlayState.insert(overlayEntry);
    Future.delayed(Duration(seconds: 3), () {
      overlayEntry.remove();
    });
  }


  void startCountdown() {
    setState(() {
      isCounting = true;
    });

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        countdown--;
      });

      if (countdown == 0) {
        timer.cancel();
        isCounting = false;
      }
    });
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      startCountdown();
      _showCustomSnackbar(context);
    });
    super.initState();
  }


  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    _timer.cancel();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(top: 50),
                child: GestureDetector(
                  onTap: (){
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) {
                          return MobileScreen(); // Replace NextPage with the actual page you want to navigate to
                        },
                      ),
                    );
                  },
                  child: Icon(Icons.arrow_back,
                    color: Colors.red,
                  ),
                ),
              )),
          Container(
          height: 200,
          width: 200,
          child: Center(
            child: Image.asset('assets/KJ-store-image.jpg',height: 200,width: 500,)),
          ),
          SizedBox(height: 20,),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text("Enter your 6-digit OTP here",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.5,),
              ),
            ),
          ),
          SizedBox(height: 20,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(6, (index) {
              _focusNodes[index].addListener(() {
                setState(() {});
              });
              return SizedBox(
                width: 40, // Adjust the width as needed
                child: TextField(
                  cursorColor: Colors.red,
                  controller: _controllers[index],
                  focusNode: _focusNodes[index],
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  maxLength: 1,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')), // Allow only numeric input
                  ],
                  decoration: InputDecoration(
                    counterText: "",
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    hintText: _focusNodes[index].hasFocus ? '' : '*',
                    hintStyle: TextStyle(color:Colors.grey),
                    contentPadding: const EdgeInsets.all(10),
                  ),
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      if (index < 5) {
                        FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
                        setState(() {
                          _focusNodes[index].hasFocus;
                          enterOTP = true;
                        });
                      }
                    } else {
                      if (index > 0) {
                        FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
                      }
                    }
                    String enteredOTP = _controllers.map((controller) => controller.text).join();
                    enteredOTP1 = int.parse(enteredOTP);
                    print("kj enteredOTP:$enteredOTP1");
                    setState(() {});
                    OTP == enteredOTP1 ? correctOTP = true : correctOTP = false;
                  },
                ),
              );
            }),
          ),
          SizedBox(height: 10,),
          countdown != 0 ?
          Visibility(
            visible: verifyOTP == false,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'OTP expires in $countdown seconds',
                style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500,color: Colors.red),
              ),
            ),
          ):
          Visibility(
            visible: verifyOTP == false,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'OTP expired',
                style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500,color: Colors.red),
              ),
            ),
          ),
          SizedBox(height: 20,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GestureDetector(
                onTap: (){
                  enterOTP == true && correctOTP == true ?
                  verifyOTP = true : verifyOTP = false;

                  if (enterOTP == true && correctOTP == false) {
                    _showCustomSnackbar1(context);
                  } else if (enterOTP == true && correctOTP == true){
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => CustomLoadingScreen(),
                    ));
                    Timer(Duration(seconds: 5), () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) {
                            return PersonalDetails(); // Replace NextPage with the actual page you want to navigate to
                          },
                        ),
                      );
                    });
                  }
                },
                child: Container(
                  height: 30,
                  width: 100,
                  decoration: BoxDecoration(
                    color: countdown != 0 ? Colors.red : Colors.grey,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Center(
                    child: Text("Verify OTP",
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Colors.white),),
                  ),
                ),
              ),
              GestureDetector(
                onTap: (){
                  countdown == 0 ?
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) {
                        return OTPScreen(); // Replace NextPage with the actual page you want to navigate to
                      },
                    ),
                  ) : null;
                },
                child: Container(
                  height: 30,
                  width: 100,
                  decoration: BoxDecoration(
                    color: countdown == 0 ? Colors.red : Colors.grey,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Center(
                    child: Text("Resend OTP",
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Colors.white),),
                  ),
                ),
              ),
            ],
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
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(200),),
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


class ShakeTransition extends StatefulWidget {
  final double offset;
  final int duration;
  final Widget child;

  ShakeTransition({
    required this.child,
    this.offset = 5.0,
    this.duration = 500,
  });

  @override
  _ShakeTransitionState createState() => _ShakeTransitionState();
}

class _ShakeTransitionState extends State<ShakeTransition>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: widget.duration),
    );
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      child: widget.child,
      tween: Tween(begin: 0.0, end: widget.offset),
      duration: Duration(milliseconds: widget.duration),
      curve: Curves.elasticOut,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, value),
          child: child,
        );
      },
    );
  }



  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}



