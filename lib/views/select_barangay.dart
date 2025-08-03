
import 'package:flutter/material.dart';
import '../controllers/select_barangay_controller.dart';
import '../models/select_barangay_model.dart';

class SelectBarangay extends StatefulWidget {
  final bool isConfirm;
  const SelectBarangay({super.key, this.isConfirm = true});

  @override
  State<SelectBarangay> createState() => _SelectBarangayState();
}

class _SelectBarangayState extends State<SelectBarangay> {
  late SelectBarangayModel _model;

  @override
  void initState() {
    super.initState();
    _model = SelectBarangayModel(isConfirm: widget.isConfirm);
  }

  void _updateModel(SelectBarangayModel newModel) {
    setState(() {
      _model = newModel;
    });
  }

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
          // Back button
          Positioned(
            top: relHeight(40),
            left: relWidth(16),
            child: GestureDetector(
              onTap: () => SelectBarangayController.handleBackNavigation(context),
              child: Image.asset(
                'assets/images/back-square.png',
                width: relWidth(57),
                height: relWidth(57),
              ),
            ),
          ),
          // Barangay Selection Form
          Center(
            child: Container(
              width: relWidth(347),
              height: relHeight(350),
              decoration: SelectBarangayController.getMainContainerDecoration(
                relWidth(23),
                relWidth(6),
                relWidth(8),
                relHeight(4),
              ),
              child: Padding(
                padding: EdgeInsets.all(relWidth(60)),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Welcome User!',
                      style: SelectBarangayController.getWelcomeTextStyle(relWidth(36)),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: relHeight(13)),
                    Text(
                      'Select Your Barangay',
                      style: SelectBarangayController.getSubtitleTextStyle(relWidth(16)),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: relHeight(25)),
                    // Dropdown for barangay selection
                    Container(
                      width: relWidth(238),
                      height: relHeight(35),
                      padding: EdgeInsets.symmetric(horizontal: relWidth(16)),
                      decoration: SelectBarangayController.getDropdownContainerDecoration(relWidth(23)),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _model.selectedBarangay,
                          hint: Text(
                            'Barangay',
                            style: SelectBarangayController.getDropdownTextStyle(relWidth(16)),
                          ),
                          style: SelectBarangayController.getDropdownTextStyle(relWidth(16)),
                          icon: const Icon(
                            Icons.keyboard_arrow_down,
                            color: Color(0xFF611A04),
                          ),
                          dropdownColor: Colors.white.withOpacity(0.95),
                          items: _model.availableBarangays.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                                style: SelectBarangayController.getDropdownTextStyle(relWidth(16)),
                              ),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            _updateModel(
                              SelectBarangayController.updateSelectedBarangay(_model, newValue),
                            );
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: relHeight(23)),
                    // Confirm Button
                    SizedBox(
                      width: relWidth(128),
                      child: ElevatedButton(
                        onPressed: _model.canConfirm && !_model.isLoading
                            ? () async {
                                await SelectBarangayController.confirmBarangay(
                                  context: context,
                                  model: _model,
                                  onModelUpdate: _updateModel,
                                );
                              }
                            : null,
                        style: SelectBarangayController.getConfirmButtonStyle(
                          borderRadius: relWidth(23),
                          isEnabled: _model.canConfirm,
                        ),
                        child: _model.isLoading
                            ? SizedBox(
                                width: relWidth(20),
                                height: relWidth(20),
                                child: const CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              )
                            : Text(
                                'Confirm',
                                style: SelectBarangayController.getConfirmButtonTextStyle(relWidth(20)),
                                textAlign: TextAlign.center,
                              ),
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