class Validation {
  final String value;
  final String error;

  bool get hasError => error == null;

  Validation({ this.value, this.error });
}