class Constants {
  static String exercisePreviewTag(int id) =>
      'nearhuscarl.gymlab.exercise_preview_$id';

  static final DateTime endDateLimit = DateTime.now();
  static final DateTime startDateLimit =
      endDateLimit.subtract(Duration(days: 365 * 5));
}
