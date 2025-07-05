class PlaceDto {
  final String place;
  final String placeId;
  final Location location;
  final String granularity;
  final Viewport viewport;
  final Bounds? bounds;
  final String formattedAddress;
  final PostalAddress postalAddress;
  final List<AddressComponent> addressComponents;
  final List<String> types;
  final PlusCode? plusCode;

  PlaceDto({
    required this.place,
    required this.placeId,
    required this.location,
    required this.granularity,
    required this.viewport,
    required this.bounds,
    required this.formattedAddress,
    required this.postalAddress,
    required this.addressComponents,
    required this.types,
    required this.plusCode,
  });

  factory PlaceDto.fromJson(Map<String, dynamic> json) {
    return PlaceDto(
      place: json['place'] ?? '',
      placeId: json['placeId'] ?? '',
      location: Location.fromJson(json['location']),
      granularity: json['granularity'] ?? '',
      viewport: Viewport.fromJson(json['viewport']),
      bounds: json['bounds'] != null ? Bounds.fromJson(json['bounds']) : null,
      formattedAddress: json['formattedAddress'] ?? '',
      postalAddress: PostalAddress.fromJson(json['postalAddress']),
      addressComponents: (json['addressComponents'] as List)
          .map((e) => AddressComponent.fromJson(e))
          .toList(),
      types: List<String>.from(json['types']),
      plusCode: json['plusCode'] != null ? PlusCode.fromJson(json['plusCode']) : null,
    );
  }
}

class Location {
  final double latitude;
  final double longitude;

  Location({required this.latitude, required this.longitude});

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      latitude: (json['latitude'] ?? 0).toDouble(),
      longitude: (json['longitude'] ?? 0).toDouble(),
    );
  }
}

class Viewport {
  final Location low;
  final Location high;

  Viewport({required this.low, required this.high});

  factory Viewport.fromJson(Map<String, dynamic> json) {
    return Viewport(
      low: Location.fromJson(json['low']),
      high: Location.fromJson(json['high']),
    );
  }
}

class Bounds {
  final Location low;
  final Location high;

  Bounds({required this.low, required this.high});

  factory Bounds.fromJson(Map<String, dynamic> json) {
    return Bounds(
      low: Location.fromJson(json['low']),
      high: Location.fromJson(json['high']),
    );
  }
}

class PostalAddress {
  final String regionCode;
  final String languageCode;
  final String postalCode;
  final String? administrativeArea;
  final String locality;
  final List<String> addressLines;

  PostalAddress({
    required this.regionCode,
    required this.languageCode,
    required this.postalCode,
    this.administrativeArea,
    required this.locality,
    required this.addressLines,
  });

  factory PostalAddress.fromJson(Map<String, dynamic> json) {
    return PostalAddress(
      regionCode: json['regionCode'] ?? '',
      languageCode: json['languageCode'] ?? '',
      postalCode: json['postalCode'] ?? '',
      administrativeArea: json['administrativeArea'],
      locality: json['locality'] ?? '',
      addressLines: List<String>.from(json['addressLines'] ?? []),
    );
  }
}

class AddressComponent {
  final String longText;
  final String shortText;
  final List<String> types;
  final String? languageCode;

  AddressComponent({
    required this.longText,
    required this.shortText,
    required this.types,
    this.languageCode,
  });

  factory AddressComponent.fromJson(Map<String, dynamic> json) {
    return AddressComponent(
      longText: json['longText'] ?? '',
      shortText: json['shortText'] ?? '',
      types: List<String>.from(json['types'] ?? []),
      languageCode: json['languageCode'],
    );
  }
}

class PlusCode {
  final String globalCode;
  final String? compoundCode;

  PlusCode({
    required this.globalCode,
    this.compoundCode,
  });

  factory PlusCode.fromJson(Map<String, dynamic> json) {
    return PlusCode(
      globalCode: json['globalCode'],
      compoundCode: json['compoundCode'],
    );
  }
}
