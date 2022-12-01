import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:fp28/dashboard.dart';

class login extends StatefulWidget {
  const login({Key? key}) : super(key: key);

  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {
  TextEditingController n = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;
  String vid = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("LOG IN WITH PHONE NUMBER"),
      ),
      body: Container(
        child: Column(
          children: [
            TextField(
              controller: n,
              maxLength: 10,
              keyboardType: TextInputType.number,
            ),
            ElevatedButton(
                onPressed: () async {
                  String number = n.text;
                  await FirebaseAuth.instance.verifyPhoneNumber(
                    phoneNumber: '+91${number}',
                    verificationCompleted:
                        (PhoneAuthCredential credential) async {
                      print("verified");
                      await auth.signInWithCredential(credential);
                    },
                    verificationFailed: (FirebaseAuthException e) {
                      if (e.code == 'invalid-phone-number') {
                        print('The provided phone number is not valid.');
                      }
                    },
                    codeSent: (String verificationId, int? resendToken) {
                      print("Code Sent");
                      print("${vid}");
                      vid = verificationId;
                    },
                    codeAutoRetrievalTimeout: (String verificationId) {},
                  );
                },
                child: Text("Send OTP")),
            OtpTextField(
              numberOfFields: 6,
              borderColor: Color(0xFF512DA8),
              //set to true to show as box or false to show as dash
              showFieldAsBox: true,
              //runs when a code is typed in
              onCodeChanged: (String code) {
                //handle validation or checks here
              },
              //runs when every textfield is filled
              onSubmit: (String verificationCode) async {
                PhoneAuthCredential credential = PhoneAuthProvider.credential(
                    verificationId: vid, smsCode: verificationCode);
                print("navigator");
                auth.signInWithCredential(credential).then((value) {
                  Navigator.pushReplacement(context, MaterialPageRoute(
                    builder: (context) {
                      return dashboard();
                    },
                  ));
                });
              }, // end onSubmit
            ),
          ],
        ),
      ),
    );
  }
}
