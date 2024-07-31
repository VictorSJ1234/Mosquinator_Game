// Importing the required classes and packages
import 'package:mosquinator_0/components/enemy2.dart';
import 'package:mosquinator_0/game_controller.dart';

// A class to spawn and manage enemies
class EnemySpawner2 {

  // The game controller instance
  final GameController gameController;

  // The maximum and minimum spawn interval for enemies
  final int maxSpawnInterval = 10000;
  final int minSpawnInterval = 1000;

  // The change in spawn interval after each spawn
  final int intervalChange = 3;

  // The maximum number of enemies that can exist on the screen at a time
  final int maxEnemies = 5;

  // The current spawn interval and time for the next spawn
  int currentInterval = 0;
  int nextSpawn = 0;

  // Constructor to initialize the class
  EnemySpawner2(this.gameController) {
    initialize();
  }

  // Initializes the class by killing all enemies and setting the initial spawn interval and time for the next spawn
  void initialize() {
    killAllEnemies();
    currentInterval = maxSpawnInterval;
    nextSpawn = DateTime.now().millisecondsSinceEpoch + currentInterval;
  }

  // Method to kill all the enemies
  void killAllEnemies() {
    // If the enemies list is not null, loop through all enemies and set their isDead flag to true
    gameController.enemies2?.forEach((Enemy2 enemy2) => enemy2.isDead = true);
  }

  // The update method which is called every frame to update the state of the enemy spawner
  void update(double t) {
    // Get the current time in milliseconds
    int now = DateTime.now().millisecondsSinceEpoch;

    // If there are less than the maximum number of enemies on the screen and it's time for the next spawn
    if (gameController.enemies2!.length < maxEnemies && now >= nextSpawn) {
      // Spawn a new enemy
      gameController.spawnEnemy2();

      // Decrease the current spawn interval
      if (currentInterval > minSpawnInterval) {
        currentInterval -= intervalChange;
        currentInterval -= (currentInterval * 0.1).toInt();
      }

      // Set the time for the next spawn
      nextSpawn = now + currentInterval;
    }
  }

}
