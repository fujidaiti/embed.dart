class UsageError extends Error {
  UsageError(this.message);
  final String message;

  @override
  String toString() => message;
}

class ShouldNeverBeHappenError extends Error {
  ShouldNeverBeHappenError();

  @override
  String toString() => "This error should never be happen. "
      "If you see this message, please report the error with a stacktrace "
      "on the GitHub issue page (https://github.com/fujidaiti/embed.dart/issues). "
      "It will be very helpful.";
}
