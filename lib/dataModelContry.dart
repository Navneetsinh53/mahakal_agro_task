/// This model class is used to store Country details
class Country {
  final String countryCode;
  final String countryName;
  final String isoNumeric;
  final String isoAlpha3;
  final String fipsCode;
  final String continent;
  final String continentName;
  final String capital;
  final String areaInSqKm;
  final String population;
  final String currencyCode;
  final String languages;
  final String geonameId;
  final String west;
  final String north;
  final String east;
  final String south;
  final String postalCodeFormat;

  Country({
    required this.countryCode,
    required this.countryName,
    required this.isoNumeric,
    required this.isoAlpha3,
    required this.fipsCode,
    required this.continent,
    required this.continentName,
    required this.capital,
    required this.areaInSqKm,
    required this.population,
    required this.currencyCode,
    required this.languages,
    required this.geonameId,
    required this.west,
    required this.north,
    required this.east,
    required this.south,
    required this.postalCodeFormat,
  });

Map<String, dynamic> toMap() {
    return {
      'countryCode': countryCode,
      'countryName': countryName,
      'isoNumeric': isoNumeric,
      'isoAlpha3': isoAlpha3,
      'fipsCode': fipsCode,
      'continent': continent,
      'continentName': continentName,
      'capital': capital,
      'areaInSqKm': areaInSqKm,
      'population': population,
      'currencyCode': currencyCode,
      'languages': languages,
      'geonameId': geonameId,
      'west': west,
      'north': north,
      'east': east,
      'south': south,
      'postalCodeFormat': postalCodeFormat,
    };
  }

  factory Country.fromMap(Map<String, dynamic> map) {
    return Country(
      countryCode: map['countryCode'],
      countryName: map['countryName'],
      isoNumeric: map['isoNumeric'],
      isoAlpha3: map['isoAlpha3'],
      fipsCode: map['fipsCode'],
      continent: map['continent'],
      continentName: map['continentName'],
      capital: map['capital'],
      areaInSqKm: map['areaInSqKm'],
      population: map['population'],
      currencyCode: map['currencyCode'],
      languages: map['languages'],
      geonameId: map['geonameId'],
      west: map['west'],
      north: map['north'],
      east: map['east'],
      south: map['south'],
      postalCodeFormat: map['postalCodeFormat'],
    );
  }

}