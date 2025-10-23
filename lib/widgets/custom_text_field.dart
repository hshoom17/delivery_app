import 'package:flutter/material.dart';
import '../utils/constants.dart';

class CustomTextField extends StatefulWidget {
  final String label;
  final String hint;
  final IconData icon;
  final bool isPassword;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final TextEditingController? controller;
  final bool enabled;

  const CustomTextField({
    super.key,
    required this.label,
    required this.hint,
    required this.icon,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.onChanged,
    this.controller,
    this.enabled = true,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = true;
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppConstants.darkGray,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
            controller: widget.controller,
            enabled: widget.enabled,
            keyboardType: widget.keyboardType,
            obscureText: widget.isPassword ? _obscureText : false,
            validator: widget.validator,
            onChanged: widget.onChanged,
            onTap: () {
              setState(() {
                _isFocused = true;
              });
            },
            onFieldSubmitted: (value) {
              setState(() {
                _isFocused = false;
              });
            },
            style: const TextStyle(
              fontSize: 16,
              color: AppConstants.darkGray,
            ),
          decoration: InputDecoration(
            hintText: widget.hint,
            hintStyle: const TextStyle(
              color: AppConstants.textGray,
              fontSize: 15,
            ),
            prefixIcon: Icon(
              widget.icon,
              color: _isFocused 
                  ? AppConstants.primaryGreen 
                  : AppConstants.textGray,
              size: 22,
            ),
            suffixIcon: widget.isPassword
                ? IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility_off : Icons.visibility,
                      color: AppConstants.textGray,
                      size: 22,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  )
                : null,
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
              borderSide: const BorderSide(
                color: Color(0xFFE0E0E0),
                width: 1,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
              borderSide: const BorderSide(
                color: Color(0xFFE0E0E0),
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
              borderSide: const BorderSide(
                color: AppConstants.primaryGreen,
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
              borderSide: const BorderSide(
                color: AppConstants.errorRed,
                width: 1,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
              borderSide: const BorderSide(
                color: AppConstants.errorRed,
                width: 2,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
        ),
      ],
    );
  }
}
