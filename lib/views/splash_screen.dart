import 'package:flutter/material.dart';
import '../controllers/splash_screen_controller.dart';
import '../models/splash_screen_model.dart';

class SplashScreen extends StatefulWidget {
  final Widget nextScreen;
  const SplashScreen({required this.nextScreen, super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late SplashScreenModel _model;

  @override
  void initState() {
    super.initState();
    _model = SplashScreenModel(nextScreen: widget.nextScreen);
    
    SplashScreenController.startSplashTimer(
      context: context,
      model: _model,
      onModelUpdate: _updateModel,
    );
  }

  void _updateModel(SplashScreenModel newModel) {
    setState(() {
      _model = newModel;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    
    double relWidth(double dp) => SplashScreenController.getRelativeWidth(screenWidth, dp);
    double relHeight(double dp) => SplashScreenController.getRelativeHeight(screenHeight, dp);

    return SplashScreenController.buildSplashScaffold(
      backgroundImage: SplashScreenController.getBackgroundImage(),
      content: Container(
        margin: SplashScreenController.getContainerMargin(relWidth(32)),
        padding: SplashScreenController.getContainerPadding(relWidth(16)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SplashScreenController.getLogoImage(relHeight(130)),
            SplashScreenController.getTitleText(
              title: 'BarangayBuy',
              fontSize: relWidth(63),
              relWidth: relWidth(3),
              relHeight: relHeight(5),
            ),
          ],
        ),
      ),
    );
  }
}