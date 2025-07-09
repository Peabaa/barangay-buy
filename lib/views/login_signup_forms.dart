import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  final bool isLogin;
  const LoginScreen({super.key, this.isLogin = true});

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
                margin: const EdgeInsets.symmetric(horizontal: 32.0),
                padding: const EdgeInsets.all(16.0),
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
                            shadows: const [
                              Shadow(
                                color: Colors.black26,
                                offset: Offset(3, 5),
                                blurRadius: 12,
                              ),
                            ],
                          ),
                        ),
                        const Text( // Text Fill Color
                          'BarangayBuy',
                          style: TextStyle(
                            fontFamily: 'SofiaSansCondensed',
                            fontSize: 64,
                            color: Color(0xFFA22304),
                          )
                        ),
                      ],
                    ),
                    const SizedBox(height: 1),
                    const Divider(
                      color: Colors.black54,
                      thickness: 1,
                    ),
                    const SizedBox(height: 24),
                    // Login/Sign Up Form
                    Container(
                      width: 347,
                      height: isLogin ? 389 : 520, // Different heights for login vs sign-up
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF5B29).withValues(alpha: 0.57), // Fixed withOpacity
                        borderRadius: BorderRadius.circular(23.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.2), // Fixed withOpacity
                            offset: const Offset(8, 4),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(height: 20),
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
                                    ..color = const Color(0xFFA22304), // Border color
                                  shadows: const [
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
                                style: const TextStyle(
                                  fontFamily: 'SofiaSansCondensed',
                                  fontSize: 50,
                                  color: Colors.white,
                                )
                              ),
                            ],
                          ), 
                          const SizedBox(height: 10),                         
                          // Toggle Button
                          Container(
                            width: 234,
                            height: 38,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                color: const Color(0xFFA22304),
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
                                            builder: (_) => const LoginScreen(isLogin: false),
                                          ),
                                        );
                                      }
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: !isLogin ? const Color(0xFFA22304) : Colors.transparent,
                                        borderRadius: BorderRadius.circular(23),
                                      ),
                                      alignment: Alignment.centerLeft,
                                      padding: const EdgeInsets.only(left: 27),
                                      child: Text(
                                        'Sign Up',
                                        style: TextStyle(
                                          fontFamily: 'RobotoCondensed',
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          fontStyle: FontStyle.italic,
                                          color: !isLogin ? Colors.white : const Color(0xFFA22304),
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
                                            builder: (_) => const LoginScreen(isLogin: true),
                                          ),
                                        );
                                      }
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: isLogin ? const Color(0xFFA22304) : Colors.transparent,
                                        borderRadius: BorderRadius.circular(23),
                                      ),
                                      alignment: Alignment.centerRight,
                                      padding: const EdgeInsets.only(right: 27),
                                      child: Text(
                                        'Login',
                                        style: TextStyle(
                                          fontFamily: 'RobotoCondensed',
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          fontStyle: FontStyle.italic,
                                          color: isLogin ? Colors.white : const Color(0xFFA22304),
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
                            const SizedBox(height: 18),
                            // Login Email Address Field
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 30.0),
                              child: TextField(
                                decoration: InputDecoration(
                                  hintText: 'Email Address',
                                  hintStyle: TextStyle(
                                    fontFamily: 'RobotoCondensed',
                                    fontSize: 16,
                                    color: const Color(0xFFD0D0D0).withValues(alpha: 0.8), // Fixed withOpacity
                                    fontWeight: FontWeight.bold,
                                  ),
                                  filled: true,
                                  fillColor: Colors.white.withValues(alpha: 0.8), // Fixed withOpacity
                                  contentPadding: const EdgeInsets.symmetric(vertical: 2, horizontal: 20),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(23),
                                    borderSide: const BorderSide(
                                      color: Color(0xFFA22304),
                                      width: 1,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(23),
                                    borderSide: const BorderSide(
                                      color: Color(0xFFA22304),
                                      width: 3,
                                    ),
                                  ),
                                ),
                                style: const TextStyle(
                                  fontFamily: 'RobotoCondensed',
                                  fontSize: 16,
                                  color: Color(0xFFA22304),
                                  fontWeight: FontWeight.bold,
                                ),
                                keyboardType: TextInputType.emailAddress,
                              ),
                            ),
                            const SizedBox(height: 10),
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
                                    color: const Color(0xFFD0D0D0).withValues(alpha: 0.8), // Fixed withOpacity
                                    fontWeight: FontWeight.bold,
                                  ),
                                  filled: true,
                                  fillColor: Colors.white.withValues(alpha: 0.8), // Fixed withOpacity
                                  contentPadding: const EdgeInsets.symmetric(vertical: 1, horizontal: 20),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(23),
                                    borderSide: const BorderSide(
                                      color: Color(0xFFA22304),
                                      width: 1,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(23),
                                    borderSide: const BorderSide(
                                      color: Color(0xFFA22304),
                                      width: 3,
                                    ),
                                  ),
                                ),
                                style: const TextStyle(
                                  fontFamily: 'RobotoCondensed',
                                  fontSize: 16,
                                  color: Color(0xFFA22304),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(height: 14),
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
                                        backgroundColor: const Color(0xFFA22304),
                                        foregroundColor: Colors.white,
                                        textStyle: const TextStyle(
                                          fontFamily: 'RobotoCondensed',
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          fontStyle: FontStyle.italic,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(23),
                                        ),
                                      ),
                                      child: const Text('Login'),
                                    ),
                                  ),
                                  // Cancel Button
                                  const SizedBox(height: 1),
                                  SizedBox(
                                    width: 145,
                                    child: OutlinedButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      style: OutlinedButton.styleFrom(
                                        backgroundColor: Colors.white,
                                        foregroundColor: const Color(0xFFA22304),
                                        side: const BorderSide(color: Color(0xFFA22304), width: 2),
                                        textStyle: const TextStyle(
                                          fontFamily: 'RobotoCondensed',
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(23),
                                        ),
                                      ),
                                      child: const Text('Cancel'),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                          // Sign up form fields
                          if (!isLogin) ...[
                            const SizedBox(height: 18),
                            // Sign Up UserName Field
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 30.0),
                              child: TextField(
                                decoration: InputDecoration(
                                  hintText: 'Username',
                                  hintStyle: TextStyle(
                                    fontFamily: 'RobotoCondensed',
                                    fontSize: 16,
                                    color: const Color(0xFFD0D0D0).withValues(alpha: 0.8), // Fixed withOpacity
                                    fontWeight: FontWeight.bold,
                                  ),
                                  filled: true,
                                  fillColor: Colors.white.withValues(alpha: 0.8), // Fixed withOpacity
                                  contentPadding: const EdgeInsets.symmetric(vertical: 2, horizontal: 20),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(23),
                                    borderSide: const BorderSide(
                                      color: Color(0xFFA22304),
                                      width: 1,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(23),
                                    borderSide: const BorderSide(
                                      color: Color(0xFFA22304),
                                      width: 3,
                                    ),
                                  ),
                                ),
                                style: const TextStyle(
                                  fontFamily: 'RobotoCondensed',
                                  fontSize: 16,
                                  color: Color(0xFFA22304),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            // Sign Up Email Address Field
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 30.0),
                              child: TextField(
                                decoration: InputDecoration(
                                  hintText: 'Email Address',
                                  hintStyle: TextStyle(
                                    fontFamily: 'RobotoCondensed',
                                    fontSize: 16,
                                    color: const Color(0xFFD0D0D0).withValues(alpha: 0.8), // Fixed withOpacity
                                    fontWeight: FontWeight.bold,
                                  ),
                                  filled: true,
                                  fillColor: Colors.white.withValues(alpha: 0.8), // Fixed withOpacity
                                  contentPadding: const EdgeInsets.symmetric(vertical: 2, horizontal: 20),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(23),
                                    borderSide: const BorderSide(
                                      color: Color(0xFFA22304),
                                      width: 1,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(23),
                                    borderSide: const BorderSide(
                                      color: Color(0xFFA22304),
                                      width: 3,
                                    ),
                                  ),
                                ),
                                style: const TextStyle(
                                  fontFamily: 'RobotoCondensed',
                                  fontSize: 16,
                                  color: Color(0xFFA22304),
                                  fontWeight: FontWeight.bold,
                                ),
                                keyboardType: TextInputType.emailAddress,
                              ),
                            ),
                            const SizedBox(height: 10),
                            // Sign Up Password Field
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 30.0),
                              child: TextField(
                                obscureText: true,
                                decoration: InputDecoration(
                                  hintText: 'Password',
                                  hintStyle: TextStyle(
                                    fontFamily: 'RobotoCondensed',
                                    fontSize: 16,
                                    color: const Color(0xFFD0D0D0).withValues(alpha: 0.8), // Fixed withOpacity
                                    fontWeight: FontWeight.bold,
                                  ),
                                  filled: true,
                                  fillColor: Colors.white.withValues(alpha: 0.8), // Fixed withOpacity
                                  contentPadding: const EdgeInsets.symmetric(vertical: 1, horizontal: 20),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(23),
                                    borderSide: const BorderSide(
                                      color: Color(0xFFA22304),
                                      width: 1,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(23),
                                    borderSide: const BorderSide(
                                      color: Color(0xFFA22304),
                                      width: 3,
                                    ),
                                  ),
                                ),
                                style: const TextStyle(
                                  fontFamily: 'RobotoCondensed',
                                  fontSize: 16,
                                  color: Color(0xFFA22304),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            //Confirm Password Field
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 30.0),
                              child: TextField(
                                obscureText: true,
                                decoration: InputDecoration(
                                  hintText: 'Confirm Password',
                                  hintStyle: TextStyle(
                                    fontFamily: 'RobotoCondensed',
                                    fontSize: 16,
                                    color: const Color(0xFFD0D0D0).withValues(alpha: 0.8), // Fixed withOpacity
                                    fontWeight: FontWeight.bold,
                                  ),
                                  filled: true,
                                  fillColor: Colors.white.withValues(alpha: 0.8), // Fixed withOpacity
                                  contentPadding: const EdgeInsets.symmetric(vertical: 1, horizontal: 20),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(23),
                                    borderSide: const BorderSide(
                                      color: Color(0xFFA22304),
                                      width: 1,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(23),
                                    borderSide: const BorderSide(
                                      color: Color(0xFFA22304),
                                      width: 3,
                                    ),
                                  ),
                                ),
                                style: const TextStyle(
                                  fontFamily: 'RobotoCondensed',
                                  fontSize: 16,
                                  color: Color(0xFFA22304),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(height: 14),
                            // Sign Up and Cancel buttons
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 30.0),
                              child: Column(
                                children: [
                                  // Sign Up Button
                                  SizedBox(
                                    width: 145,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        // Implement sign up logic
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xFFA22304),
                                        foregroundColor: Colors.white,
                                        textStyle: const TextStyle(
                                          fontFamily: 'RobotoCondensed',
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          fontStyle: FontStyle.italic,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(23),
                                        ),
                                      ),
                                      child: const Text('Sign Up'),
                                    ),
                                  ),
                                  // Cancel Button
                                  const SizedBox(height: 1),
                                  SizedBox(
                                    width: 145,
                                    child: OutlinedButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      style: OutlinedButton.styleFrom(
                                        backgroundColor: Colors.white,
                                        foregroundColor: const Color(0xFFA22304),
                                        side: const BorderSide(color: Color(0xFFA22304), width: 2),
                                        textStyle: const TextStyle(
                                          fontFamily: 'RobotoCondensed',
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(23),
                                        ),
                                      ),
                                      child: const Text('Cancel'),
                                    ),
                                  ),
                                ],
                              ),
                            ),
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