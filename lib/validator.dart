class Validator{

  static String notEmpty(value) {
        if (value.isEmpty) {
          return 'من فضلك اكمل الحقل';
        }
        return null;
  }

  static String morethan8digites(String value) {
        if (value.length < 8) {
          return 'كلمة المرور قصيرة جدا';
        }
        return null;
  }


  static String matchPassword(String password ,String value) {
        if(value != password){
          return "كلمة المرور غير متطابقة";
        }
        return null;
  }



  static String saudiNumber(value) {
    RegExp regExp = new RegExp(
          r'^(009665|9665|\+9665|05|5)(5|0|3|6|4|9|1|8|7)([0-9]{7})$',
          caseSensitive: false,
          multiLine: false,
        );

        if (!regExp.hasMatch(value)) {
          return 'يرجي ادخال رقم جوال صحيح';
        }
        return null;
      }
      
}