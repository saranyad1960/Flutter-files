import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:MobileAppNew/app/home_page.dart';

import 'custom_loader.dart';

class PersonalDetails extends StatefulWidget {
  const PersonalDetails();


  @override
  State<PersonalDetails> createState() => PersonalDetailsState();
}

class PersonalDetailsState extends State<PersonalDetails> with SingleTickerProviderStateMixin{
  int currentTabIndex = 0;
  late List<Tab> tabs;
  TabController? _tabController;
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  TextEditingController aadhaarController = TextEditingController();
  TextEditingController panController = TextEditingController();
  TextEditingController storeNameController = TextEditingController();
  TextEditingController addrline1Controller = TextEditingController();
  TextEditingController addrline2Controller = TextEditingController();
  TextEditingController addrline3Controller = TextEditingController();
  TextEditingController pinCodeController = TextEditingController();
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());
  final List<TextEditingController> _controllers = List.generate(6, (index) => TextEditingController());
  FocusNode myFocusNode = FocusNode();
  FocusNode myFocusNode1 = FocusNode();
  FocusNode myFocusNode2 = FocusNode();
  FocusNode myFocusNode3 = FocusNode();
  FocusNode myFocusNode4 = FocusNode();
  FocusNode myFocusNode5 = FocusNode();
  FocusNode myFocusNode6 = FocusNode();
  FocusNode myFocusNode7 = FocusNode();
  FocusNode myFocusNode8 = FocusNode();
  FocusNode myFocusNode9 = FocusNode();
  FocusNode myFocusNode10 = FocusNode();
  DateTime? selectedDate;
  bool isChecked = false;
  XFile? pickedFile;
  Widget? pickedImage;
  int countdown = 60;
  bool isCounting = false;
  late Timer _timer;
  bool verifyOTP = false;
  late Stream<int> countdownStream;
  late StreamSubscription<int> countdownSubscription;
  bool countdownExpired = false;
  AlertDialog? alertDialog;
  String selectedGender = '';


  Map<String, List<String>> countryCities = {
    'India': ['Delhi', 'Mumbai', 'Bangalore', 'Chennai'],
    'Canada': ['Toronto', 'Vancouver', 'Montreal', 'Calgary'],
    'Australia': ['Sydney', 'Melbourne', 'Brisbane', 'Perth'],
  };

  String? selectedCountry;
  String? selectedCity;

  bool areTextFieldsFilled() {
    return _controllers.every((controller) => controller.text.isNotEmpty);
  }

  Stream<int> createCountdownStream() async* {
    for (int i = countdown; i >= 0; i--) {
      yield i;
      if (i > 0) {
        await Future.delayed(Duration(seconds: 1));
      }
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final ImagePicker _picker = ImagePicker();
    final XFile? newPickedFile = await _picker.pickImage(source: source);

    setState(() {
      pickedFile = newPickedFile;
      if (pickedFile != null) {
        pickedImage = Image.file(File(pickedFile!.path));
      }
    });
  }

  void startCountdown() {
    countdownSubscription = countdownStream.listen((int newCountdown) {
      setState(() {
        countdown = newCountdown;
      });
    });
  }

  void showAlertDialog(BuildContext context) {
    countdown = 60;
    countdownStream = createCountdownStream();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
           return alertDialog =  AlertDialog(
              title: Text("Email Verification"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("OTP sent to your email for verification."),
                  SizedBox(height: 30),
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
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
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
                            hintStyle: TextStyle(color: Colors.grey),
                            contentPadding: const EdgeInsets.all(10),
                          ),
                          onChanged: (value) {
                            if (value.isNotEmpty) {
                              if (index < 5) {
                                FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
                              }
                            } else {
                              if (index > 0) {
                                FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
                              }
                            }
                          },
                        ),
                      );
                    }),
                  ),
                  Visibility(
                    visible: verifyOTP == false,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: StreamBuilder<int>(
            stream: countdownStream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                int currentCountdown = snapshot.data!;
                if (currentCountdown > 1) {
                  countdownExpired = false;
                  Future.delayed(Duration.zero, () {
                    setState(() {});
                  });
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'OTP expires in $currentCountdown seconds',
                      style: TextStyle(fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Colors.red),
                    ),
                  );
                } else if (currentCountdown == 1) {
                  countdownExpired = false;
                  Future.delayed(Duration.zero, () {
                    setState(() {});
                  });
                  return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'OTP expires in $currentCountdown second',
                        style: TextStyle(fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Colors.red),
                      ));
                }
               else  if (currentCountdown == 0){
                   countdownExpired = true;
                   Future.delayed(Duration.zero, () {
                     setState(() {});
                   });
                return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'OTP expired',
                      style: TextStyle(fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Colors.red),
                    ));
              }}
              return Text("",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.red));
            }
        ),
                    ),
                  ),
                  SizedBox(height: 10,),
                ],
              ),
              actions: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          if (areTextFieldsFilled()) {
                            setState(() {
                              verifyOTP = true;
                              Navigator.of(context).pop();
                            });
                          } else {
                          }
                        },
                        child: Container(
                          height: 30,
                          width: 100,
                          decoration: BoxDecoration(
                              color: countdownExpired == false ? Colors.red : Colors.grey,
                              borderRadius: BorderRadius.circular(5)),
                          child: Center(
                              child: Text(
                                "Verify OTP",
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
                              )),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        if(countdownExpired == true) {
                          setState(() {
                            _controllers.forEach((controller) =>
                                controller.clear());
                            verifyOTP = false;
                            countdownStream = createCountdownStream();
                          });
                        }else{}
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: 30,
                          width: 100,
                          decoration: BoxDecoration(
                              color: countdownExpired == false ? Colors.grey : Colors.red,
                              borderRadius: BorderRadius.circular(5)),
                          child: Center(
                              child: Text(
                                "Resend OTP",
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
                              )),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != selectedDate) {
      final formattedDate = DateFormat('dd-MM-yyyy').format(picked);
      setState(() {
        selectedDate = picked;
        dobController.text = formattedDate;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    tabs = <Tab>[
      buildRegistrationStep(
        icon: Icons.account_circle,
        text: 'User Profile',
      ),
      buildRegistrationStep(
        icon: Icons.store,
        text: 'Store Profile',
      ),
      buildRegistrationStep(
        icon: Icons.lock,
        text: 'Privacy Policy',
      ),
    ];
  }

  @override
  void dispose() {
    myFocusNode.dispose();
    myFocusNode1.dispose();
    for (var controller in _controllers) {
      controller.dispose();
    }
    _timer.cancel();
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.redAccent,
          title: Center(child: Text('Registration')),
        ),
        body: Column(
          children: [
            if (currentTabIndex == 0)
              RegistrationStep(
                completionPercentage: 0,
                onContinue: () {
                  DefaultTabController.of(context)!.animateTo(1);
                },
              ),
            if (currentTabIndex == 1)
              RegistrationStep(
                completionPercentage: 40,
                onContinue: () {
                  DefaultTabController.of(context)!.animateTo(2);
                },
              ),
            if (currentTabIndex == 2)
              RegistrationStep(
                completionPercentage: 80,
                onContinue: () {
                },
              ),
            if (currentTabIndex == 3)
              RegistrationStep(
                completionPercentage: 100,
                onContinue: () {
                },
              ),
            SizedBox(height: 10,),
              IgnorePointer(
                ignoring: !isChecked ? true : false,
                child: TabBar(
                  controller: _tabController,
                  tabs: tabs.map((tab) {
                    return Container(
                      height: 80,
                      child: tab,
                    );
                  }).toList(),
                  labelColor: Colors.red,
                  unselectedLabelColor: Colors.red,
                  indicatorColor: Colors.green,
                  onTap: (index) {
                      setState(() {
                         //currentTabIndex = index;
                       });
                  },
                ),
              ),
            Expanded(
              child: TabBarView(
                  controller: _tabController,
                  children: [
                    SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text("First Name",style: TextStyle(
                                      fontSize: 15,
                                  color: Colors.black),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 5),
                                child: Text("*",style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.red),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: 50,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: myFocusNode.hasFocus ? Colors.red : Colors
                                      .grey,
                                ),
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              child: TextField(
                                cursorColor: Colors.red,
                                controller: firstNameController,
                                focusNode: myFocusNode,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z]')),
                                ],
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  hintText: "Enter your first name",
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.all(10.0),
                                  counterText: "",
                                ),
                                onChanged: (value) {
                                  setState(() {
                                  });
                                },
                                onTap: () {
                                  setState(() {
                                  });
                                },
                                onSubmitted: (value) {
                                  setState(() {
                                  });
                                },
                              ),
                            ),
                          ),
                          SizedBox(height: 10,),
                          Row(
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text("Last Name",style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.black),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 5),
                                child: Text("*",style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.red),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: 50,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: myFocusNode1.hasFocus ? Colors.red : Colors
                                      .grey,
                                ),
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              child: TextField(
                                cursorColor: Colors.red,
                                focusNode: myFocusNode1,
                                controller: lastNameController,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z]')),
                                ],
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  hintText: "Enter your last name",
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.all(10.0),
                                  counterText: "",
                                ),
                                onChanged: (value) {
                                  setState(() {
                                  });
                                },
                                onTap: () {
                                  setState(() {
                                  });
                                },
                                onSubmitted: (value) {
                                  setState(() {
                                  });
                                },
                              ),
                            ),
                          ),
                          SizedBox(height: 10,),
                          Row(
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text("D.O.B",style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.black),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 5),
                                child: Text("*",style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.red),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: 50,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: myFocusNode2.hasFocus ? Colors.red : Colors
                                      .grey,
                                ),
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              child: TextField(
                                cursorColor: Colors.red,
                                readOnly: true,
                                focusNode: myFocusNode2,
                                controller: dobController,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z]')),
                                ],
                                keyboardType: TextInputType.phone,
                                decoration: InputDecoration(
                                  hintText: "Date of Birth",
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.all(10.0),
                                  counterText: "",
                                ),
                                onChanged: (value) {
                                  setState(() {
                                  });
                                },
                                onTap: () {
                                 // setState(() {
                                    _selectDate(context);
                                  //});
                                },
                                onSubmitted: (value) {
                                  setState(() {
                                  });
                                },
                              ),
                            ),
                          ),
                          SizedBox(height: 10,),
                          Container(
                            width: double.infinity, // or use a specific width
                            child: Row(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text('Gender',style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black),),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 5),
                                  child: Text("* ",style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.red),
                                  ),
                                ),
                                Radio(
                                  value: 'Male',
                                  groupValue: selectedGender,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedGender = value!;
                                    });
                                  },
                                  activeColor: Colors.red,
                                ),
                                Text('Male'),
                                Radio(
                                  value: 'Female',
                                  groupValue: selectedGender,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedGender = value!;
                                    });
                                  },
                                  activeColor: Colors.red,
                                ),
                                Text('Female'),
                                Radio(
                                  value: 'Other',
                                  groupValue: selectedGender,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedGender = value!;
                                    });
                                  },
                                  activeColor: Colors.red,
                                ),
                                Text('Other'),
                              ],
                            ),
                          ),
                          SizedBox(height: 10,),
                          Row(
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text("Email",style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.black),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 5),
                                child: Text("*",style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.red),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: 50,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: myFocusNode3.hasFocus ? Colors.red : Colors
                                      .grey,
                                ),
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              child: TextField(
                                cursorColor: Colors.red,
                                focusNode: myFocusNode3,
                                controller: emailController,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z@.0-9]')),
                                ],
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  hintText: "Enter your email",
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.only(top: 15,left: 10),
                                  counterText: "",
                                  suffixIcon: verifyOTP == false ?
                                  Opacity(
                                    opacity: emailController.text.isNotEmpty ? 1.0 : 0.0,
                                    child: GestureDetector(
                                      onTap: (){
                                        if(emailController.text.isNotEmpty) {
                                          setState(() {
                                            showAlertDialog(context);
                                            countdownExpired = false;
                                          });
                                        }else{}
                                      },
                                      child: Container(
                                        height: 50,
                                        width: 100,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(5),
                                          color: Colors.red,
                                        ),
                                        child: Center(child: Text("Verify Email",
                                          style: TextStyle(color: Colors.white),),),
                                      ),
                                    ),
                                  )
                                  : Icon(Icons.check_circle,
                                    color: Colors.green,
                                    size: 24,),
                                ),
                                onChanged: (value) {
                                  setState(() {
                                  });
                                },
                                onTap: () {
                                  setState(() {
                                  });
                                },
                                onSubmitted: (value) {
                                  setState(() {
                                  });
                                },
                              ),
                            ),
                          ),
                          SizedBox(height: 10,),
                          Row(
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text("Aadhaar No.",style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.black),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 5),
                                child: Text("*",style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.red),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: 50,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: myFocusNode4.hasFocus ? Colors.red : Colors
                                      .grey,
                                ),
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              child: TextField(
                                cursorColor: Colors.red,
                                controller: aadhaarController,
                                maxLength: 12,
                                focusNode: myFocusNode4,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                                ],
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  hintText: "Enter your aadhaar here",
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.all(10.0),
                                  counterText: "",
                                ),
                                onChanged: (value) {
                                  setState(() {
                                  });
                                },
                                onTap: () {
                                  setState(() {
                                  });
                                },
                                onSubmitted: (value) {
                                  setState(() {
                                  });
                                },
                              ),
                            ),
                          ),
                          SizedBox(height: 10,),
                          Row(
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text("PAN No.",style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.black),
                                  ),
                                ),
                              ),
                              Text("(optional)",style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.red),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: 50,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: myFocusNode5.hasFocus ? Colors.red : Colors
                                      .grey,
                                ),
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              child: TextField(
                                cursorColor: Colors.red,
                                controller: panController,
                                maxLength: 10,
                                focusNode: myFocusNode5,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(RegExp(r'[0-9A-Z]')),
                                ],
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  hintText: "Enter your pan no.",
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.all(10.0),
                                  counterText: "",
                                ),
                                onChanged: (value) {
                                  setState(() {
                                  });
                                },
                                onTap: () {
                                  setState(() {
                                  });
                                },
                                onSubmitted: (value) {
                                  setState(() {
                                  });
                                },
                              ),
                            ),
                          ),
                          SizedBox(height: 20,),
                          GestureDetector(
                            onTap: (){
                              if (firstNameController.text.isNotEmpty &&
                                  lastNameController.text.isNotEmpty &&
                                  dobController.text.isNotEmpty &&
                                  selectedGender.isNotEmpty &&
                                  verifyOTP == true &&
                                  aadhaarController.text.isNotEmpty) {
                                setState(() {
                                print("currentTabIndex: $currentTabIndex");
                                _tabController?.animateTo(1);
                                currentTabIndex = 1;
                                });
                              }
                            },
                            child: Container(
                              height: 30,
                              width: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: (firstNameController.text.isNotEmpty && lastNameController.text.isNotEmpty
                                && dobController.text.isNotEmpty && selectedGender.isNotEmpty && verifyOTP == true &&
                                aadhaarController.text.isNotEmpty) ?
                                Colors.red : Colors.grey,
                              ),
                              child: Center(child: Text("Continue",style: TextStyle(
                                fontSize: 15,fontWeight: FontWeight.w500,color: Colors.white,
                              ),),),
                            ),
                          ),
                          SizedBox(height: 20,),
                        ],
                      ),
                    ),
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text("Store Name",style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.black),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 5),
                                child: Text("*",style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.red),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: 50,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: myFocusNode6.hasFocus ? Colors.red : Colors
                                      .grey,
                                ),
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              child: TextField(
                                cursorColor: Colors.red,
                                controller: storeNameController,
                                focusNode: myFocusNode6,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z]')),
                                ],
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  hintText: "Enter your store name",
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.all(10.0),
                                  counterText: "",
                                ),
                                onChanged: (value) {
                                  setState(() {
                                  });
                                },
                                onTap: () {
                                  setState(() {
                                  });
                                },
                                onSubmitted: (value) {
                                  setState(() {
                                  });
                                },
                              ),
                            ),
                          ),
                          SizedBox(height: 10,),
                          Row(
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text("Address Line 1",style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.black),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 5),
                                child: Text("*",style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.red),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: 50,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: myFocusNode7.hasFocus ? Colors.red : Colors
                                      .grey,
                                ),
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              child: TextField(
                                cursorColor: Colors.red,
                                controller: addrline1Controller,
                                focusNode: myFocusNode7,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z0-9/-]')),
                                ],
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  hintText: "Enter your store address",
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.all(10.0),
                                  counterText: "",
                                ),
                                onChanged: (value) {
                                  setState(() {
                                  });
                                },
                                onTap: () {
                                  setState(() {
                                  });
                                },
                                onSubmitted: (value) {
                                  setState(() {
                                  });
                                },
                              ),
                            ),
                          ),
                          SizedBox(height: 10,),
                          Row(
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text("Address Line 2",style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.black),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 5),
                                child: Text("*",style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.red),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: 50,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: myFocusNode8.hasFocus ? Colors.red : Colors
                                      .grey,
                                ),
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              child: TextField(
                                cursorColor: Colors.red,
                                controller: addrline2Controller,
                                focusNode: myFocusNode8,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z0-9/-]')),
                                ],
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  hintText: "Enter your store address",
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.all(10.0),
                                  counterText: "",
                                ),
                                onChanged: (value) {
                                  setState(() {
                                  });
                                },
                                onTap: () {
                                  setState(() {
                                  });
                                },
                                onSubmitted: (value) {
                                  setState(() {
                                  });
                                },
                              ),
                            ),
                          ),
                          SizedBox(height: 10,),
                          Row(
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text("Address Line 3",style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.black),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 5),
                                child: Text("*",style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.red),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: 50,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: myFocusNode9.hasFocus ? Colors.red : Colors
                                      .grey,
                                ),
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              child: TextField(
                                cursorColor: Colors.red,
                                controller: addrline3Controller,
                                focusNode: myFocusNode9,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z0-9/-]')),
                                ],
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  hintText: "Enter your store address",
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.all(10.0),
                                  counterText: "",
                                ),
                                onChanged: (value) {
                                  setState(() {
                                  });
                                },
                                onTap: () {
                                  setState(() {
                                  });
                                },
                                onSubmitted: (value) {
                                  setState(() {
                                  });
                                },
                              ),
                            ),
                          ),
                          SizedBox(height: 10,),
                          Row(
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text("City",style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.black),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 5),
                                child: Text("*",style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: Colors.red),
                                ),
                              ),
                              SizedBox(width: MediaQuery.of(context).size.width * 0.23),
                              Align(
                                alignment: Alignment.center,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text("Country",style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.black),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 5),
                                child: Text("*",style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.red),
                                ),
                              ),
                              SizedBox(width: MediaQuery.of(context).size.width * 0.16),
                              Align(
                                alignment: Alignment.center,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text("PIN Code",style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.black),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 5),
                                child: Text("*",style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.red),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top:8,left: 8,right: 10),
                                child: Container(
                                  width: 120,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey), // Set your desired border color
                                    borderRadius: BorderRadius.circular(5.0), // Add border radius for rounded corners
                                  ),
                                  child: DropdownButton<String>(
                                    value: selectedCity,
                                    hint: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text('City'),
                                    ),
                                    items: (selectedCountry != null)
                                        ? countryCities[selectedCountry]?.map((String city) {
                                      return DropdownMenuItem<String>(
                                        value: city,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(city),
                                        ),
                                      );
                                    }).toList()
                                        : [],
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        selectedCity = newValue;
                                      });
                                    },
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top:8,left: 10,right: 10),
                                child: Container(
                                  width: 120,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey), // Set your desired border color
                                    borderRadius: BorderRadius.circular(5.0), // Add border radius for rounded corners
                                  ),
                                  child: DropdownButton<String>(
                                    value: selectedCountry,
                                    hint: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text('Country'),
                                    ),
                                    items: countryCities.keys.map((String country) {
                                      return DropdownMenuItem<String>(
                                        value: country,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(country),
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        selectedCountry = newValue;
                                        selectedCity = null; // Reset the selected city
                                      });
                                    },
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top:8,left: 8,right: 8),
                                child: Container(
                                  width: MediaQuery.of(context).size.width * 0.25,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: myFocusNode10.hasFocus ? Colors.red : Colors
                                          .grey,
                                    ),
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                  child: TextField(
                                    cursorColor: Colors.red,
                                    controller: pinCodeController,
                                    focusNode: myFocusNode10,
                                    maxLength: 6,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                                    ],
                                    keyboardType: TextInputType.text,
                                    decoration: InputDecoration(
                                      hintText: "000000",
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.all(10.0),
                                      counterText: "",
                                    ),
                                    onChanged: (value) {
                                      setState(() {
                                      });
                                    },
                                    onTap: () {
                                      setState(() {
                                      });
                                    },
                                    onSubmitted: (value) {
                                      setState(() {
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10,),
                          Row(
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text("Store Image",style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.black),
                                  ),
                                ),
                              ),
                              Text("(optional)",style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.red),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () => _pickImage(ImageSource.gallery),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    color: Colors.grey.shade300,
                                    height: 100,
                                    width: 100,
                                    child: Center(
                                      child: Text("+",style: TextStyle(fontSize: 25,
                                          fontWeight: FontWeight.w500,
                                      color: Colors.black),),
                                    ),
                                  ),
                                ),
                              ),
                              if (pickedImage != null)
                                Stack(
                                  children: [
                                    Container(
                                      height: 100,
                                      width: 100,
                                      child: pickedImage!,
                                    ),
                                    Positioned(
                                      top: 70,
                                      right: 5,
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            pickedImage = null;
                                          });
                                        },
                                        child: Container(
                                          padding: EdgeInsets.all(8),
                                          color: Colors.transparent,
                                          child: Icon(
                                            Icons.delete,
                                            color: Colors.white,
                                            size: 20,
                                          ),
                                        ),
                                      ),
                                    ),
                            ],
                          ),
                          SizedBox(height: 20,),
                        ],
                      ),
                          SizedBox(height: 20,),
                          GestureDetector(
                            onTap: (){
                              if (storeNameController.text.isNotEmpty &&
                                  addrline1Controller.text.isNotEmpty &&
                                  addrline2Controller.text.isNotEmpty &&
                                  addrline3Controller.text.isNotEmpty &&
                                  selectedCity != null &&
                                  selectedCountry != null &&
                                  pinCodeController.text.isNotEmpty
                              ) {
                                setState(() {
                                  print("currentTabIndex: $currentTabIndex");
                                  _tabController?.animateTo(2);
                                  currentTabIndex = 2;
                                });
                              }
                            },
                            child: Container(
                              height: 30,
                              width: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: (storeNameController.text.isNotEmpty &&
                                    addrline1Controller.text.isNotEmpty &&
                                    addrline2Controller.text.isNotEmpty &&
                                    addrline3Controller.text.isNotEmpty &&
                                    selectedCity != null &&
                                    selectedCountry != null &&
                                    pinCodeController.text.isNotEmpty
                                ) ?
                                Colors.red : Colors.grey,
                              ),
                              child: Center(child: Text("Continue",style: TextStyle(
                                fontSize: 15,fontWeight: FontWeight.w500,color: Colors.white,
                              ),),),
                            ),
                          ),
                          SizedBox(height: 20,),
                        ])
                    ),
                    SingleChildScrollView(
                    child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 200),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Checkbox(
                              value: isChecked,
                              onChanged: (bool? newValue) {
                                setState(() {
                                  isChecked = newValue!;
                                });
                              },
                              activeColor: Colors.green,
                            ),
                            Text(
                              'I agree to the ',
                              style: TextStyle(
                                  fontSize: 15.0,
                                  letterSpacing: 0.5,
                                  fontWeight: FontWeight.w500,
                                ),
                            ),
                            Text(
                              'terms and conditions ',
                              style: TextStyle(
                                fontSize: 15.0,
                                letterSpacing: 0.5,
                                fontWeight: FontWeight.w500,
                                color: Colors.blue,
                                decoration: TextDecoration.underline,),
                            ),
                            Text(
                              'and ',
                              style: TextStyle(
                                  fontSize: 15.0,
                                  letterSpacing: 0.5,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        'privacy policy',
                        style: TextStyle(
                            fontSize: 15.0,
                            letterSpacing: 0.5,
                            fontWeight: FontWeight.w500,
                          color: Colors.blue,
                          decoration: TextDecoration.underline,),
                      ),
                      SizedBox(height: 30,),
                      GestureDetector(
                        onTap: (){
                          if (isChecked)
                          {
                            setState(() {
                               currentTabIndex = 3;
                               Timer(Duration(seconds: 2), () {
                               Navigator.of(context).push(MaterialPageRoute(
                                 builder: (context) => CustomLoadingScreen(),
                               ));
                               });
                               Timer(Duration(seconds: 5), () {
                                 Navigator.of(context).pushReplacement(
                                   MaterialPageRoute(
                                     builder: (context) {
                                       return HomePage(); // Replace NextPage with the actual page you want to navigate to
                                     },
                                   ),
                                 );
                               });
                            });
                          }
                        },
                        child: Container(
                          height: 30,
                          width: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: isChecked ?
                            Colors.red : Colors.grey,
                          ),
                          child: Center(child: Text("Continue",style: TextStyle(
                            fontSize: 15,fontWeight: FontWeight.w500,color: Colors.white,
                          ),),),
                        ),
                      ),
                      SizedBox(height: 20,),
                    ],
                  ),
              ),
                  ]
              ),
            ),
          ],
        ),
      ),
    );
  }

  Tab buildRegistrationStep({
    required IconData icon,
    required String text,
  }) {
    return Tab(
      child: Column(
        children: [
          Icon(icon,color: Colors.red,size: 40,),
          SizedBox(height: 8),
          Text(text),
        ],
      ),
    );
  }
}


class RegistrationStep extends StatelessWidget {
  final int completionPercentage;
  final VoidCallback onContinue;

  RegistrationStep({
    required this.completionPercentage,
    required this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        LinearProgressIndicator(
          value: completionPercentage / 100,
          backgroundColor: Colors.grey,
          color: Colors.green,
          minHeight: 10,
        ),
      ],
    );
  }
}
