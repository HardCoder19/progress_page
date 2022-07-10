import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';
import 'final_file.dart';

class multiForm extends StatefulWidget {
  @override
  _FormState createState() => _FormState();
}

class _FormState extends State<multiForm> with InputValidationMixin {
  final formGlobalKey = GlobalKey<FormState>();
  final formGlobalKey1 = GlobalKey<FormState>();
  int _activeStepIndex = 0;
  FilePickerResult? result;
  PlatformFile? file;
  File? image;

  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController mobile = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController pincode = TextEditingController();

  List<Step> stepList() => [
        Step(
          state: _activeStepIndex <= 0 ? StepState.indexed : StepState.complete,
          isActive: _activeStepIndex >= 0,
          title: const Text('Personal'),
          content: Form(
            key: formGlobalKey,
            child: Column(
              children: [
                TextFormField(
                  controller: name,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Full Name',
                  ),
                  validator: (value) {
                    String patttern = r'(^[a-zA-Z ]*$)';
                    RegExp regExp = new RegExp(patttern);
                    if (value?.length == 0) {
                      return "Name is Required";
                    } else if (!regExp.hasMatch(value!)) {
                      return "Name must be a-z and A-Z";
                    } else if (value.length < 3) {
                      return 'Name must be more than 2 charater';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 8,
                ),
                TextFormField(
                  controller: email,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Email',
                  ),
                  validator: (email) {
                    if (isEmailValid(email!)) {
                      return null;
                    } else {
                      return 'Enter a valid email address';
                    }
                  },
                ),
                const SizedBox(
                  height: 8,
                ),
                TextFormField(
                  controller: mobile,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Mobile Number',
                  ),
                  validator: (number) {
                    if (isMobileValid(number!))
                      return null;
                    else
                      return 'Enter a valid mobile number';
                  },
                ),
              ],
            ),
          ),
        ),
        Step(
            state:
                _activeStepIndex <= 1 ? StepState.indexed : StepState.complete,
            isActive: _activeStepIndex >= 1,
            title: const Text('Address'),
            content: Form(
              key: formGlobalKey1,
              child: Column(
                children: [
                  const SizedBox(
                    height: 8,
                  ),
                  TextFormField(
                    controller: address,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Full House Address',
                    ),
                    validator: (value) {
                      if (value?.length == 0) {
                        return "address is Required";
                      } else if ((value?.length)! < 3) {
                        return 'address must be more than 2 charater';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  TextFormField(
                    controller: pincode,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Pin Code',
                    ),
                    validator: (value) {
                      if (value?.length == 0) {
                        return "Pincode is Required";
                      } else if ((value?.length)! != 6) {
                        return 'Invalid Pincode';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            )),
        Step(
            state:
                _activeStepIndex <= 2 ? StepState.indexed : StepState.complete,
            isActive: _activeStepIndex >= 2,
            title: const Text('File'),
            content: Column(
              children: [
                ovalDisplay(),
                ElevatedButton(
                  onPressed: () async {
                    result = await FilePicker.platform.pickFiles(
                      type: FileType.custom,
                      allowedExtensions: ['jpg', 'pdf', 'png', 'jpeg'],
                    );
                    if (result == null) return;

                    file = result!.files.first;

                    setState(() {
                      this.image = null;
                    });
                  },
                  child: Text('Pick File'),
                ),
                ElevatedButton(
                    onPressed: () async {
                      final image = await ImagePicker()
                          .pickImage(source: ImageSource.camera);
                      if (image == null) return;
                      final imgTemp = File(image.path);

                      setState(() {
                        print(imgTemp.uri);
                        this.image = imgTemp;
                        this.file = null;
                      });
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Icon(
                        Icons.camera_alt_rounded,
                        size: 35,
                      ),
                    ))
              ],
            )),
        Step(
            state: StepState.complete,
            isActive: _activeStepIndex >= 3,
            title: const Text('Confirm'),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text('Name: ${name.text}'),
                Text('Email: ${email.text}'),
                Text('Mobile: ${mobile.text}'),
                Text('Address : ${address.text}'),
                Text('PinCode : ${pincode.text}'),
                Text('File Name : ${FinalFile(file, image).name1}'),
              ],
            ))
      ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Form'),
      ),
      body: Stepper(
        type: StepperType.horizontal,
        currentStep: _activeStepIndex,
        steps: stepList(),
        onStepContinue: () {
          if (_activeStepIndex < (stepList().length - 1)) {
            if (_activeStepIndex == 0) {
              if (formGlobalKey.currentState!.validate()) {
                formGlobalKey.currentState!.save();
                setState(() {
                  _activeStepIndex += 1;
                });
              }
            } else if (_activeStepIndex == 1) {
              if (formGlobalKey1.currentState!.validate()) {
                formGlobalKey1.currentState!.save();
                setState(() {
                  _activeStepIndex += 1;
                });
              }
            } else if (_activeStepIndex == 2) {
              if (file != null) {
                setState(() {
                  _activeStepIndex += 1;
                });
              } else if (image != null) {
                setState(() {
                  _activeStepIndex += 1;
                });
              } else {
                showAlertDialog(context);
              }
            }
          } else {
            print('Submitted');
          }
        },
        onStepCancel: () {
          if (_activeStepIndex == 0) {
            return;
          }

          setState(() {
            _activeStepIndex -= 1;
          });
        },
        // onStepTapped: (int index) {
        //   setState(() {
        //     _activeStepIndex = index;
        //   });
        // },
        controlsBuilder: (context, ControlsDetails details) {
          final isLastStep = _activeStepIndex == stepList().length - 1;
          return Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: details.onStepContinue,
                  child:
                      (isLastStep) ? const Text('Submit') : const Text('Next'),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              if (_activeStepIndex > 0)
                Expanded(
                  child: ElevatedButton(
                    onPressed: details.onStepCancel,
                    child: const Text('Back'),
                  ),
                )
            ],
          );
        },
      ),
    );
  }

  String filename() {
    if (image != null) {
      return image!.path.split('/').last;
    } else if (file != null) {
      return file!.name;
    } else {
      return '';
    }
  }

  Widget ovalDisplay() {
    if (image != null) {
      return ClipOval(
          child: Image.file(
        image!,
        width: 100,
        height: 100,
        fit: BoxFit.cover,
      ));
    } else if (file != null) {
      return ClipOval(
        child: Image.file(
          File(file!.path!),
          width: 100,
          height: 100,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => ClipOval(
              child: Container(
            color: Colors.lightBlue,
            height: 100.0,
            width: 100.0,
            child: Center(
                child: Text(
              file!.name[0],
              style: const TextStyle(color: Colors.white, fontSize: 24),
              textAlign: TextAlign.center,
            )),
          )),
        ),
      );
    } else {
      return ClipOval(
          child: Container(
        color: Colors.lightBlue,
        height: 100.0,
        width: 100.0,
      ));
    }
  }
}

showAlertDialog(BuildContext context) {
  // Create button
  Widget okButton = TextButton(
    child: const Text("OK"),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );

  // Create AlertDialog
  AlertDialog alert = AlertDialog(
    title: const Text("Alert"),
    content: const Text("Please select file"),
    actions: [
      okButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

Widget fileDetails(PlatformFile file) {
  final kb = file.size / 1024;
  final mb = kb / 1024;
  final size =
      (mb >= 1) ? '${mb.toStringAsFixed(2)} MB' : '${kb.toStringAsFixed(2)} KB';
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('File Name: ${file.name}'),
        Text('File Size: $size'),
        Text('File Extension: ${file.extension}'),
        Text('File Path: ${file.path}'),
      ],
    ),
  );
}

mixin InputValidationMixin {
  bool isMobileValid(String mobile) => mobile.length == 10;

  bool isEmailValid(String email) {
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = RegExp(pattern);
    return regex.hasMatch(email);
  }
}
