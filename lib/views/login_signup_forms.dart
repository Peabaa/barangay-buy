import 'package:flutter/material.dart';
import '../controllers/login_signup_controller.dart';
import '../models/login_signup_model.dart';

class LoginScreen extends StatefulWidget {
  final bool isLogin;
  const LoginScreen({super.key, this.isLogin = true});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}


class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  
  late LoginSignupModel _model;

  @override
  void initState() {
    super.initState();
    _model = LoginSignupModel(isLogin: widget.isLogin);
    
    // Add listeners to update model when text changes
    usernameController.addListener(_updateModel);
    emailController.addListener(_updateModel);
    passwordController.addListener(_updateModel);
    confirmPasswordController.addListener(_updateModel);
  }

  void _updateModel() {
    setState(() {
      _model = LoginSignupController.updateForm(
        currentModel: _model,
        username: usernameController.text,
        email: emailController.text,
        password: passwordController.text,
        confirmPassword: confirmPasswordController.text,
      );
    });
  }

  void _clearControllers() {
    usernameController.clear();
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
  }

  @override
  void dispose() {
    usernameController.removeListener(_updateModel);
    emailController.removeListener(_updateModel);
    passwordController.removeListener(_updateModel);
    confirmPasswordController.removeListener(_updateModel);
    
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    double relWidth(double dp) => screenWidth * (dp / 412);
    double relHeight(double dp) => screenHeight * (dp / 915);

    final isLogin = _model.isLogin;

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
                            fontSize: relWidth(63),
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
                            fontSize: relWidth(63),
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
                    // Login/Sign Up Form
                    Container(
                      width: relWidth(347),                      
                      decoration: BoxDecoration(
                        color: Color(0xFFFF5B29).withOpacity(0.57),
                        borderRadius: BorderRadius.circular(relWidth(23)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            offset: Offset(relWidth(8), relHeight(4)),
                            blurRadius: relWidth(6),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(height: relHeight(20)),
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              Text(
                                isLogin ? 'Login Form' : 'Sign Up Form',
                                style: TextStyle(
                                  fontFamily: 'SofiaSansCondensed',
                                  fontSize: relWidth(50),
                                  foreground: Paint()
                                    ..style = PaintingStyle.stroke
                                    ..strokeWidth = 2
                                    ..color = Color(0xFFA22304), 
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
                                isLogin ? 'Login Form' : 'Sign Up Form',
                                style: TextStyle(
                                  fontFamily: 'SofiaSansCondensed',
                                  fontSize: relWidth(50),
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: relHeight(10)),
                          // Toggle Button
                          Container(
                            width: relWidth(234),
                            height: relHeight(38),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                color: Color(0xFFA22304),
                                width: relWidth(1),
                              ),
                              borderRadius: BorderRadius.circular(relWidth(23)),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      if (_model.isLogin) {
                                        setState(() {
                                          _model = LoginSignupController.toggleMode(_model);
                                          _clearControllers();
                                        });
                                      }
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: !isLogin ? Color(0xFFA22304) : Colors.transparent,
                                        borderRadius: BorderRadius.circular(relWidth(23)),
                                      ),
                                      alignment: Alignment.centerLeft,
                                      padding: EdgeInsets.only(left: relWidth(27)),
                                      child: Text(
                                        'Sign Up',
                                        style: TextStyle(
                                          fontFamily: 'RobotoCondensed',
                                          fontSize: relWidth(24),
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
                                      if (!_model.isLogin) {
                                        setState(() {
                                          _model = LoginSignupController.toggleMode(_model);
                                          _clearControllers();
                                        });
                                      }
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: isLogin ? Color(0xFFA22304) : Colors.transparent,
                                        borderRadius: BorderRadius.circular(relWidth(23)),
                                      ),
                                      alignment: Alignment.centerRight,
                                      padding: EdgeInsets.only(right: relWidth(27)),
                                      child: Text(
                                        'Login',
                                        style: TextStyle(
                                          fontFamily: 'RobotoCondensed',
                                          fontSize: relWidth(24),
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
                            SizedBox(height: relHeight(18)),
                            // Login Email Address Field
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: relWidth(30)),
                              child: TextField(
                                controller: emailController,
                                decoration: LoginSignupController.getTextFieldDecoration(
                                  hintText: 'Email Address',
                                  fontSize: relWidth(16),
                                  borderRadius: relWidth(23),
                                  borderWidth: relWidth(1),
                                  focusedBorderWidth: relWidth(3),
                                ),
                                style: LoginSignupController.getTextFieldStyle(relWidth(16)),
                                keyboardType: TextInputType.emailAddress,
                              ),
                            ),
                            SizedBox(height: relHeight(10)),
                            // Login Password Field
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: relWidth(30)),
                              child: TextField(
                                controller: passwordController,
                                obscureText: true,
                                decoration: LoginSignupController.getTextFieldDecoration(
                                  hintText: 'Password',
                                  fontSize: relWidth(16),
                                  borderRadius: relWidth(23),
                                  borderWidth: relWidth(1),
                                  focusedBorderWidth: relWidth(3),
                                ),
                                style: LoginSignupController.getTextFieldStyle(relWidth(16)),
                              ),
                            ),
                            SizedBox(height: relHeight(14)),
                            // Login and Cancel buttons
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: relWidth(30)),
                              child: Column(
                                children: [
                                  // Login Button
                                  SizedBox(
                                    width: relWidth(145),
                                    child: ElevatedButton(
                                      onPressed: _model.isLoading ? null : () async {
                                        final result = await LoginSignupController.handleLogin(
                                          model: _model,
                                          context: context,
                                        );
                                        setState(() {
                                          _model = result;
                                        });
                                      },
                                      style: LoginSignupController.getPrimaryButtonStyle(relWidth(23)),
                                      child: _model.isLoading 
                                        ? const SizedBox(
                                            width: 20,
                                            height: 20,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                            ),
                                          )
                                        : const Text('Login'),
                                    ),
                                  ),
                                  // Cancel Button
                                  SizedBox(height: relHeight(5)),
                                  SizedBox(
                                    width: relWidth(145),
                                    child: OutlinedButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      style: LoginSignupController.getCancelButtonStyle(relWidth(23), relWidth(2)),
                                      child: Text('Cancel'),
                                    ),
                                  ),
                                  SizedBox(height: relHeight(10)),
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
                              controller: usernameController,
                              decoration: InputDecoration(
                                hintText: 'Username',
                                hintStyle: TextStyle(
                                  fontFamily: 'RobotoCondensed',
                                  fontSize: 16,
                                  color: const Color(0xFFD0D0D0).withOpacity(0.8),
                                  fontWeight: FontWeight.bold,
                                ),
                                filled: true,
                                fillColor: Colors.white.withOpacity(0.8),
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
                              controller: emailController,
                              decoration: InputDecoration(
                                hintText: 'Email Address',
                                hintStyle: TextStyle(
                                  fontFamily: 'RobotoCondensed',
                                  fontSize: relWidth(16),
                                  color: Color(0xFFD0D0D0).withOpacity(0.8),
                                  fontWeight: FontWeight.bold,
                                ),
                                filled: true,
                                fillColor: Colors.white.withOpacity(0.8),
                                contentPadding: EdgeInsets.symmetric(vertical: relHeight(2), horizontal: relWidth(20)),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(relWidth(23)),
                                  borderSide: const BorderSide(
                                    color: Color(0xFFA22304),
                                    width: 1,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(relWidth(23)),
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
                              controller: passwordController,
                              obscureText: true,
                              decoration: InputDecoration(
                                hintText: 'Password',
                                hintStyle: TextStyle(
                                  fontFamily: 'RobotoCondensed',
                                  fontSize: 16,
                                  color: const Color(0xFFD0D0D0).withValues(alpha: 0.8),
                                  fontWeight: FontWeight.bold,
                                ),
                                filled: true,
                                fillColor: Colors.white.withValues(alpha: 0.8),
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
                              controller: confirmPasswordController,
                              obscureText: true,
                              decoration: InputDecoration(
                                hintText: 'Confirm Password',
                                hintStyle: TextStyle(
                                  fontFamily: 'RobotoCondensed',
                                  fontSize: 16,
                                  color: const Color(0xFFD0D0D0).withValues(alpha: 0.8),
                                  fontWeight: FontWeight.bold,
                                ),
                                filled: true,
                                fillColor: Colors.white.withValues(alpha: 0.8),
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
                                      onPressed: _model.isLoading ? null : () async {
                                        final result = await LoginSignupController.handleSignup(
                                          model: _model,
                                          context: context,
                                        );
                                        setState(() {
                                          _model = result;
                                        });
                                      },
                                      style: LoginSignupController.getPrimaryButtonStyle(23),
                                      child: _model.isLoading
                                        ? const SizedBox(
                                            width: 20,
                                            height: 20,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                            ),
                                          )
                                        : const Text('Sign Up'),
                                    ),
                                  ),
                                  // Cancel Button
                                  SizedBox(height: relHeight(5)),
                                  SizedBox(
                                    width: 145,
                                    child: OutlinedButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      style: LoginSignupController.getCancelButtonStyle(relWidth(23), relWidth(2)),
                                      child: const Text('Cancel'),
                                    ),
                                  ),
                                  SizedBox(height: relHeight(10)),
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
          // Back button
          Positioned(
            top: relHeight(40),
            left: relWidth(16),
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Image.asset(
                'assets/images/back-square.png',
                width: relWidth(57),
                height: relWidth(57),
              ),
            ),
          ),
        ],
      ),
    );
  }
}