import 'package:get/get.dart';

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    'en_US': {
      'new_game': 'New Game',
      'continue_game': 'Continue Game',
      'loading_version': 'Loading version...',
      'error_version': 'Error loading version',
      'version': 'Version @version',
      'logs': 'Logs',
      'share': 'Share',
      'close': 'Close',
      'current_player': 'Current player:',
      'next_player': 'Next player:',
    },
    'pl_PL': {
      'new_game': 'Nowa Gra',
      'continue_game': 'Wczytaj Grę',
      'loading_version': 'Wersja ładuje się...',
      'error_version': 'Błąd pobierania wersji',
      'version': 'Wersja @version',
      'logs': 'Logi',
      'share': 'Udostępnij',
      'close': 'Zamknij',
      'current_player': 'Aktualny gracz:',
      'next_player': 'Następny gracz:',
    },
  };
}
