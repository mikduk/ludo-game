import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/game_page_controller.dart';

class StatisticsDialog extends StatelessWidget {
  const StatisticsDialog({super.key, required this.gameController});
  final GamePageController gameController;

  @override
  Widget build(BuildContext context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Container(
          width: Get.width * 0.8,
          height: Get.height * 0.7,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(
                'Statystyki',
                style: Get.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 2),
              Text('Liczba tur: ${gameController.turnsCounter}'),
              const SizedBox(height: 10),
// Lista / tablica z danymi dla każdego gracza
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: List.generate(4, (i) {
                      return _buildPlayerStatsCard(i);
                    }),
                  ),
                ),
              ),
              const SizedBox(height: 16),
// Przycisk "Nowa gra"
              ElevatedButton.icon(
                icon: const Icon(Icons.refresh),
                label: const Text('Nowa gra'),
                onPressed: () {
                  gameController.initializeBoard();
                  gameController.executePeriodicallyBots();
                  Get.back();
                },
              ),
            ],
          ),
        ),
      );

  Widget _buildPlayerStatsCard(int playerIndex) {
    final colorName = gameController.colors[playerIndex];
    final kills = gameController.statisticKills[playerIndex];
    final deaths = gameController.statisticDeaths[playerIndex];
    final tripleSix = gameController.statisticTrippleSix[playerIndex];
    final rolls = gameController.statisticRolls[playerIndex];
    final moves = gameController.statisticMoves[playerIndex];

    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Gracz: $colorName',
                style: Get.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                )),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.check_circle_outline, color: Colors.green),
                const SizedBox(width: 4),
                Text('Zbił pionki: $kills'),
              ],
            ),
            Row(
              children: [
                const Icon(Icons.cancel_outlined, color: Colors.redAccent),
                const SizedBox(width: 4),
                Text('Został zbity: $deaths'),
              ],
            ),
            Row(
              children: [
                const Icon(Icons.star_rate_rounded, color: Colors.orange),
                const SizedBox(width: 4),
                Text('Potrójna szóstka: $tripleSix'),
              ],
            ),
            const SizedBox(height: 8),

            // Tabela rzutów 1-6
            Text(
              'Rzuty i ruchy:',
              style: Get.textTheme.bodyMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            // Można użyć np. DataTable, tutaj dla przykładu prosty Column
            Column(
              children: List.generate(6, (j) {
                return Text(
                  'Wynik: ${j + 1}  |  '
                  'ile razy wyrzucono: ${rolls[j]}  |  ruchy: ${moves[j]}',
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
