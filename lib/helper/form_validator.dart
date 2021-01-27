import 'package:form_field_validator/form_field_validator.dart';

class LYDPhoneValidator extends TextFieldValidator {
  // pass the error text to the super constructor
  LYDPhoneValidator({String errorText = 'enter a valid LYD phone number'})
      : super(errorText);

  // return false if you want the validator to return error
  // message when the value is empty.
  @override
  bool get ignoreEmptyValues => true;

  @override
  bool isValid(String value) {
    // return true if the value is valid according the your condition
    return hasMatch(r'^((+|00)?218|0?)?(9[0-9]{8})$', value);
  }
}

final passwordValidator = MultiValidator([
  RequiredValidator(errorText: 'Please a enter password'),
  MinLengthValidator(8, errorText: 'Password must be at least 8 digits long'),
  MaxLengthValidator(15,
      errorText: 'Password should not be at more than 15 charcaters'),
  //PatternValidator(r'(?=.*?[#?!@$%^&*-])',
  // errorText: 'passwords must have at least one special character')
]);

/*class CustomValidator extends FieldValidator<T>{  
   CustomValidator(String errorText) : super(errorText);  
  
	  @override  
	  bool isValid(T value) {  
	    // TODO: implement isValid  
	    return //condition;
	  }  
  }  */
