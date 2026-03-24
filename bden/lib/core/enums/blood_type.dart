enum BloodType {
  aPositive,
  aNegative,
  bPositive,
  bNegative,
  abPositive,
  abNegative,
  oPositive,
  oNegative;

  String get label {
    const labels = {
      BloodType.aPositive: 'A+',
      BloodType.aNegative: 'A-',
      BloodType.bPositive: 'B+',
      BloodType.bNegative: 'B-',
      BloodType.abPositive: 'AB+',
      BloodType.abNegative: 'AB-',
      BloodType.oPositive: 'O+',
      BloodType.oNegative: 'O-',
    };
    return labels[this]!;
  }

  static BloodType fromString(String s) =>
      BloodType.values.firstWhere((e) => e.label == s);
}
