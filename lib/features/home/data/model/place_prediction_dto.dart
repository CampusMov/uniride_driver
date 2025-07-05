class PredictionDto {
  final String description;
  final List<MatchedSubstring> matchedSubstrings;
  final String placeId;
  final String reference;
  final StructuredFormatting structuredFormatting;
  final List<Term> terms;
  final List<String> types;

  PredictionDto({
    required this.description,
    required this.matchedSubstrings,
    required this.placeId,
    required this.reference,
    required this.structuredFormatting,
    required this.terms,
    required this.types,
  });

  factory PredictionDto.fromJson(Map<String, dynamic> json) {
    return PredictionDto(
      description: json['description'] ?? '',
      matchedSubstrings: (json['matched_substrings'] as List<dynamic>?)
              ?.map((x) => MatchedSubstring.fromJson(x))
              .toList() ??
          [],
      placeId: json['place_id'] ?? '',
      reference: json['reference'] ?? '',
      structuredFormatting: json['structured_formatting'] != null
          ? StructuredFormatting.fromJson(json['structured_formatting'])
          : StructuredFormatting(mainText: '', mainTextMatchedSubstrings: [], secondaryText: ''),
      terms: (json['terms'] as List<dynamic>?)
              ?.map((x) => Term.fromJson(x))
              .toList() ??
          [],
      types: (json['types'] as List<dynamic>?)
              ?.map((x) => x.toString())
              .toList() ??
          [],
    );
  }
}

class MatchedSubstring {
  final int length;
  final int offset;

  MatchedSubstring({
    required this.length,
    required this.offset,
  });

  factory MatchedSubstring.fromJson(Map<String, dynamic> json) {
    return MatchedSubstring(
      length: json['length'] ?? 0,
      offset: json['offset'] ?? 0,
    );
  }
}

class StructuredFormatting {
  final String mainText;
  final List<MatchedSubstring> mainTextMatchedSubstrings;
  final String secondaryText;

  StructuredFormatting({
    required this.mainText,
    required this.mainTextMatchedSubstrings,
    required this.secondaryText,
  });

  factory StructuredFormatting.fromJson(Map<String, dynamic> json) {
    return StructuredFormatting(
      mainText: json['main_text'] ?? '',
      mainTextMatchedSubstrings: (json['main_text_matched_substrings'] as List<dynamic>?)
              ?.map((x) => MatchedSubstring.fromJson(x))
              .toList() ??
          [],
      secondaryText: json['secondary_text'] ?? '',
    );
  }
}

class Term {
  final int offset;
  final String value;

  Term({
    required this.offset,
    required this.value,
  });

  factory Term.fromJson(Map<String, dynamic> json) {
    return Term(
      offset: json['offset'] ?? 0,
      value: json['value'] ?? '',
    );
  }
}
