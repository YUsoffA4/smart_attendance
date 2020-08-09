

class FormattedTime{
  final int day, month, year;
  final String time;

  FormattedTime({
    this.time = "",
    this.day,
    this.month,
    this.year
  });

  @override
  String toString() {
    return "$time $day/$month/$year";
  }
}