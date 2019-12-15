/// Thank WitVault for saving me my last 2 brain cells at 12:19 AM
/// https://stackoverflow.com/a/56458586/9449426
String formatHHMMSS(int seconds) {
  final hours = (seconds / 3600).truncate();
  final minutes = (seconds / 60).truncate();
  seconds = (seconds % 3600).truncate();

  String hoursStr = (hours).toString().padLeft(2, '0');
  String minutesStr = (minutes).toString().padLeft(2, '0');
  String secondsStr = (seconds % 60).toString().padLeft(2, '0');

  if (hours == 0) {
    return "$minutesStr:$secondsStr";
  }

  return "$hoursStr:$minutesStr:$secondsStr";
}
