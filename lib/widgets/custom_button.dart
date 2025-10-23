import 'package:flutter/material.dart';
import '../utils/constants.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isSecondary;
  final double? width;
  final double height;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isSecondary = false,
    this.width,
    this.height = 56,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isSecondary 
              ? AppConstants.lightGreen 
              : AppConstants.primaryGreen,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.buttonRadius),
          ),
          elevation: 0,
          disabledBackgroundColor: AppConstants.lightGreen,
        ),
        child: isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : Text(
                text,
                style: AppConstants.buttonTextStyle,
              ),
      ),
    );
  }
}

class CustomTextButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isSecondary;

  const CustomTextButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isSecondary = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.buttonRadius),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: AppConstants.primaryGreen,
        ),
      ),
    );
  }
}
