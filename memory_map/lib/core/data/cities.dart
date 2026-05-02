/// Small curated city list for MVP.
/// If a city isn't listed, the UI still allows manual entry.
const kCitiesByCountry = <String, List<String>>{
  'PT': [
    'Lisbon',
    'Porto',
    'Braga',
    'Coimbra',
    'Aveiro',
    'Faro',
    'Funchal',
    'Ponta Delgada',
  ],
  'ES': [
    'Madrid',
    'Barcelona',
    'Valencia',
    'Seville',
    'Malaga',
    'Bilbao',
    'Granada',
    'Zaragoza',
  ],
  'FR': [
    'Paris',
    'Lyon',
    'Marseille',
    'Nice',
    'Toulouse',
    'Bordeaux',
    'Strasbourg',
    'Nantes',
  ],
  'IT': [
    'Rome',
    'Milan',
    'Venice',
    'Florence',
    'Naples',
    'Turin',
    'Bologna',
    'Pisa',
  ],
  'DE': [
    'Berlin',
    'Munich',
    'Hamburg',
    'Frankfurt',
    'Cologne',
    'Dresden',
    'Stuttgart',
  ],
  'GB': [
    'London',
    'Manchester',
    'Liverpool',
    'Edinburgh',
    'Glasgow',
    'Birmingham',
  ],
  'NL': [
    'Amsterdam',
    'Rotterdam',
    'The Hague',
    'Utrecht',
    'Eindhoven',
  ],
  'BR': [
    'São Paulo',
    'Rio de Janeiro',
    'Belo Horizonte',
    'Brasília',
    'Salvador',
    'Fortaleza',
    'Recife',
    'Porto Alegre',
  ],
  'US': [
    'New York',
    'Los Angeles',
    'San Francisco',
    'Chicago',
    'Miami',
    'Washington',
    'Boston',
  ],
};

List<String> citiesForCountries(List<String> countryCodes) {
  final out = <String>{};
  for (final c in countryCodes) {
    final list = kCitiesByCountry[c];
    if (list != null) out.addAll(list);
  }
  final result = out.toList();
  result.sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
  return result;
}
