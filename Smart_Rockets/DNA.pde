class DNA {

      PVector genes[] = new PVector[lifeSpan];

      DNA() {

            for (int i = 0; i < lifeSpan; i++) {

                  genes[i] = PVector.random2D();
            }
      }
}
