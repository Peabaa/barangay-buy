import 'package:flutter/material.dart';

class LoginSignupScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
                margin: EdgeInsets.symmetric(horizontal: 32.0),
                padding: EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      'assets/images/Logo.png',
                      height: 130,
                    ),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Text( // Text Border Color
                          'BarangayBuy',
                          style: TextStyle(
                            fontFamily: 'SofiaSansCondensed',
                            fontSize: 64,
                            foreground: Paint()
                              ..style = PaintingStyle.stroke
                              ..strokeWidth = 2
                              ..color = Colors.white, // Border color
                            shadows: [
                              Shadow(
                                color: Colors.black26,
                                offset: Offset(3, 5),
                                blurRadius: 12,
                              ),
                            ],
                          ),
                        ),
                        Text( // Text Fill Color
                          'BarangayBuy',
                          style: TextStyle(
                            fontFamily: 'SofiaSansCondensed',
                            fontSize: 64,
                            color: Color(0xFFA22304),
                          )
                        ),
                      ]
                    ),
                    // Sign Up Button
                    ElevatedButton(
                      onPressed: (){
                        // Navigate to Sign Up Screen
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(158, 45),
                        backgroundColor: Colors.white,
                        foregroundColor: Color(0xFFFF5B29),
                        textStyle: TextStyle(
                          fontFamily: 'RobotoCondensed',
                          fontSize: 30,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(3.0),
                          side: BorderSide(
                            color: Color(0xFFFF5B29),
                            width: 2.0,
                          ),
                        ),
                      ),
                      child: Text('Sign Up'),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: (){
                        // Navigate to Login Screen
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(158, 45),
                        backgroundColor: Color(0xFFFF5B29),
                        foregroundColor: Colors.white,
                        textStyle: TextStyle(
                          fontFamily: 'RobotoCondensed',
                          fontSize: 30,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(3.0),
                          side: BorderSide(
                            color: Color(0xFFFF5B29),
                            width: 2.0,
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