import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  final bool isLogin;
  const LoginScreen({Key? key, this.isLogin = true}) : super(key: key);

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
          // Back button
          Positioned(
            top: 40,
            left: 16,
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Image.asset(
                'assets/images/back-square.png',
                width: 57,
                height: 57,
              ),
            ),
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
                      ],
                    ),
                    SizedBox(height: 1),
                    Divider(
                      color: Colors.black54,
                      thickness: 1,
                    ),
                    SizedBox(height: 24),
                    // Login/Sign Up Form
                    Container(
                      width: 347,
                      height: 389,
                      decoration: BoxDecoration(
                        color: Color(0xFFFF5B29).withOpacity(0.57),
                        borderRadius: BorderRadius.circular(23.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            offset: Offset(8, 4),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(height: 20),
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              Text( // Text Border Color
                                isLogin ? 'Login Form' : 'Sign Up Form',
                                style: TextStyle(
                                  fontFamily: 'SofiaSansCondensed',
                                  fontSize: 50,
                                  foreground: Paint()
                                    ..style = PaintingStyle.stroke
                                    ..strokeWidth = 2
                                    ..color = Color(0xFFA22304), // Border color
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
                                isLogin ? 'Login Form' : 'Sign Up Form',
                                style: TextStyle(
                                  fontFamily: 'SofiaSansCondensed',
                                  fontSize: 50,
                                  color: Colors.white,
                                )
                              ),
                            ],
                          ), 
                          SizedBox(height: 10),                         
                          // Toggle Button
                          Container(
                            width: 234,
                            height: 38,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                color: Color(0xFFA22304),
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(23),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      if (isLogin) {
                                        Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(
                                            builder: (_) => LoginScreen(isLogin: false),
                                          ),
                                        );
                                      }
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: !isLogin ? Color(0xFFA22304) : Colors.transparent,
                                        borderRadius: BorderRadius.circular(23),
                                      ),
                                      alignment: Alignment.centerLeft,
                                      padding: EdgeInsets.only(left: 27),
                                      child: Text(
                                        'Sign Up',
                                        style: TextStyle(
                                          fontFamily: 'RobotoCondensed',
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          fontStyle: FontStyle.italic,
                                          color: !isLogin ? Colors.white : Color(0xFFA22304),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      if (!isLogin) {
                                        Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(
                                            builder: (_) => LoginScreen(isLogin: true),
                                          ),
                                        );
                                      }
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: isLogin ? Color(0xFFA22304) : Colors.transparent,
                                        borderRadius: BorderRadius.circular(23),
                                      ),
                                      alignment: Alignment.centerRight,
                                      padding: EdgeInsets.only(right: 27),
                                      child: Text(
                                        'Login',
                                        style: TextStyle(
                                          fontFamily: 'RobotoCondensed',
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          fontStyle: FontStyle.italic,
                                          color: isLogin ? Colors.white : Color(0xFFA22304),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Login form fields
                          if (isLogin) ...[
                            SizedBox(height: 18),
                            // Login Email Address Field
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 30.0),
                              child: TextField(
                                decoration: InputDecoration(
                                  hintText: 'Email Address',
                                  hintStyle: TextStyle(
                                    fontFamily: 'RobotoCondensed',
                                    fontSize: 16,
                                    color: Color(0xFFD0D0D0).withOpacity(0.8),
                                    fontWeight: FontWeight.bold,
                                  ),
                                  filled: true,
                                  fillColor: Colors.white.withOpacity(0.8),
                                  contentPadding: EdgeInsets.symmetric(vertical: 2, horizontal: 20),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(23),
                                    borderSide: BorderSide(
                                      color: Color(0xFFA22304),
                                      width: 1,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(23),
                                    borderSide: BorderSide(
                                      color: Color(0xFFA22304),
                                      width: 3,
                                    ),
                                  ),
                                ),
                                style: TextStyle(
                                  fontFamily: 'RobotoCondensed',
                                  fontSize: 16,
                                  color: Color(0xFFA22304),
                                  fontWeight: FontWeight.bold,
                                ),
                                keyboardType: TextInputType.emailAddress,
                              ),
                            ),
                            SizedBox(height: 10),
                            // Login Password Field
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 30.0),
                              child: TextField(
                                obscureText: true,
                                decoration: InputDecoration(
                                  hintText: 'Password',
                                  hintStyle: TextStyle(
                                    fontFamily: 'RobotoCondensed',
                                    fontSize: 16,
                                    color: Color(0xFFD0D0D0).withOpacity(0.8),
                                    fontWeight: FontWeight.bold,
                                  ),
                                  filled: true,
                                  fillColor: Colors.white.withOpacity(0.8),
                                  contentPadding: EdgeInsets.symmetric(vertical: 1, horizontal: 20),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(23),
                                    borderSide: BorderSide(
                                      color: Color(0xFFA22304),
                                      width: 1,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(23),
                                    borderSide: BorderSide(
                                      color: Color(0xFFA22304),
                                      width: 3,
                                    ),
                                  ),
                                ),
                                style: TextStyle(
                                  fontFamily: 'RobotoCondensed',
                                  fontSize: 16,
                                  color: Color(0xFFA22304),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            SizedBox(height: 14),
                            // Login and Cancel buttons
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 30.0),
                              child: Column(
                                children: [
                                  // Login Button
                                  SizedBox(
                                    width: 145,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        // Implement login logic
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Color(0xFFA22304),
                                        foregroundColor: Colors.white,
                                        textStyle: TextStyle(
                                          fontFamily: 'RobotoCondensed',
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          fontStyle: FontStyle.italic,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(23),
                                        ),
                                      ),
                                      child: Text('Login'),
                                    ),
                                  ),
                                  // Cancel Button
                                  SizedBox(height: 1),
                                  SizedBox(
                                    width: 145,
                                    child: OutlinedButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      style: OutlinedButton.styleFrom(
                                        backgroundColor: Colors.white,
                                        foregroundColor: Color(0xFFA22304),
                                        side: BorderSide(color: Color(0xFFA22304), width: 2),
                                        textStyle: TextStyle(
                                          fontFamily: 'RobotoCondensed',
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(23),
                                        ),
                                      ),
                                      child: Text('Cancel'),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                          // Place sign up form fields here (JIA'S PART)
                          if (!isLogin) ...[
                            // Add your sign up form fields here
                          ],
                        ],
                      ),
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