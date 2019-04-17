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


      void update() {

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
                  fill(200, 0, 255, 255);
                  noStroke();
            } else
                  fill(200, 150);
            rotate(vel.heading());
            stroke(0, 100);
            rectMode(CENTER);
            rect(0, 0, 15, 5);

            pop();
      }


      void calcFitness() {

            fitness = 300 / (distance(pos.x, pos.y, target.x, target.y) + (time / 6));
      }


      void checkColl() {

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
                        fitness /= 1.25;
                  }
            }
      }


      Rocket breed(Rocket partner) {

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
