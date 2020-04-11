import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modernui/examples/login/widgets/login_input.dart';
import 'package:modernui/examples/login/widgets/social_auth.dart';
import 'package:modernui/examples/login/widgets/welcome_back.dart';
import 'package:modernui/utils/responsive.dart';
import 'package:modernui/widgets/rounded_button.dart';

class LoginPage extends StatefulWidget {
  static final routeName = "Login";
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.init(context);
    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.white,
          child: SafeArea(
            top: false,
            child: LayoutBuilder(
              builder: (_, constraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        WelcomeBack(),
                        SizedBox(
                          height: responsive.ip(2.5),
                        ),
                        ConstrainedBox(
                          constraints: BoxConstraints(maxWidth: 330),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              LoginInput(
                                iconPath: 'assets/login/email.svg',
                                placeholder: "Email address",
                                keyboardType: TextInputType.emailAddress,
                                obscureText: true,
                              ),
                              SizedBox(
                                height: responsive.ip(1.5),
                              ),
                              LoginInput(
                                iconPath: 'assets/login/password.svg',
                                placeholder: "Password",
                                obscureText: true,
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Container(
                                width: double.infinity,
                                alignment: Alignment.centerRight,
                                child: CupertinoButton(
                                  padding: EdgeInsets.zero,
                                  child: Container(
                                    child: Text(
                                      "Forgot password",
                                      style: TextStyle(
                                          fontFamily: 'sans',
                                          fontWeight: FontWeight.w400,
                                          letterSpacing: 0.5),
                                    ),
                                  ),
                                  onPressed: () {},
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              RoundedButton(
                                text: "Sign in",
                                fontSize: 20,
                                onPressed: () {},
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              Text("Or continue with"),
                              SizedBox(
                                height: 10,
                              ),
                              SocialAuth(),
                              SizedBox(
                                height: responsive.ip(3),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    "Don't have an account?",
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  SizedBox(width: 10),
                                  CupertinoButton(
                                    padding: EdgeInsets.zero,
                                    child: Container(
                                      child: Text(
                                        "Sign Up",
                                        style: TextStyle(
                                            fontFamily: 'sans',
                                            fontWeight: FontWeight.w700,
                                            letterSpacing: 0.5),
                                      ),
                                    ),
                                    onPressed: () {},
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
