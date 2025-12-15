// Custom validators for form validation
import 'package:flutter_form_builder/flutter_form_builder.dart';

class AppValidators {
  static String? Function(String?) emailValidator = FormBuilderValidators.email();

  static String? Function(String?) requiredValidator = FormBuilderValidators.required();

  static String? Function(String?) minLengthValidator(int length) {
    return FormBuilderValidators.minLength(length);
  }

  static String? Function(String?) phoneValidator = (value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }
    // Basic phone validation (can be enhanced)
    final phoneRegex = RegExp(r'^\+?[0-9]{10,15}$');
    if (!phoneRegex.hasMatch(value)) {
      return 'Please enter a valid phone number';
    }
    return null;
  };

  static String? Function(String?) passwordValidator = (value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    return null;
  };
}

