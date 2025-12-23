extension IconString on String {
  String get icon => "assets/$this";
}
extension NullString on String? {
  bool get isNullString => this == null || (this?.isEmpty ?? false);

}

