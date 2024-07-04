import 'package:dailyexpensetracker/bottombar.dart';
import 'package:dailyexpensetracker/constants.dart';
import 'package:dailyexpensetracker/extracted_widgets.dart';
import 'package:dailyexpensetracker/home_page.dart';
import 'package:dailyexpensetracker/provider_engine.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class LoginPage extends StatelessWidget {
  static const loginPage = 'login_page';

  LoginPage({Key? key});

  String? email;
  String? password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.black,
      body: SafeArea(
        child: BlurryHUD(
          childWidget: Padding(
            padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 10.0),
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
                        'Welcome Back!',
                        style: kMainTextstyleWelcomePage,
                      ),
                    ),
                    Text(
                      'Please login to your account',
                      style: TextStyle(color: Colors.white),
                    ),
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
                    SizedBox(height: 10),
                    MainButton(
                      title: 'Sign IN',
                      buttonFunction: () async {
                        Navigator.pushNamed(context, HomePage.homePage);
                        bool returnedData = await Provider.of<MainEngine>(
                          context,
                          listen: false,
                        ).signIN(email, password);
                        if (returnedData) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return BottomBar();
                              },
                            ),
                          );
                        } else {
                          // Handle failure case
                        }
                      },
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account? ",
                      style: TextStyle(color: Colors.white),
                    ),
                    GestureDetector(
                      onTap: () {
                        // Navigator.pop(context);
                        // Navigator.pushNamed(
                        //   context,
                        //   RegistrationPage.registrationScreen,
                        // );
                      },
                      child: Text(
                        'Sign UP',
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
