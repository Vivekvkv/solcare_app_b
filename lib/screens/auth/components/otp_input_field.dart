import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// Import math library for min function
import 'dart:math' as math;

class OtpInputField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String? Function(String?)? validator;

  const OtpInputField({
    Key? key,
    required this.controller,
    required this.label,
    this.validator,
  }) : super(key: key);

  @override
  State<OtpInputField> createState() => _OtpInputFieldState();
}

class _OtpInputFieldState extends State<OtpInputField> {
  // Individual controllers for visual separation
  late List<TextEditingController> _digitControllers;
  late List<FocusNode> _focusNodes;
  
  @override
  void initState() {
    super.initState();
    
    // Initialize controllers and focus nodes
    _digitControllers = List.generate(6, (_) => TextEditingController());
    _focusNodes = List.generate(6, (_) => FocusNode());
    
    // Listen to main controller changes to update individual digit fields
    widget.controller.addListener(_updateDigitControllers);
  }
  
  @override
  void dispose() {
    widget.controller.removeListener(_updateDigitControllers);
    for (var controller in _digitControllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }
  
  void _updateDigitControllers() {
    final text = widget.controller.text;
    for (int i = 0; i < 6; i++) {
      _digitControllers[i].text = i < text.length ? text[i] : '';
    }
  }
  
  void _onDigitChanged(int index, String value) {
    if (value.length > 1) {
      // If pasted multiple digits, handle appropriately
      final fullValue = value.substring(0, math.min(value.length, 6));
      widget.controller.text = fullValue;
      
      // Move focus to appropriate field
      if (fullValue.length == 6 && index < 5) {
        _focusNodes[5].requestFocus();
      } else if (index < fullValue.length && index < 5) {
        _focusNodes[index + 1].requestFocus();
      }
      return;
    }
    
    // Build the full OTP from individual fields
    String otp = '';
    for (int i = 0; i < 6; i++) {
      otp += i == index ? value : _digitControllers[i].text;
    }
    widget.controller.text = otp;
    
    // Auto-advance focus to next field
    if (value.isNotEmpty && index < 5) {
      _focusNodes[index + 1].requestFocus();
    }
  }
  
  @override
  Widget build(BuildContext context) {
    // Check if we're on a large screen
    final Size screenSize = MediaQuery.of(context).size;
    final bool isLargeScreen = screenSize.width > 600;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8, bottom: 8),
          child: Text(
            widget.label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
          ),
        ),
        Container(
          height: 70,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(
              6,
              (index) => Container(
                width: isLargeScreen ? 50 : 40,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _focusNodes[index].hasFocus
                        ? Theme.of(context).primaryColor
                        : Colors.transparent,
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: _focusNodes[index].hasFocus
                          ? Theme.of(context).primaryColor.withOpacity(0.3)
                          : Colors.transparent,
                      blurRadius: 8,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: TextField(
                  controller: _digitControllers[index],
                  focusNode: _focusNodes[index],
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  maxLength: 1,
                  style: TextStyle(
                    fontSize: isLargeScreen ? 24 : 20,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                  decoration: const InputDecoration(
                    counterText: '',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 16),
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  onChanged: (value) => _onDigitChanged(index, value),
                  onTap: () {
                    // Select all text on tap for easier editing
                    _digitControllers[index].selection = TextSelection(
                      baseOffset: 0,
                      extentOffset: _digitControllers[index].text.length,
                    );
                  },
                ),
              ),
            ),
          ),
        ),
        if (widget.validator != null)
          Padding(
            padding: const EdgeInsets.only(left: 12, top: 8),
            child: FormField<String>(
              validator: widget.validator,
              builder: (FormFieldState<String> state) {
                return state.hasError
                    ? Text(
                        state.errorText!,
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 12,
                        ),
                      )
                    : Container();
              },
            ),
          ),
      ],
    );
  }
}


