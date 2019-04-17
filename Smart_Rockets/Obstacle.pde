class Obstacle {

      PVector pos1 = new PVector();
      PVector pos2 = new PVector();
      boolean drawing;

      Obstacle() {

            pos1.set(mouseX, mouseY);
            drawing = true;
      }


      void drawBox() {

            if (drawing) {
                  pos2.set(mouseX, mouseY);
            }
            rectMode(CORNERS);
            fill(200, 0, 0, 255);
            rect(pos1.x, pos1.y, pos2.x, pos2.y);
            fill(255, 150);
      }
}
