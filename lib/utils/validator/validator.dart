String? usernameValidator(String? value) {
  if (value == null || value.isEmpty) {
    return "Username is required";
  }
  if (!value.startsWith("@")) {
    return "Username must start with '@'";
  }
  return null;
}

String? nameValidator(String? value, {String fieldName = "Name"}) {
  RegExp nameRegex = RegExp(r'^[a-zA-Z]+$');
  if (value == null || value.isEmpty) {
    return "$fieldName is required";
  }
  if (!nameRegex.hasMatch(value)) {
    return "$fieldName must contain only alphabets";
  }
  if (value.length < 2) {
    return "$fieldName must be at least 2 characters long";
  }
  return null;
}

String? passwordValidator(String? value) {
  RegExp regex =
      RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
  if (value == null || value.isEmpty) {
    return "Password is required";
  } else if (value.length < 6) {
    return "Password must be at least 6 characters long";
  } else if (!regex.hasMatch(value)) {
    return "Password should contain upper, lower, digit, and special character";
  }
  return null;
}

String? confirmPasswordValidator(String? value, String originalPassword) {
  if (value == null || value.isEmpty) {
    return "Confirm Password is required";
  } else if (value != originalPassword) {
    return "Passwords do not match";
  }
  return null;
}

String? validateMobile(String value) {
  String patttern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
  RegExp regExp = RegExp(patttern);
  if (value.isEmpty) {
    return 'Please enter mobile number';
  } else if (!regExp.hasMatch(value)) {
    return 'Please enter valid mobile number';
  }
  return null;
}
