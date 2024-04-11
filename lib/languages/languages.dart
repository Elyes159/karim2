class Language {
  final int id;
  final String name;
  final String languageCode;

  Language(this.id, this.name, this.languageCode);

  static List<Language> languageList() {
    return <Language>[
      Language(1, "francais", 'fr'),
      Language(1, "arabe", 'ar'),
      Language(1, "anglais", 'en'),
    ];
  }
}
