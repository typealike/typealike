import java.util.Arrays;
class Target {
  int x, y;   // Variables for location of raindrop
  float speed = taskSpeed;  // Speed of raindrop
  color c;
  float r;      // Radius of raindrop
  int cornerBezel = 10; // for drawing rectangle
  float br=150, bg=150, bb=150;
  final float w = 200; 
  final float h = 200;
  String label="", type="";
  PImage gestureIcon=null;
  Boolean isCaught=false, isMissed=false;
  String modifierkey="";
  int shortcutkeycode=0;
  List<String> blockWords = Arrays.asList("W", "H", "M", "J");
    Target(String type, String lbl) {
    this.type=type;
    r = 8;                   // All raindrops are the same size
    // Start with a random x location
    if (experimentId=="one" && this.type=="gesture") {
      x = width/2 - 100;
      y = height/2 - 200;
    } else if (this.type=="click") {
      x = (int) random(width-300);
      y = (int) random(height-200);
    } else {
      x = (int) random(width-30);
      y = -10;                // Start a little above the window
    }//speed = spd;    // Pick a random speed
    c = color(50, 100, 150); // Color
    if (this.type=="gesture") {
      gestureIcon = requestImage("images/"+lbl);
      label=lbl;
    } else if (this.type=="shortcut") {
      label = lbl;
      int index = (int)random(0, modifierkeys.length);
      modifierkey = modifierkeys[index];
      if (label.length()==2 && modifierkey=="Alt")
        modifierkey="Ctrl";
      else if (blockWords.contains(label))
        modifierkey="Alt";
      shortcutkeycode =  codes[Arrays.asList(shortcuts).indexOf(label)];
      if (label=="up" || label=="down" || label=="left" || label=="right")
        gestureIcon = requestImage("images/"+label+".png");
    } else {
      label = lbl;
    }
    //else type=="click"
    //background = sprite;
    //background.resize((int)w, (int)h);
  }

  // Move the raindrop down
  void move() {
    // Increment by speed
    if ((this.type!="gesture" || experimentId!="one") && this.type!="click") {
      y += speed;
    }
  }

  // Check if it hits the bottom
  boolean reachedBottom() {
    // If we go a little beyond the bottom
    if (y > height + r*4) { 
      return true;
    } else {
      return false;
    }
  }

  // Display the raindrop
  void display() {
    // Display the drop
    //fill(c);
    //noStroke();
    //for (int i = 2; i < r; i++ ) {
    //  ellipse(x, y + i*4, i*2, i*2);
    //}

    //rect(x, y, w, h, cornerBezel);
    //image(background,x,y);
    fill(0, 0, 0);
    if (this.type=="word") {
      if (x+350>width) {
        x=width-350;
      }
      for (int i=0; i<label.length(); i++) {
        fill(0, 0, 0);
        rect(x+(i*50), y, 50, 50, 10);
        textSize(40);
        fill(255, 255, 255);
        text(Character.toString(label.charAt(i)), x+10+(i*50), y, 300, 150);
      }
      //text(label,x,y,300,150);
    } else if (this.type=="gesture") {
      if (x+270>width) {
        x=width-300;
      }
      //image(gestureIcon,x,y,300,200);
      //image(gestureIcon,x,y,100,70);
      if (experimentId=="one" && this.type=="gesture")
        image(gestureIcon, x, y, 300, 200);
      else
        image(gestureIcon, x, y, 120, 80);
      fill(0, 0, 0);
      textSize(30);
      text("Form this posture on the keyboard for "+gestureTimer/1000+" seconds", x-200, y+300);
    } else if (this.type=="shortcut") {
      if (x+300>width) {
        x=width-300;
      }
      textSize(40);
      fill(0, 0, 0);
      rect(x, y, 110, 50, 10);

      if (label=="PgUp" || label=="PgDown")
        rect(x+(170), y, 120, 50, 10);
      else if (label!="up" && label!="down" && label!="left" && label!="right")
        rect(x+(170), y, 90, 50, 10);

      fill(255, 255, 255);
      text(modifierkey, x+10, y, 300, 150);
      if (label=="up" || label=="down" || label=="left" || label=="right")
        image(gestureIcon, x+150, y, 50, 50);
      else
        text(label, x+180, y, 300, 150);
    } else if (this.type=="equation") {
      if (x+350>width) {
        x=width-350;
      }
      textSize(30);
      text(label, x, y, 300, 150);
    } else if (this.type=="click") {
      if (x+350>width) {
        x=width-350;
      }
      fill(0, 0, 0);
      rect(x, y, w, h-30, cornerBezel);
      fill(255, 255, 255);
      textSize(20);
      text("Click Me", x+60, y+70, w, h);
    }
  }

  // If the drop is caught
  void caught() {
    hit.play();
    // Stop it from moving by setting speed equal to zero
    this.speed = 0;
    this.isCaught = true;
    // Set the location to somewhere way off-screen
    this.y = -1000;
    loghelper.logTargetEnd(this.label, this.type, "hit");
    // "#<time>,E,task,{type:end, action:<success>, targetType:<targetType>, num:<taskNum>, endReason:<caught, missed>, datetime:<time>, duration:<numSeconds>}",
  }
  // If the drop is caught
  void missed() {
    miss.play();
    // Stop it from moving by setting speed equal to zero
    this.speed = 0;
    this.isMissed = true;
    // Set the location to somewhere way off-screen
    this.y = -1000;
    loghelper.logTargetEnd(this.label, this.type, "miss");
  }
}
