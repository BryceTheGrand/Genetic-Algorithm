import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class Smart_Rockets extends PApplet {

int popSize = 2500;
Rocket population[] = new Rocket[popSize];
int lifeSpan = 400;
float mutationRate = 0.03f;
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


public void setup() {
      
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


public void draw() {
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


public float distance(float x1, float y1, float x2, float y2) {

      float deltX = x2 - x1;
      float deltY = y2 - y1;
      float d = sqrt(deltX * deltX + deltY * deltY);

      return d;
}


public void mousePressed() {

      obstacles.add(new Obstacle());
}


public void mouseReleased() {

      obstacles.get(obstacles.size() - 1).drawing = false;
}


public void keyPressed() {

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
class DNA {

      PVector genes[] = new PVector[lifeSpan];

      DNA() {

            for (int i = 0; i < lifeSpan; i++) {

                  genes[i] = PVector.random2D();
            }
      }
}
class Obstacle {

      PVector pos1 = new PVector();
      PVector pos2 = new PVector();
      boolean drawing;

      Obstacle() {

            pos1.set(mouseX, mouseY);
            drawing = true;
      }


      public void drawBox() {

            if (drawing) {
                  pos2.set(mouseX, mouseY);
            }
            rectMode(CORNERS);
            fill(255, 255);
            rect(pos1.x, pos1.y, pos2.x, pos2.y);
            fill(255, 150);
      }
}
class Rocket {

      PVector pos = new PVector(width / 2, height - 10);
      PVector vel = new PVector(0, 0);
      PVector acc = new PVector(0, 0);
      DNA dna = new DNA();
      float fitness = 0;
      boolean finished = false;
      boolean dead = false;

      Rocket() {

            update();
      }


      public void update() {

            if (!finished && !dead) {
                  acc.set(dna.genes[floor(time)]);
                  vel.add(acc);
                  vel.limit(5);
                  pos.add(vel);    




                  if (time > 0) {
                        calcFitness();
                        checkColl();
                  }
            }

            push();

            translate(pos.x, pos.y);
            if (fitness >= maxFit) {
                  noFill();
                  stroke(255);
                  circle(0, 0, 30);
                  rotate(vel.heading());
                  shape(smartRocket, 0, 0);
            } else {
                  if (!hide) {
                        rotate(vel.heading());

                        shape(rocket, 0, 0);
                  }
            }

            pop();
      }


      public void calcFitness() {

            fitness = 300 / (distance(pos.x, pos.y, target.x, target.y) + (time / 6));
      }


      public void checkColl() {

            if (distance(pos.x, pos.y, target.x, target.y) < targetRad / 2) {

                  fitness *= 3;
                  finished = true;
            }

            if (pos.x < 0 || pos.x > width || pos.y > height || pos.y < 0) {

                  dead = true;
            }

            for (int i = 0; i < obstacles.size(); i++) {

                  if (pos.x < obstacles.get(i).pos2.x && pos.x > obstacles.get(i).pos1.x && pos.y < obstacles.get(i).pos2.y && pos.y > obstacles.get(i).pos1.y) {
                        dead = true;
                        fitness /= 1.25f;
                  }
            }
      }


      public Rocket breed(Rocket partner) {

            Rocket Child = new Rocket();

            int midpoint = floor(random(0, lifeSpan));

            for (int i = 0; i < lifeSpan; i++) {

                  if (random(1) < mutationRate) Child.dna.genes[i] = PVector.random2D();
                  else {
                        if (i < midpoint) Child.dna.genes[i] = dna.genes[i];
                        else Child.dna.genes[i] = partner.dna.genes[i];
                  }
            }

            return Child;
      }
}

      public void settings() {  size(800, 800, P3D); }
      static public void main(String[] passedArgs) {
            String[] appletArgs = new String[] { "Smart_Rockets" };
            if (passedArgs != null) {
              PApplet.main(concat(appletArgs, passedArgs));
            } else {
              PApplet.main(appletArgs);
            }
      }
}
