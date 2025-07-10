import 'package:flutter/material.dart';
import 'login_signup_forms.dart';
class LoginSignupScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    
    double relWidth(double dp) => screenWidth * (dp / 412);
    double relHeight(double dp) => screenHeight * (dp / 915);

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/background.png',
            fit: BoxFit.cover,
          ),
          Center(
            child: SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: relWidth(32)),
                padding: EdgeInsets.all(relWidth(16)),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      'assets/images/Logo.png',
                      height: relHeight(130),
                    ),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Text(
                          'BarangayBuy',
                          style: TextStyle(
                            fontFamily: 'SofiaSansCondensed',
                            fontSize: relWidth(64),
                            foreground: Paint()
                              ..style = PaintingStyle.stroke
                              ..strokeWidth = 2
                              ..color = Colors.white,
                            shadows: [
                              Shadow(
                                color: Colors.black26,
                                offset: Offset(relWidth(3), relHeight(5)),
                                blurRadius: relWidth(12),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          'BarangayBuy',
                          style: TextStyle(
                            fontFamily: 'SofiaSansCondensed',
                            fontSize: relWidth(64),
                            color: Color(0xFFA22304),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: relHeight(1)),
                    Divider(
                      color: Colors.black54,
                      thickness: relHeight(1),
                    ),
                    SizedBox(height: relHeight(24)),
                    // Sign Up Button
                    ElevatedButton(
                      onPressed: (){
                        // Navigate to Sign Up Screen
                        Navigator.of(context).push(
                          PageRouteBuilder(
                            pageBuilder: (context, animation, secondaryAnimation) => LoginScreen(isLogin: false),
                            transitionsBuilder: (context, animation, secondaryAnimation, child) {
                              return FadeTransition(
                                opacity: animation,
                                child: child,
                              );
                            },
                            transitionDuration: Duration(milliseconds: 200),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(relWidth(158), relHeight(45)),
                        backgroundColor: Colors.white,
                        foregroundColor: Color(0xFFFF5B29),
                        textStyle: TextStyle(
                          fontFamily: 'RobotoCondensed',
                          fontSize: relWidth(30),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(relWidth(3)),
                          side: BorderSide(
                            color: Color(0xFFFF5B29),
                            width: relWidth(2),
                          ),
                        ),
                      ),
                      child: Text('Sign Up'),
                    ),
                    SizedBox(height: relHeight(20)),
                    // Login Button
                    ElevatedButton(
                      onPressed: () {
                        // Navigate to Login Screen
                        Navigator.of(context).push(
                          PageRouteBuilder(
                            pageBuilder: (context, animation, secondaryAnimation) => LoginScreen(),
                            transitionsBuilder: (context, animation, secondaryAnimation, child) {
                              return FadeTransition(
                                opacity: animation,
                                child: child,
                              );
                            },
                            transitionDuration: Duration(milliseconds: 200),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(relWidth(158), relHeight(45)),
                        backgroundColor: Color(0xFFFF5B29),
                        foregroundColor: Colors.white,
                        textStyle: TextStyle(
                          fontFamily: 'RobotoCondensed',
                          fontSize: relWidth(30),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(relWidth(3)),
                          side: BorderSide(
                            color: Color(0xFFFF5B29),
                            width: relWidth(2),
                          ),
                        ),
                      ),
                      child: Text('Login'),
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