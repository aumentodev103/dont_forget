import 'package:dont_forget/widgets/login_card.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  static const routeName = "/Login-SignUp";
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      body: Stack(
        children: <Widget>[
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.red,
                  Colors.purple,
                  Colors.purple,
                  Colors.redAccent,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomRight,
                stops: [0, 0.5, 0.5, 1],
              ),
            ),
          ),
          SingleChildScrollView(
            child: Center(
              child: Container(
                width: deviceSize.width,
                height: deviceSize.height,
                padding: EdgeInsets.only(
                  top: deviceSize.height / 10,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 30.0),
                      child: Column(
                        children: [
                          const Text(
                            "Don't Forget",
                            style: TextStyle(
                              fontFamily: "VujahdayScript",
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Divider(
                            color: Colors.white,
                            height: 15,
                            thickness: 1,
                            indent: deviceSize.width / 5,
                            endIndent: deviceSize.width / 5,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: deviceSize.width / 1.1,
                      height: deviceSize.height / 1.5,
                      decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(15)),
                        color: const Color.fromRGBO(255, 255, 255, 1)
                            .withOpacity(0.9),
                      ),
                      child: SingleChildScrollView(
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            children: const [
                              Padding(
                                padding: EdgeInsets.only(bottom: 20.0),
                                child: Text(
                                  "Login",
                                  style: TextStyle(
                                    fontSize: 24,
                                    color: Color.fromRGBO(0, 0, 0, 0.5),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              LoginCard(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
