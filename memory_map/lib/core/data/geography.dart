class GeographyEntry {
  const GeographyEntry({
    required this.name,
    required this.code,
    required this.districts,
  });

  final String name;
  final String code; // Still needed for flags internally
  final List<String> districts;

  bool matches(String query) {
    final q = query.toLowerCase().trim();
    if (q.isEmpty) return true;
    return name.toLowerCase().contains(q) || code.toLowerCase().contains(q);
  }
}

const kGeography = <GeographyEntry>[
  GeographyEntry(
    name: 'Portugal',
    code: 'PT',
    districts: [
      'Aveiro', 'Beja', 'Braga', 'Bragança', 'Castelo Branco', 'Coimbra',
      'Évora', 'Faro', 'Guarda', 'Leiria', 'Lisboa', 'Portalegre', 'Porto',
      'Santarém', 'Setúbal', 'Viana do Castelo', 'Vila Real', 'Viseu',
      'Azores', 'Madeira'
    ],
  ),
  GeographyEntry(
    name: 'Spain',
    code: 'ES',
    districts: [
      'Andalusia', 'Aragon', 'Asturias', 'Balearic Islands', 'Basque Country',
      'Canary Islands', 'Cantabria', 'Castile-La Mancha', 'Castile and León',
      'Catalonia', 'Extremadura', 'Galicia', 'La Rioja', 'Madrid', 'Murcia',
      'Navarre', 'Valencia'
    ],
  ),
  GeographyEntry(
    name: 'France',
    code: 'FR',
    districts: [
      'Auvergne-Rhône-Alpes', 'Bourgogne-Franche-Comté', 'Brittany',
      'Centre-Val de Loire', 'Corsica', 'Grand Est', 'Hauts-de-France',
      'Île-de-France', 'Normandy', 'Nouvelle-Aquitaine', 'Occitanie',
      'Pays de la Loire', 'Provence-Alpes-Côte d\'Azur'
    ],
  ),
  GeographyEntry(
    name: 'Italy',
    code: 'IT',
    districts: [
      'Abruzzo', 'Aosta Valley', 'Apulia', 'Basilicata', 'Calabria', 'Campania',
      'Emilia-Romagna', 'Friuli Venezia Giulia', 'Lazio', 'Liguria', 'Lombardy',
      'Marche', 'Molise', 'Piedmont', 'Sardinia', 'Sicily', 'Tuscany',
      'Trentino-South Tyrol', 'Umbria', 'Veneto'
    ],
  ),
  GeographyEntry(
    name: 'Germany',
    code: 'DE',
    districts: [
      'Baden-Württemberg', 'Bavaria', 'Berlin', 'Brandenburg', 'Bremen',
      'Hamburg', 'Hesse', 'Lower Saxony', 'Mecklenburg-Vorpommern',
      'North Rhine-Westphalia', 'Rhineland-Palatinate', 'Saarland',
      'Saxony', 'Saxony-Anhalt', 'Schleswig-Holstein', 'Thuringia'
    ],
  ),
  GeographyEntry(
    name: 'United Kingdom',
    code: 'GB',
    districts: ['England', 'Scotland', 'Wales', 'Northern Ireland'],
  ),
  GeographyEntry(
    name: 'Ireland',
    code: 'IE',
    districts: ['Leinster', 'Munster', 'Connacht', 'Ulster'],
  ),
  GeographyEntry(
    name: 'Netherlands',
    code: 'NL',
    districts: [
      'Drenthe', 'Flevoland', 'Friesland', 'Gelderland', 'Groningen',
      'Limburg', 'North Brabant', 'North Holland', 'Overijssel',
      'South Holland', 'Utrecht', 'Zeeland'
    ],
  ),
  GeographyEntry(
    name: 'Belgium',
    code: 'BE',
    districts: ['Flanders', 'Wallonia', 'Brussels-Capital Region'],
  ),
  GeographyEntry(
    name: 'Switzerland',
    code: 'CH',
    districts: [
      'Aargau', 'Appenzell Ausserrhoden', 'Appenzell Innerrhoden', 'Basel-Landschaft',
      'Basel-Stadt', 'Bern', 'Fribourg', 'Geneva', 'Glarus', 'Graubünden', 'Jura',
      'Lucerne', 'Neuchâtel', 'Nidwalden', 'Obwalden', 'Schaffhausen', 'Schwyz',
      'Solothurn', 'St. Gallen', 'Thurgau', 'Ticino', 'Uri', 'Valais', 'Vaud', 'Zug', 'Zurich'
    ],
  ),
  GeographyEntry(
    name: 'Austria',
    code: 'AT',
    districts: [
      'Burgenland', 'Carinthia', 'Lower Austria', 'Upper Austria', 'Salzburg',
      'Styria', 'Tyrol', 'Vorarlberg', 'Vienna'
    ],
  ),
  GeographyEntry(
    name: 'Greece',
    code: 'GR',
    districts: [
      'Attica', 'Central Greece', 'Central Macedonia', 'Crete', 'Eastern Macedonia and Thrace',
      'Epirus', 'Ionian Islands', 'North Aegean', 'Peloponnese', 'South Aegean',
      'Thessaly', 'Western Greece', 'Western Macedonia'
    ],
  ),
  GeographyEntry(
    name: 'Sweden',
    code: 'SE',
    districts: [
      'Blekinge', 'Dalarna', 'Gotland', 'Gävleborg', 'Halland', 'Jämtland',
      'Jönköping', 'Kalmar', 'Kronoberg', 'Norrbotten', 'Skåne', 'Stockholm',
      'Södermanland', 'Uppsala', 'Värmland', 'Västerbotten', 'Västernorrland',
      'Västmanland', 'Västra Götaland', 'Örebro', 'Östergötland'
    ],
  ),
  GeographyEntry(
    name: 'Norway',
    code: 'NO',
    districts: [
      'Agder', 'Innlandet', 'Møre og Romsdal', 'Nordland', 'Oslo', 'Rogaland',
      'Troms og Finnmark', 'Trøndelag', 'Vestfold og Telemark', 'Vestland', 'Viken'
    ],
  ),
  GeographyEntry(
    name: 'Denmark',
    code: 'DK',
    districts: [
      'Capital Region of Denmark', 'Central Denmark Region', 'North Denmark Region',
      'Region Zealand', 'Region of Southern Denmark'
    ],
  ),
  GeographyEntry(
    name: 'Finland',
    code: 'FI',
    districts: [
      'Lapland', 'North Ostrobothnia', 'Kainuu', 'North Karelia', 'North Savo',
      'South Savo', 'South Ostrobothnia', 'Ostrobothnia', 'Pirkanmaa', 'Satakunta',
      'Central Finland', 'South Karelia', 'Päijät-Häme', 'Kanta-Häme', 'Uusimaa',
      'Kymenlaakso', 'Southwest Finland', 'Åland'
    ],
  ),
  GeographyEntry(
    name: 'Iceland',
    code: 'IS',
    districts: [
      'Capital Region', 'Southern Peninsula', 'Western Region', 'Westfjords',
      'Northwestern Region', 'Northeastern Region', 'Eastern Region', 'Southern Region'
    ],
  ),
  GeographyEntry(
    name: 'Poland',
    code: 'PL',
    districts: [
      'Greater Poland', 'Kuyavian-Pomeranian', 'Lesser Poland', 'Łódź', 'Lower Silesian',
      'Lublin', 'Lubusz', 'Masovian', 'Opole', 'Podlaskie', 'Pomeranian', 'Silesian',
      'Subcarpathian', 'Holy Cross', 'Warmian-Masurian', 'West Pomeranian'
    ],
  ),
  GeographyEntry(
    name: 'Czechia',
    code: 'CZ',
    districts: [
      'Prague', 'Central Bohemian', 'South Bohemian', 'Plzeň', 'Karlovy Vary',
      'Ústí nad Labem', 'Liberec', 'Hradec Králové', 'Pardubice', 'Vysočina',
      'South Moravian', 'Olomouc', 'Zlín', 'Moravian-Silesian'
    ],
  ),
  GeographyEntry(
    name: 'Hungary',
    code: 'HU',
    districts: [
      'Budapest', 'Bács-Kiskun', 'Baranya', 'Békés', 'Borsod-Abaúj-Zemplén', 'Csongrád-Csanád',
      'Fejér', 'Győr-Moson-Sopron', 'Hajdú-Bihar', 'Heves', 'Jász-Nagykun-Szolnok',
      'Komárom-Esztergom', 'Nógrád', 'Pest', 'Somogy', 'Szabolcs-Szatmár-Bereg', 'Tolna',
      'Vas', 'Veszprém', 'Zala'
    ],
  ),
  GeographyEntry(
    name: 'Croatia',
    code: 'HR',
    districts: [
      'Zagreb County', 'Krapina-Zagorje', 'Sisak-Moslavina', 'Karlovac', 'Varaždin',
      'Koprivnica-Križevci', 'Bjelovar-Bilogora', 'Primorje-Gorski Kotar', 'Lika-Senj',
      'Virovitica-Podravina', 'Požega-Slavonaware', 'Slavonski Brod-Posavina', 'Zadar',
      'Osijek-Baranja', 'Šibenik-Knin', 'Vukovar-Srijem', 'Split-Dalmatia', 'Istria',
      'Dubrovnik-Neretva', 'Međimurje', 'City of Zagreb'
    ],
  ),
  GeographyEntry(
    name: 'Romania',
    code: 'RO',
    districts: [
      'Alba', 'Arad', 'Argeș', 'Bacău', 'Bihor', 'Bistrița-Năsăud', 'Botoșani', 'Brașov',
      'Brăila', 'Buzău', 'Caraș-Severin', 'Călărași', 'Cluj', 'Constanța', 'Covasna',
      'Dâmbovița', 'Dolj', 'Galați', 'Giurgiu', 'Gorj', 'Harghita', 'Hunedoara',
      'Ialomița', 'Iași', 'Ilfov', 'Maramureș', 'Mehedinți', 'Mureș', 'Neamț', 'Olt',
      'Prahova', 'Satu Mare', 'Sălaj', 'Sibiu', 'Suceava', 'Teleorman', 'Timiș', 'Tulcea',
      'Vaslui', 'Vâlcea', 'Vrancea', 'Bucharest'
    ],
  ),
  GeographyEntry(
    name: 'Turkey',
    code: 'TR',
    districts: [
      'Istanbul', 'Ankara', 'Izmir', 'Bursa', 'Antalya', 'Adana', 'Konya', 'Gaziantep',
      'Mersin', 'Kayseri', 'Diyarbakır', 'Samsun', 'Denizli', 'Muğla', 'Eskişehir'
    ],
  ),
  GeographyEntry(
    name: 'United States',
    code: 'US',
    districts: [
      'Alabama', 'Alaska', 'American Samoa', 'Arizona', 'Arkansas', 'California',
      'Colorado', 'Connecticut', 'Delaware', 'District of Columbia', 'Florida',
      'Georgia', 'Guam', 'Hawaii', 'Idaho', 'Illinois', 'Indiana', 'Iowa', 'Kansas',
      'Kentucky', 'Louisiana', 'Maine', 'Maryland', 'Massachusetts', 'Michigan',
      'Minnesota', 'Mississippi', 'Missouri', 'Montana', 'Nebraska', 'Nevada',
      'New Hampshire', 'New Jersey', 'New Mexico', 'New York', 'North Carolina',
      'North Dakota', 'Northern Mariana Islands', 'Ohio', 'Oklahoma', 'Oregon',
      'Pennsylvania', 'Puerto Rico', 'Rhode Island', 'South Carolina', 'South Dakota',
      'Tennessee', 'Texas', 'Utah', 'Vermont', 'Virgin Islands', 'Virginia',
      'Washington', 'West Virginia', 'Wisconsin', 'Wyoming'
    ],
  ),
  GeographyEntry(
    name: 'Canada',
    code: 'CA',
    districts: [
      'Alberta', 'British Columbia', 'Manitoba', 'New Brunswick',
      'Newfoundland and Labrador', 'Nova Scotia', 'Ontario', 'Prince Edward Island',
      'Quebec', 'Saskatchewan', 'Northwest Territories', 'Nunavut', 'Yukon'
    ],
  ),
  GeographyEntry(
    name: 'Mexico',
    code: 'MX',
    districts: [
      'Aguascalientes', 'Baja California', 'Baja California Sur', 'Campeche', 'Chiapas',
      'Chihuahua', 'Coahuila', 'Colima', 'Durango', 'Guanajuato', 'Guerrero', 'Hidalgo',
      'Jalisco', 'State of Mexico', 'Mexico City', 'Michoacán', 'Morelos', 'Nayarit',
      'Nuevo León', 'Oaxaca', 'Puebla', 'Querétaro', 'Quintana Roo', 'San Luis Potosí',
      'Sinaloa', 'Sonora', 'Tabasco', 'Tamaulipas', 'Tlaxcala', 'Veracruz', 'Yucatán', 'Zacatecas'
    ],
  ),
  GeographyEntry(
    name: 'Brazil',
    code: 'BR',
    districts: [
      'Acre', 'Alagoas', 'Amapá', 'Amazonas', 'Bahia', 'Ceará', 'Distrito Federal',
      'Espírito Santo', 'Goiás', 'Maranhão', 'Mato Grosso', 'Mato Grosso do Sul',
      'Minas Gerais', 'Pará', 'Paraíba', 'Paraná', 'Pernambuco', 'Piauí', 'Rio de Janeiro',
      'Rio Grande do Norte', 'Rio Grande do Sul', 'Rondônia', 'Roraima', 'Santa Catarina',
      'São Paulo', 'Sergipe', 'Tocantins'
    ],
  ),
  GeographyEntry(
    name: 'Argentina',
    code: 'AR',
    districts: [
      'Buenos Aires', 'Catamarca', 'Chaco', 'Chubut', 'Córdoba', 'Corrientes',
      'Entre Ríos', 'Formosa', 'Jujuy', 'La Pampa', 'La Rioja', 'Mendoza', 'Misiones',
      'Neuquén', 'Río Negro', 'Salta', 'San Juan', 'San Luis', 'Santa Cruz', 'Santa Fe',
      'Santiago del Estero', 'Tierra del Fuego', 'Tucumán'
    ],
  ),
  GeographyEntry(
    name: 'Chile',
    code: 'CL',
    districts: [
      'Arica y Parinacota', 'Tarapacá', 'Antofagasta', 'Atacama', 'Coquimbo', 'Valparaíso',
      'Metropolitana de Santiago', 'O\'Higgins', 'Maule', 'Ñuble', 'Biobío', 'La Araucanía',
      'Los Ríos', 'Los Lagos', 'Aysén', 'Magallanes'
    ],
  ),
  GeographyEntry(
    name: 'Peru',
    code: 'PE',
    districts: [
      'Amazonas', 'Ancash', 'Apurímac', 'Arequipa', 'Ayacucho', 'Cajamarca', 'Callao',
      'Cusco', 'Huancavelica', 'Huánuco', 'Ica', 'Junín', 'La Libertad', 'Lambayeque',
      'Lima', 'Loreto', 'Madre de Dios', 'Moquegua', 'Pasco', 'Piura', 'Puno',
      'San Martín', 'Tacna', 'Tumbes', 'Ucayali'
    ],
  ),
  GeographyEntry(
    name: 'Colombia',
    code: 'CO',
    districts: [
      'Amazonas', 'Antioquia', 'Arauca', 'Atlántico', 'Bogotá', 'Bolívar', 'Boyacá',
      'Caldas', 'Caquetá', 'Casanare', 'Cauca', 'Cesar', 'Chocó', 'Córdoba', 'Cundinamarca',
      'Guainía', 'Guaviare', 'Huila', 'La Guajira', 'Magdalena', 'Meta', 'Nariño',
      'Norte de Santander', 'Putumayo', 'Quindío', 'Risaralda', 'San Andrés', 'Santander',
      'Sucre', 'Tolima', 'Valle del Cauca', 'Vaupés', 'Vichada'
    ],
  ),
  GeographyEntry(
    name: 'Japan',
    code: 'JP',
    districts: [
      'Hokkaido', 'Aomori', 'Iwate', 'Miyagi', 'Akita', 'Yamagata', 'Fukushima',
      'Ibaraki', 'Tochigi', 'Gunma', 'Saitama', 'Chiba', 'Tokyo', 'Kanagawa',
      'Niigata', 'Toyama', 'Ishikawa', 'Fukui', 'Yamanashi', 'Nagano', 'Gifu',
      'Shizuoka', 'Aichi', 'Mie', 'Shiga', 'Kyoto', 'Osaka', 'Hyogo', 'Nara',
      'Wakayama', 'Tottori', 'Shimane', 'Okayama', 'Hiroshima', 'Yamaguchi',
      'Tokushima', 'Kagawa', 'Ehime', 'Kochi', 'Fukuoka', 'Saga', 'Nagasaki',
      'Kumamoto', 'Oita', 'Miyazaki', 'Kagoshima', 'Okinawa'
    ],
  ),
  GeographyEntry(
    name: 'South Korea',
    code: 'KR',
    districts: [
      'Seoul', 'Busan', 'Daegu', 'Incheon', 'Gwangju', 'Daejeon', 'Ulsan', 'Sejong',
      'Gyeonggi', 'Gangwon', 'North Chungcheong', 'South Chungcheong', 'North Jeolla',
      'South Jeolla', 'North Gyeongsang', 'South Gyeongsang', 'Jeju'
    ],
  ),
  GeographyEntry(
    name: 'China',
    code: 'CN',
    districts: [
      'Anhui', 'Beijing', 'Chongqing', 'Fujian', 'Gansu', 'Guangdong', 'Guangxi',
      'Guizhou', 'Hainan', 'Hebei', 'Heilongjiang', 'Henan', 'Hubei', 'Hunan',
      'Inner Mongolia', 'Jiangsu', 'Jiangxi', 'Jilin', 'Liaoning', 'Ningxia',
      'Qinghai', 'Shaanxi', 'Shandong', 'Shanghai', 'Shanxi', 'Sichuan', 'Tianjin',
      'Tibet', 'Xinjiang', 'Yunnan', 'Zhejiang', 'Hong Kong', 'Macau'
    ],
  ),
  GeographyEntry(
    name: 'India',
    code: 'IN',
    districts: [
      'Andhra Pradesh', 'Arunachal Pradesh', 'Assam', 'Bihar', 'Chhattisgarh', 'Goa',
      'Gujarat', 'Haryana', 'Himachal Pradesh', 'Jharkhand', 'Karnataka', 'Kerala',
      'Madhya Pradesh', 'Maharashtra', 'Manipur', 'Meghalaya', 'Mizoram', 'Nagaland',
      'Odisha', 'Punjab', 'Rajasthan', 'Sikkim', 'Tamil Nadu', 'Telangana', 'Tripura',
      'Uttar Pradesh', 'Uttarakhand', 'West Bengal'
    ],
  ),
  GeographyEntry(
    name: 'Thailand',
    code: 'TH',
    districts: [
      'Bangkok', 'Central Thailand', 'Northern Thailand', 'Northeast Thailand', 'Southern Thailand'
    ],
  ),
  GeographyEntry(
    name: 'Vietnam',
    code: 'VN',
    districts: [
      'Hanoi', 'Ho Chi Minh City', 'Da Nang', 'Haiphong', 'Can Tho', 'Central Highlands',
      'Mekong Delta', 'North Central', 'North East', 'North West', 'Red River Delta',
      'South Central Coast', 'South East'
    ],
  ),
  GeographyEntry(
    name: 'Indonesia',
    code: 'ID',
    districts: [
      'Bali', 'Java', 'Kalimantan', 'Maluku Islands', 'New Guinea', 'Sulawesi', 'Sumatra', 'Lesser Sunda Islands'
    ],
  ),
  GeographyEntry(
    name: 'Philippines',
    code: 'PH',
    districts: ['Luzon', 'Visayas', 'Mindanao'],
  ),
  GeographyEntry(
    name: 'Australia',
    code: 'AU',
    districts: [
      'New South Wales', 'Victoria', 'Queensland', 'Western Australia',
      'South Australia', 'Tasmania', 'Northern Territory', 'Australian Capital Territory'
    ],
  ),
  GeographyEntry(
    name: 'New Zealand',
    code: 'NZ',
    districts: [
      'Auckland', 'Bay of Plenty', 'Canterbury', 'Gisborne', 'Hawke\'s Bay',
      'Manawatu-Wanganui', 'Marlborough', 'Nelson', 'Northland', 'Otago',
      'Southland', 'Taranaki', 'Tasman', 'Waikato', 'Wellington', 'West Coast'
    ],
  ),
  GeographyEntry(
    name: 'United Arab Emirates',
    code: 'AE',
    districts: [
      'Abu Dhabi', 'Dubai', 'Sharjah', 'Ajman', 'Umm Al Quwain', 'Ras Al Khaimah', 'Fujairah'
    ],
  ),
  GeographyEntry(
    name: 'Egypt',
    code: 'EG',
    districts: [
      'Cairo', 'Alexandria', 'Giza', 'Shubra el-Kheima', 'Port Said', 'Suez', 'Mansoura'
    ],
  ),
  GeographyEntry(
    name: 'Morocco',
    code: 'MA',
    districts: [
      'Casablanca-Settat', 'Rabat-Salé-Kénitra', 'Fès-Meknès', 'Tanger-Tétouan-Al Hoceïma',
      'Marrakech-Safi', 'Souss-Massa', 'Béni Mellal-Khénifra', 'Oriental', 'Draâ-Tafilalet',
      'Guelmim-Oued Noun', 'Laâyoune-Sakia El Hamra', 'Dakhla-Oued Ed-Dahab'
    ],
  ),
  GeographyEntry(
    name: 'South Africa',
    code: 'ZA',
    districts: [
      'Gauteng', 'KwaZulu-Natal', 'Western Cape', 'Eastern Cape', 'Limpopo',
      'Mpumalanga', 'North West', 'Free State', 'Northern Cape'
    ],
  ),
  GeographyEntry(
    name: 'Cape Verde',
    code: 'CV',
    districts: [
      'Boa Vista', 'Brava', 'Fogo', 'Maio', 'Sal', 'Santiago', 'Santo Antão',
      'São Nicolau', 'São Vicente'
    ],
  ),
  GeographyEntry(
    name: 'Angola',
    code: 'AO',
    districts: [
      'Bengo', 'Benguela', 'Bié', 'Cabinda', 'Cuando Cubango', 'Cuanza Norte',
      'Cuanza Sul', 'Cunene', 'Huambo', 'Huíla', 'Luanda', 'Lunda Norte',
      'Lunda Sul', 'Malanje', 'Moxico', 'Namibe', 'Uíge', 'Zaire'
    ],
  ),
  GeographyEntry(
    name: 'Mozambique',
    code: 'MZ',
    districts: [
      'Cabo Delgado', 'Gaza', 'Inhambane', 'Manica', 'Maputo', 'Maputo City',
      'Nampula', 'Niassa', 'Sofala', 'Tete', 'Zambezia'
    ],
  ),
];

GeographyEntry? geographyByName(String name) {
  for (final g in kGeography) {
    if (g.name == name) return g;
  }
  return null;
}

GeographyEntry? geographyByCode(String code) {
  for (final g in kGeography) {
    if (g.code == code) return g;
  }
  return null;
}

GeographyEntry? resolveGeography(String identifier) {
  return geographyByName(identifier) ?? geographyByCode(identifier);
}
