/// Categories available for investment funds.
enum FundCategory {
  fpv,
  fic;

  /// Creates a [FundCategory] from its string representation.
  static FundCategory fromString(String value) {
    return FundCategory.values.firstWhere(
      (e) => e.name == value.toLowerCase(),
      orElse: () => throw ArgumentError('Unknown FundCategory: $value'),
    );
  }
}
