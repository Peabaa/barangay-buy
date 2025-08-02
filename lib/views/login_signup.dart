import 'package:flutter/material.dart';
import '../controllers/login_signup_screen_controller.dart';
import '../models/login_signup_screen_model.dart';

class LoginSignupScreen extends StatefulWidget {
  const LoginSignupScreen({super.key});

  @override
  State<LoginSignupScreen> createState() => _LoginSignupScreenState();
}

class _LoginSignupScreenState extends State<LoginSignupScreen> {
  late LoginSignupScreenModel _model;

  @override
  void initState() {
    super.initState();
    _model = const LoginSignupScreenModel();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    
    double relWidth(double dp) => LoginSignupScreenController.calculateRelativeWidth(dp, screenWidth);
    double relHeight(double dp) => LoginSignupScreenController.calculateRelativeHeight(dp, screenHeight);

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          LoginSignupScreenController.getBackgroundImage(),
          Center(
            child: SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: relWidth(32)),
                padding: EdgeInsets.all(relWidth(16)),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    LoginSignupScreenController.getLogoWidget(relHeight(130)),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Text(
                          'BarangayBuy',
                          style: LoginSignupScreenController.getTitleTextStyle(
                            fontSize: relWidth(63),
                            color: const Color(0xFFA22304),
                            isOutline: true,
                          ),
                        ),
                        Text(
                          'BarangayBuy',
                          style: LoginSignupScreenController.getTitleTextStyle(
                            fontSize: relWidth(63),
                            color: const Color(0xFFA22304),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: relHeight(1)),
                    LoginSignupScreenController.getDivider(
                      color: Colors.black54,
                      thickness: relHeight(1),
                    ),
                    SizedBox(height: relHeight(24)),
                    // Sign Up Button
                    ElevatedButton(
                      onPressed: _model.isLoading ? null : () async {
                        setState(() {
                          _model = LoginSignupScreenController.updateButtonSelection(
                            currentModel: _model,
                            isSignupSelected: true,
                            isLoginSelected: false,
                          );
                        });
                        
                        await LoginSignupScreenController.handleButtonPress(
                          context: context,
                          model: _model,
                          onPressed: () => LoginSignupScreenController.navigateToSignup(context),
                        );

                        setState(() {
                          _model = LoginSignupScreenController.clearStates(_model);
                        });
                      },
                      style: LoginSignupScreenController.getSignupButtonStyle(
                        minimumSize: Size(relWidth(158), relHeight(45)),
                        borderRadius: relWidth(3),
                        borderWidth: relWidth(2),
                        fontSize: relWidth(30),
                        isSelected: _model.isSignupSelected,
                      ),
                      child: _model.isLoading && _model.isSignupSelected
                        ? SizedBox(
                            width: relWidth(20),
                            height: relWidth(20),
                            child: const CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Text('Sign Up'),
                    ),
                    SizedBox(height: relHeight(20)),
                    // Login Button
                    ElevatedButton(
                      onPressed: _model.isLoading ? null : () async {
                        setState(() {
                          _model = LoginSignupScreenController.updateButtonSelection(
                            currentModel: _model,
                            isSignupSelected: false,
                            isLoginSelected: true,
                          );
                        });
                        
                        await LoginSignupScreenController.handleButtonPress(
                          context: context,
                          model: _model,
                          onPressed: () => LoginSignupScreenController.navigateToLogin(context),
                        );

                        setState(() {
                          _model = LoginSignupScreenController.clearStates(_model);
                        });
                      },
                      style: LoginSignupScreenController.getLoginButtonStyle(
                        minimumSize: Size(relWidth(158), relHeight(45)),
                        borderRadius: relWidth(3),
                        borderWidth: relWidth(2),
                        fontSize: relWidth(30),
                        isSelected: _model.isLoginSelected,
                      ),
                      child: _model.isLoading && _model.isLoginSelected
                        ? SizedBox(
                            width: relWidth(20),
                            height: relWidth(20),
                            child: const CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Text('Login'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}