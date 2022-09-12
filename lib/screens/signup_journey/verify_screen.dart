import 'package:chat_translator/providers/auth_provider.dart';
import 'package:chat_translator/router/routes.dart';
import 'package:chat_translator/utils/color_const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class VerifyScreen extends StatefulWidget {
  const VerifyScreen({Key? key}) : super(key: key);

  @override
  State<VerifyScreen> createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider = Provider.of<AuthProvider>(context, listen: false);
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 130.h,
                ),
                const Icon(
                  Icons.message_rounded,
                  color: kBrandGreen,
                  size: 64,
                ),
                SizedBox(
                  height: 40.h,
                ),
                const Text(
                  "Almost Done",
                  style: TextStyle(
                      fontFamily: "Poppins", fontWeight: FontWeight.w700, fontSize: 28, color: kBrandGreen),
                ),
                SizedBox(
                  height: 16.h,
                ),
                Text(
                  "We've sent an email to",
                  style: TextStyle(
                      fontFamily: "Poppins", fontWeight: FontWeight.w500, fontSize: 18, color: Colors.grey[400]),
                ),
                Text(
                  "****************",
                  style: TextStyle(
                      fontFamily: "Poppins", fontWeight: FontWeight.bold, fontSize: 18, color: Colors.grey[800]),
                ),
                SizedBox(
                  height: 16.h,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50.0),
                  child: Text(
                    "Please check your junk/spam folder if needed.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: "Poppins", fontWeight: FontWeight.w500, fontSize: 18, color: Colors.grey[400]),
                  ),
                ),
                SizedBox(
                  height: 16.h,
                ),
                ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, Routes.SIGN_IN_SCREEN);
                    },
                    child: Text("Return To Sign In"))
              ],
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 25.h),
              child: Text("You'll be automatically redirected after verifying your email",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.grey[400])),
            )
          ],
        ),
      ),
    );
  }
}
