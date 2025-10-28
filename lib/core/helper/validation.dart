class Validation {
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Email is required";
    }
    const pattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
    final regex = RegExp(pattern);
    if (!regex.hasMatch(value.trim())) {
      return "Invalid email address";
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return "Password is required";
    }
    if (value.length < 6) {
      return "Password must be at least 6 characters long";
    }
    // optional: enforce complexity
    if (!RegExp(r'^(?=.*[A-Za-z])(?=.*\d)').hasMatch(value)) {
      return "Password must contain letters and numbers";
    }
    return null;
  }

  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "This field is required";
    }
    if (value.trim().length < 3) {
      return "Name must be at least 3 characters long";
    }
    return null;
  }

  static String? validateNumber(String? value,
      {String fieldName = "This field"}) {
    if (value == null || value.trim().isEmpty) {
      return "$fieldName is required";
    }
    const pattern = r'^[0-9]+$';
    final regex = RegExp(pattern);
    if (!regex.hasMatch(value.trim())) {
      return "$fieldName must be a number";
    }
    return null;
  }

  static String? validateRequired(String? value,
      {String fieldName = "This field"}) {
    if (value == null || value.trim().isEmpty) {
      return "$fieldName is required";
    }
    return null;
  }
}
