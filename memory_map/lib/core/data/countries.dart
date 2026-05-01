/// Minimal ISO 3166-1 alpha-2 country list for the MVP picker.
/// We keep both Portuguese and English names so the user can search comfortably.
class CountryEntry {
  const CountryEntry(this.code, this.namePt, this.nameEn);
  final String code;
  final String namePt;
  final String nameEn;

  bool matches(String query) {
    final q = query.toLowerCase().trim();
    if (q.isEmpty) return true;
    return namePt.toLowerCase().contains(q) ||
        nameEn.toLowerCase().contains(q) ||
        code.toLowerCase().contains(q);
  }
}

const kCountries = <CountryEntry>[
  CountryEntry('PT', 'Portugal', 'Portugal'),
  CountryEntry('ES', 'Espanha', 'Spain'),
  CountryEntry('FR', 'França', 'France'),
  CountryEntry('IT', 'Itália', 'Italy'),
  CountryEntry('DE', 'Alemanha', 'Germany'),
  CountryEntry('GB', 'Reino Unido', 'United Kingdom'),
  CountryEntry('IE', 'Irlanda', 'Ireland'),
  CountryEntry('NL', 'Holanda', 'Netherlands'),
  CountryEntry('BE', 'Bélgica', 'Belgium'),
  CountryEntry('CH', 'Suíça', 'Switzerland'),
  CountryEntry('AT', 'Áustria', 'Austria'),
  CountryEntry('GR', 'Grécia', 'Greece'),
  CountryEntry('SE', 'Suécia', 'Sweden'),
  CountryEntry('NO', 'Noruega', 'Norway'),
  CountryEntry('DK', 'Dinamarca', 'Denmark'),
  CountryEntry('FI', 'Finlândia', 'Finland'),
  CountryEntry('IS', 'Islândia', 'Iceland'),
  CountryEntry('PL', 'Polónia', 'Poland'),
  CountryEntry('CZ', 'Chéquia', 'Czechia'),
  CountryEntry('HU', 'Hungria', 'Hungary'),
  CountryEntry('HR', 'Croácia', 'Croatia'),
  CountryEntry('RO', 'Roménia', 'Romania'),
  CountryEntry('TR', 'Turquia', 'Turkey'),
  CountryEntry('US', 'EUA', 'United States'),
  CountryEntry('CA', 'Canadá', 'Canada'),
  CountryEntry('MX', 'México', 'Mexico'),
  CountryEntry('BR', 'Brasil', 'Brazil'),
  CountryEntry('AR', 'Argentina', 'Argentina'),
  CountryEntry('CL', 'Chile', 'Chile'),
  CountryEntry('PE', 'Peru', 'Peru'),
  CountryEntry('CO', 'Colômbia', 'Colombia'),
  CountryEntry('JP', 'Japão', 'Japan'),
  CountryEntry('KR', 'Coreia do Sul', 'South Korea'),
  CountryEntry('CN', 'China', 'China'),
  CountryEntry('IN', 'Índia', 'India'),
  CountryEntry('TH', 'Tailândia', 'Thailand'),
  CountryEntry('VN', 'Vietname', 'Vietnam'),
  CountryEntry('ID', 'Indonésia', 'Indonesia'),
  CountryEntry('PH', 'Filipinas', 'Philippines'),
  CountryEntry('AU', 'Austrália', 'Australia'),
  CountryEntry('NZ', 'Nova Zelândia', 'New Zealand'),
  CountryEntry('AE', 'Emirados Árabes', 'United Arab Emirates'),
  CountryEntry('EG', 'Egipto', 'Egypt'),
  CountryEntry('MA', 'Marrocos', 'Morocco'),
  CountryEntry('ZA', 'África do Sul', 'South Africa'),
  CountryEntry('CV', 'Cabo Verde', 'Cape Verde'),
  CountryEntry('AO', 'Angola', 'Angola'),
  CountryEntry('MZ', 'Moçambique', 'Mozambique'),
];

CountryEntry? countryByCode(String code) {
  for (final c in kCountries) {
    if (c.code == code) return c;
  }
  return null;
}

String countryNamePt(String code) => countryByCode(code)?.namePt ?? code;
