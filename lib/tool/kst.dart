class KST{
  final String isoTime;
  const KST({required this.isoTime});

  @override
  String toString() {
    // Parse the ISO string into a DateTime object
    //DateTime utcTime = DateTime.parse(isoTime).toUtc();

    // Convert UTC to Korean time (UTC+9)
    DateTime koreanTime = DateTime.parse(isoTime).add(Duration(hours: 9));

    // Format the Korean time in the desired style
    String period = koreanTime.hour < 12 ? "오전" : "오후";
    int hour = koreanTime.hour % 12 == 0 ? 12 : koreanTime.hour % 12;
    String formattedTime =
        "${koreanTime.year}년 ${koreanTime.month}월 ${koreanTime.day}일 $period $hour시 ${koreanTime.minute}분";

    return formattedTime;
  }
}
