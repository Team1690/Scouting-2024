sealed class CsvOrUrl {}

class Csv extends CsvOrUrl {
  Csv({required this.csv});

  final String csv;
}

class Url extends CsvOrUrl {
  Url({required this.url});

  final String url;
}
