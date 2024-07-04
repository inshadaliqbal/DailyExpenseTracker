import 'package:dailyexpensetracker/widgets/extracted_widgets.dart';
import 'package:dailyexpensetracker/helpers/provider_engine.dart';
import 'package:dailyexpensetracker/pages/sign_in_page.dart';
import 'package:dailyexpensetracker/pages/sign_up_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../style/constants.dart';
class WelcomeScreen extends StatefulWidget {
  static const welcome_screen = 'WelcomeScreen';

  WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Provider.of<MainEngine>(context, listen: false).intializeApp();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              constraints: const BoxConstraints(minHeight: 200, minWidth: 150),
              child: const Image(
                image: AssetImage('image/welcome.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              'The easiest approach to handle your finances',
              style: kWelcomeScreenTextStyle,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.only(top: 100.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MainButton(title: 'Sign In', buttonFunction: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context){return LoginPage();}));
                  }),
                  const SizedBox(width: 20),
                  MainButton(title: 'Sign Up',buttonFunction: (){
                    // Navigator.pushNamed(context, LoginScreen.loginScreen);
                    Navigator.push(context, MaterialPageRoute(builder: (context){return RegistrationPage();}));
                  },),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
