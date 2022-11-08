import 'numbers_helper.dart';

class NumberToWords {
  static String? _convertLessThanOneThousand(int number, String locale) {
    String? soFar;
    final numNames = getNumsNames(locale);
    final hundredNames = getHundredNames(locale);
    final tensNames = getTensNames(locale);

    if (number % 100 < 20) {
      soFar = numNames[number % 100];
      number = (number ~/ 100).toInt();
    } else {
      soFar = numNames[number % 10];
      number = (number ~/ 10).toInt();

      soFar = (tensNames[number % 10].length == 0
              ? ""
              : "${tensNames[number % 10]}") +
          (soFar == "" ? "" : getAnd(locale) + soFar.toString());
      number = (number ~/ 10).toInt();
    }
    if (number == 0) {
      return soFar;
    }

    // return hundredNames[number] +
    return hundredNames[number] +
        (hundredNames[number].length != 0 && soFar!.length != 0
            ? getAnd(locale) + soFar.toString()
            : soFar);
  }

  static String convert(int number, String locale) {
    // 0 to 999 999 999 999
    if (number == 0) {
      return getZero(locale);
    }

    String snumber = number.toString().padLeft(12, "0");
    // XXXnnnnnnnnn
    int billions = int.parse(snumber.substring(0, 3));
    // nnnXXXnnnnnn
    int millions = int.parse(snumber.substring(3, 6));
    // nnnnnnXXXnnn
    int hundredThousands = int.parse(snumber.substring(6, 9));
    // nnnnnnnnnXXX
    int thousands = int.parse(snumber.substring(9, 12));

    String tradBillions = _getBillions(billions, locale);
    String tradMillions = _getMillions(millions, locale);
    String tradHundredThousands = _getThousands(hundredThousands, locale);
    String? tradThousand = _convertLessThanOneThousand(thousands, locale);

    String result = tradBillions;

    result = result +
        (tradBillions.length != 0 && tradMillions.length != 0
            ? getAnd(locale) + tradMillions.toString()
            : tradMillions);

    result = result +
        ((tradBillions.length != 0 || tradMillions.length != 0) &&
                tradHundredThousands.length != 0
            ? getAnd(locale) + tradHundredThousands.toString()
            : tradHundredThousands);

    result = result +
        ((tradBillions.length != 0 ||
                    tradMillions.length != 0 ||
                    tradHundredThousands.length != 0) &&
                tradThousand!.length != 0
            ? getAnd(locale) + tradThousand.toString()
            : tradThousand!);

    // remove extra spaces!
    return result.replaceAll("^\\s+", "").replaceAll("\\b\\s{2,}\\b", " ");
  }

  static String _getBillions(int billions, String locale) {
    String tradBillions;
    var lessThanOneThousand = _convertLessThanOneThousand(billions, locale);
    switch (billions) {
      case 0:
        tradBillions = "";
        break;
      case 1:
        tradBillions = lessThanOneThousand! +
            (lessThanOneThousand.length > 0 ? " " : "") +
            "${getBillion(locale)}";
        break;
      default:
        tradBillions = lessThanOneThousand! +
            (lessThanOneThousand.length > 0 ? " " : "") +
            "${getBillion(locale)}";
    }
    return tradBillions;
  }

  static String _getMillions(int millions, String locale) {
    String tradMillions;
    var lessThanOneThousand = _convertLessThanOneThousand(millions, locale);

    switch (millions) {
      case 0:
        tradMillions = "";
        break;
      case 1:
        tradMillions = lessThanOneThousand! +
            (lessThanOneThousand.length > 0 ? " " : "") +
            "${getMillion(locale)}";
        break;
      default:
        tradMillions = lessThanOneThousand! +
            (lessThanOneThousand.length > 0 ? " " : "") +
            "${getMillion(locale)}";
    }
    return tradMillions;
  }

  static String _getThousands(int hundredThousands, String locale) {
    String tradHundredThousands;
    var lessThanOneThousand =
        _convertLessThanOneThousand(hundredThousands, locale);

    switch (hundredThousands) {
      case 0:
        tradHundredThousands = "";
        break;
      case 1:
        tradHundredThousands = lessThanOneThousand! +
            (lessThanOneThousand.length > 0 ? " " : "") +
            "${getThousand(locale)}";
        break;
      default:
        tradHundredThousands = lessThanOneThousand! +
            (lessThanOneThousand.length > 0 ? " " : "") +
            "${getThousand(locale)}";
    }

    return tradHundredThousands;
  }

  static bool isNumeric(String nums) {
    if (nums.trim().isEmpty) {
      return false;
    }

    return double.tryParse(nums) != null;
  }
}
