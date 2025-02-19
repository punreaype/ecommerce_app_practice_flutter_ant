import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:practice_7/presentation/widgets/alert_dialog_login.dart';
import 'package:practice_7/presentation/widgets/text_field_name.dart';
import 'package:practice_7/presentation/widgets/text_field_password.dart';
import 'package:practice_7/routes/routes.dart';
import 'package:practice_7/utils/extension.dart';
import 'package:practice_7/utils/login_helper.dart';
import 'package:practice_7/utils/validator/validator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

final formkey = GlobalKey<FormState>();

class _LoginScreenState extends State<LoginScreen> {
  final cltusername = TextEditingController();
  final cltpassword = TextEditingController();

  bool isvisable = true;

  void login() async {
    if (formkey.currentState!.validate()) {
      if (await LoginHelper.checkUserExists(
          cltusername.text, cltpassword.text)) {
        var pref = await SharedPreferences.getInstance();

        pref.setString('username', cltusername.text);
        await pref.setBool('isLoggedIn', true);

        Navigator.pushReplacementNamed(
          context,
          Routes.navBar,
          arguments: cltusername.text,
        );
      } else {
        showDialog(
          context: context,
          builder: (context) => const AnimatedAlertDialog(),
        );
      }
    }
  }

  @override
  void dispose() {
    cltusername.dispose();
    cltpassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: Form(
        key: formkey,
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'R S',
                      style: TextStyle(
                        fontSize: 70,
                        fontFamily: GoogleFonts.pacifico().fontFamily,
                      ),
                    ),
                    SizedBox(height: context.scrnHeight * .03),
                    TextFieldName(
                      labelText: 'Username',
                      controller: cltusername,
                      validator: usernameValidator,
                    ),
                    SizedBox(height: context.scrnHeight * .02),
                    TextFieldPassword(
                      controller: cltpassword,
                      labelText: 'Password',
                      validator: passwordValidator,
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
                          context.scrnHeight * 0.055, // Added height
                        ), // Added width
                      ),
                      onPressed: login,
                      child: Text(
                        'Login'.toUpperCase(),
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
                    'Don\'t have account? ',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                      fontFamily: GoogleFonts.poppins().fontFamily,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        Routes.register,
                      );
                    },
                    child: Text(
                      'Register',
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
    );
  }
}
