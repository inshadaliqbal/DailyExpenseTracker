import 'package:dailyexpensetracker/bottombar.dart';
import 'package:dailyexpensetracker/constants.dart';
import 'package:dailyexpensetracker/extracted_widgets.dart';
import 'package:dailyexpensetracker/home_page.dart';
import 'package:dailyexpensetracker/provider_engine.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegistrationPage extends StatefulWidget {
  static const String registrationScreen = 'registration_screen';

  const RegistrationPage({Key? key}) : super(key: key);

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  String? email;
  String? password;
  String? name;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.black,
      body: SafeArea(
        child: BlurryHUD(
          childWidget: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 30.0, horizontal: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 150.0, top: 50),
                      child: Text(
                        'Welcome!',
                        style: kMainTextstyleWelcomePage,
                      ),
                    ),
                    Text(
                      'Please register',
                      style: TextStyle(color: Colors.white),
                    ),
                    MainTextField(
                        hintText: 'Name',
                        textfieldFunction: (value) {
                          name = value;
                        }),
                    MainTextFieldSign(
                      label: 'EMAIL',
                      changeFunction: (value) {
                        email = value;
                      },
                    ),
                    MainTextFieldPassword(
                      label: 'PASSWORD',
                      changeFunction: (value) {
                        password = value;
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    MainButton(
                      title: 'REGISTER',
                      buttonFunction: () async {
                        bool returnedData = await Provider.of<MainEngine>(
                          context,
                          listen: false,
                        ).signUP(email, password, name);
                        if (returnedData) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return BottomBar();
                              },
                            ),
                          );
                        } else {}
                      },
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account? ",
                      style: TextStyle(color: Colors.white),
                    ),
                    GestureDetector(
                      onTap: () {
                        // Navigator.pop(context);
                        // Navigator.pushNamed(context, LoginPage.loginPage);
                      },
                      child: Text(
                        'Sign IN',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
