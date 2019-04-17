int popSize = 1000;
Rocket population[] = new Rocket[popSize];
int lifeSpan = 250;
float mutationRate = 0.02;
ArrayList<Rocket> matingPool = new ArrayList<Rocket>();

float time = 0;
PVector target;
float targetRad = 40;
float maxFit = 0;
int generation = 0;

ArrayList<Obstacle> obstacles = new ArrayList<Obstacle>();


void setup() {
      size(800, 800, P3D);
      for (int i = 0; i < popSize; i++) {
            population[i] = new Rocket();
      }
      target = new PVector(width / 2, height / 4);
      noStroke();
      fill(255, 150);
      frameRate(60);
      time = 0;
      generation = 0;
      maxFit = 0;
}


void draw() {
      background(0);
      fill(255, 0, 0, 255);
      circle(target.x, target.y, targetRad);
      fill(255, 255);
      circle(target.x, target.y, (float)2 * targetRad / 3);
      fill(255, 0, 0, 255);
      circle(target.x, target.y, (float) targetRad / 3);
      fill(255, 150);

      for (int i = 0; i < obstacles.size(); i++) {

            obstacles.get(i).drawBox();
      }
      time++;
      if (time < lifeSpan - 1) {
            for (int i = 0; i < popSize; i++) {

                  population[i].update();
                  if (population[i].fitness > maxFit) maxFit = population[i].fitness;
            }
      } else {
            Rocket newPop[] = new Rocket[popSize];
            matingPool = new ArrayList<Rocket>();
            for (int i = 0; i < popSize; i++) {

                  for (int j = 0; j < floor(map(population[i].fitness, 0, maxFit, 0, 4)); j++) {

                        matingPool.add(population[i]);
                  }
            }

            if (matingPool.size() > 0)

                  for (int i = 0; i < popSize; i++) {
                        Rocket parentA = matingPool.get(floor(random(matingPool.size())));
                        Rocket parentB = matingPool.get(floor(random(matingPool.size())));
                        newPop[i] = parentA.breed(parentB);
                  } else {
                  for (int i = 0; i < popSize; i++) {
                        newPop[i] = new Rocket();
                  }
            }

            population = newPop;
            time = 0;
            generation++;
            maxFit = 0;
      }

      String stats = "";
      stats += "Maximum fitness: " + maxFit + "\nGeneration: " + generation + "\nPopulation: " + popSize + "\nLifetime: " + time;

      text(stats, width - 200, height - 100);
}


float distance(float x1, float y1, float x2, float y2) {

      float deltX = x2 - x1;
      float deltY = y2 - y1;
      float d = sqrt(deltX * deltX + deltY * deltY);

      return d;
}


void mousePressed() {

      obstacles.add(new Obstacle());
}


void mouseReleased() {

      obstacles.get(obstacles.size() - 1).drawing = false;
}


void keyPressed() {
  
 if (key == 'n') {
   
  setup();
   
 }
  
}
