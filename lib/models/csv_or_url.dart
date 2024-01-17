sealed class CsvOrNull {}

class Csv extends CsvOrNull {
  Csv({required this.csv});

  final String csv;
}

class Url extends CsvOrNull {
  Url({required this.url});

  final String url;
}
