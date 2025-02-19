import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:practice_7/presentation/widgets/widgets.dart';
import 'package:practice_7/utils/extension.dart';
import 'package:practice_7/utils/login_helper.dart';
import 'package:practice_7/utils/validator/validator.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

final formkeysignup = GlobalKey<FormState>();

class _RegisterScreenState extends State<RegisterScreen> {
  final ctlfname = TextEditingController();
  final ctllname = TextEditingController();
  final cltusername = TextEditingController();
  final cltpassword = TextEditingController();
  final cltconfirmpassword = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: Form(
          key: formkeysignup,
          child: Padding(
            padding: EdgeInsets.only(
              top: context.scrnHeight * 0.025,
              left: context.scrnWidth * 0.05,
              right: context.scrnWidth * 0.05,
            ),
            child: Column(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Container(
                        height: context.scrnHeight * 0.15,
                        width: context.scrnWidth * 0.3,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey.shade100,
                          border: Border.all(
                            color: Colors.black87,
                            width: 6,
                          ),
                        ),
                        child:
                            LottieBuilder.asset('assets/lottie/profile.json'),
                      ),
                      SizedBox(height: context.scrnHeight * .03),
                      TextFieldName(
                        labelText: 'First Name',
                        controller: ctlfname,
                        validator: (value) => nameValidator(
                          value,
                          fieldName: "First Name",
                        ),
                      ),
                      SizedBox(height: context.scrnHeight * .01),
                      TextFieldName(
                        labelText: 'Last Name',
                        controller: ctllname,
                        validator: (value) => nameValidator(
                          value,
                          fieldName: "Last Name",
                        ),
                      ),
                      SizedBox(height: context.scrnHeight * .01),
                      TextFieldName(
                        labelText: 'Username',
                        controller: cltusername,
                        validator: usernameValidator,
                      ),
                      SizedBox(height: context.scrnHeight * .01),
                      TextFieldPassword(
                        labelText: 'Password',
                        controller: cltpassword,
                        validator: passwordValidator,
                      ),
                      SizedBox(height: context.scrnHeight * .01),
                      TextFieldPassword(
                        labelText: 'Confirm Password',
                        controller: cltconfirmpassword,
                        validator: (value) => confirmPasswordValidator(
                          value,
                          cltpassword.text,
                        ),
                      ),
                      SizedBox(height: context.scrnHeight * .02),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero,
                          ),
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          minimumSize: Size(
                            double.infinity,
                            context.scrnHeight * 0.055,
                          ), // Added width
                        ),
                        onPressed: () async {
                          if (formkeysignup.currentState!.validate()) {
                            await LoginHelper.registerUser(
                              cltusername.text,
                              cltpassword.text,
                              ctlfname.text,
                              ctllname.text,
                            );
                            // Navigate to login page after successful registration
                            Navigator.pop(context);
                          }
                        },
                        child: Text(
                          'Register'.toUpperCase(),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w300,
                            fontFamily: GoogleFonts.poppins().fontFamily,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have account? ',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                        fontFamily: GoogleFonts.poppins().fontFamily,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Login',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontFamily: GoogleFonts.poppins().fontFamily,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: context.scrnHeight * .03),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
