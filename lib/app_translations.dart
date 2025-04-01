import 'package:get/get.dart';

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    'en_US': {
      'new_game': 'New Game',
      'loading_version': 'Loading version...',
      'error_version': 'Error loading version',
      'version': 'Version @version',
    },
    'pl_PL': {
      'new_game': 'Nowa Gra',
      'loading_version': 'Wersja ładuje się...',
      'error_version': 'Błąd pobierania wersji',
      'version': 'Wersja @version',
    },
  };
}
