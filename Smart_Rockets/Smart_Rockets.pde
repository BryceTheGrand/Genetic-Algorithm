int popSize = 2500;
Rocket population[] = new Rocket[popSize];
int lifeSpan = 400;
float mutationRate = 0.03;
ArrayList<Rocket> matingPool = new ArrayList<Rocket>();

float time = 0;
PVector target;
float targetRad = 40;
float maxFit = 0;
int generation = 0;
float framerate = 60;

PShape rocket = new PShape();
PShape smartRocket = new PShape();


boolean hide = false;

ArrayList<Obstacle> obstacles = new ArrayList<Obstacle>();

String info = new String();


void setup() {
      size(800, 800, P3D);
      for (int i = 0; i < popSize; i++) {
            population[i] = new Rocket();
      }
      target = new PVector(width / 2, height / 4);
      noStroke();
      fill(255, 150);
      frameRate(framerate);
      time = 0;
      generation = 0;
      maxFit = 0;

      rocket = createShape();
      rocket.beginShape();
      rocket.fill(255, 150);
      rocket.vertex(-5, 3);
      rocket.vertex(-5, -3);
      rocket.vertex(10, 0);
      rocket.endShape(CLOSE);
      
      smartRocket = createShape();
      smartRocket.beginShape();
      smartRocket.fill(100, 0, 255, 150);
      smartRocket.vertex(-5, 3);
      smartRocket.vertex(-5, -3);
      smartRocket.vertex(10, 0);
      smartRocket.endShape(CLOSE);
      
      info = "Genetic Smart Rocket Program\nKeybindings:\n'c': Clear obstacles\n'n': New population (restart from random)\n'h': Hide all but most fit rocket\nUP/DOWN key: Increase/Decrease sim speed\n\nClick and drag to create obstacles (must drag from top-left to bottom-right)";
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
      stats += "Maximum fitness: " + maxFit + "\nGeneration: " + generation + "\nPopulation: " + popSize + "\nLifetime: " + time + "\nHide: " + hide + "\nObstacles: " + obstacles.size() + "\nFramerate: " + framerate;

      text(stats, 5, 15);
      text(info, 5, height - 105);
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
      if (key == 'c') {

            for (int i = 0; i < obstacles.size(); i++) {

                  obstacles.remove(i);
                  i--;
            }
      }
      if (key == 'h') {

            if (hide) {
                  hide = false;
            } else {

                  hide = true;
            }
      }
      if (keyCode == UP) {
            framerate += 10;
            frameRate(framerate);
      }
      if (keyCode == DOWN) {
            framerate -= 10;
            frameRate(framerate);
      }
}
