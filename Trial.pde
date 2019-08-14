import java.util.Arrays;

class Trial {
    int x, y;   // Variables for location of Object(text, button, posture)
    int meteorX, meteorY;   // Variables for location of Meteor
    
    Posture posture;   // Contain posture variables for location, form, hand, coordinates etc
    float speed = taskSpeed;  // Speed of Trial
    int jitter;
    Boolean flag=true;
    PImage picon;
    color c;
    float r;      // Radius of Trial
    int cornerBezel = 10; // for drawing rectangle
    float br=150, bg=150, bb=150;
    final float w = 200; 
    final float h = 200;
    String label="", type="";
    int trialStartTime;
    String labelIndex[];
    
    Boolean isCaught=false, isMissed=false;
    String modifierkey="";
    int shortcutkeycode=0;
    List<String> blockWords = Arrays.asList("left", "up", "right", "down", "J", "H", "M");
    Trial(String type, String lbl) {
      this.type=type;
      r = 8;                   // All raindrops are the same size
      // Start with a random x location
      trialStartTime = millis();
      if (this.type=="two_hand_posture") {
        x = width/2 - 250;
        y = height/2 - 200;
        meteorX = x+250;
        String [] labelIndex = split(lbl,"_");
        String hand, form, degree, area;
        print(lbl);
        hand = labelIndex[0];
        form = labelIndex[1];
        degree = labelIndex[2];
        area = labelIndex[3];
        
        this.picon = iconSet.get(hand+"_"+form+"_"+degree+"_"+area);
      }
      else if (this.type=="posture") {
        x = width/2 - 250;
        y = height/2 - 200;
        meteorX = x+250;
        
        posture = new Posture(lbl);
        
        // true initialization can only happen here. coz we ahve different position parameters for LOC, HAND, FORM
        //postureIcon = posture.icon;
        //postureX = posture.x;
        //postureY = posture.y;
      } else if (this.type=="click") {
        x = (int) random(width-300);
        y = (int) random(100,height-200);
        meteorX = x+100;
      } else {
        x = (int) random(width-300);
        y = (int) random(100,height-200);
        meteorX = x+130;
        //x = (int) random(width-30);
        //y = -10;                // Start a little above the window
      }
      //meteorX = (int) random(width-300);
      
      meteorY = -10;
      this.jitter = 2;
      c = color(50, 100, 150); // Color
      this.label = lbl;
      if (this.type=="shortcut") {
        label = lbl;
        int index = (int)random(0, modifierkeys.length);
        modifierkey = modifierkeys[index];
        if (label.length()==2 && modifierkey=="Ctrl")
          modifierkey="Shift";
        else if (blockWords.contains(label))
          modifierkey="Shift";
          //print(label);
        shortcutkeycode =  codes[Arrays.asList(shortcuts).indexOf(label)];
      }
  }

  // Move the raindrop down
  void move() {
    // Increment by speed
    //if ((this.type!="posture" || experimentId!="one") && this.type!="click") {
    //  y += speed;
    //}
    
    this.meteorY = int((millis()-this.trialStartTime)*0.18);
    //this.meteorY+=speed;
    
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
      //circle(100,100,10);
      //circle(150,200,10);
      //circle(200,300,10);
      //text(height, 200, 200);
    fill(255,0,0);
    circle(this.meteorX, this.meteorY, 50);
    if(millis()-this.trialStartTime > 2000){
      //if(meteorY < 200){
      //  speed += 2;
      //  this.jitter = 5;
      //}
      //if(meteorY < 300){
      //  speed += 1;
      //}
      if(meteorY < 100)
        this.jitter = 10;
      else if(meteorY < 200)
        this.jitter = 5;

      //if(meteorY < 100 && flag){
      //  speed = 20;
      //  this.jitter = 5;
      //}
      //else if(meteorY < 200 && flag)
      //  speed = 15;
      //else if(meteorY < 300 && flag)
      //  speed = 10;
      //flag=false;
      // if(meteorY > 100 && meteorY < 200)
      //   speed = 15;
      // else if(meteorY > 200 && meteorY < 300)
      //   speed = 10;
      // else if(meteorY < 100){
      //   speed = 20;
      //   this.jitter = 5;
      //}
      if (this.type=="posture") {
        posture.wigglePose(jitter);
        textSize(30);
        fill(0,0,0);
        text("Slightly wiggle your hand while maintaining the posture", x-150, y+400);
      }
    }
    if (this.type=="two_hand_posture"){
      if (x+270>width)
        x=width-300;
      //else{
      //  fill(0, 0, 0);
      //  textSize(30);
      //  text("Form this posture on the keyboard for "+postureTimer/1000+" seconds", x-200, y+400);
      //}
      image(this.picon, this.x, this.y, 480, 360);
    }
    else if (this.type=="word") {
      if (x+350>width)
        x=width-350;
      for (int i=0; i<label.length(); i++) {
        fill(0, 0, 0);
        rect(x+(i*50), y, 50, 50, 10);
        textSize(40);
        fill(255, 255, 255);
        text(Character.toString(label.charAt(i)), x+10+(i*50), y, 300, 150);
      }
      //text(label,x,y,300,150);
    } else if (this.type=="posture") {
      if (x+270>width)
        x=width-300;

      //image(keyboardBase,x,y,300,200);
      //image(keyboardBase,x,y,100,70);
      //if (this.type=="posture")
      image(iconSet.get("keyboardBase"), x, y, 480, 360);
      //tint(255, 127);  // reduce opacity  
      //noFill();
      
      //else{
      //  fill(0, 0, 0);
      //  textSize(30);
      //  text("Form this posture on the keyboard for "+postureTimer/1000+" seconds", x-200, y+400);
      //}
      fill(0,255,0, 40);
      rect(posture.surfaceX,posture.surfaceY,posture.surfaceW,posture.surfaceH,10);
      tint(255, 240);  // reduce opacity
      image(posture.icon, posture.x, posture.y, 200, 200);
      
      //tint(255); //bring back full opacity
      
      //text(this.label, x-200, y+400);
        //text(posture.xMin, x-200, y+400);
    } else if (this.type=="shortcut") {
      if (x+300>width) {
        x=width-300;
      }      
      //fill(255, 255, 255);
      //text(modifierkey, x+10, y, 300, 150);
      
      fill(0, 0, 0);
      //rect(x, y, 110, 50, 10);

      if (label!="up" && label!="down" && label!="left" && label!="right")
        rect(x+(170), y, 100, 70, 10);
      
      textSize(20);
      //fill(255, 255, 255);
      //text(modifierkey, x+10, y, 300, 150);
      
       if (modifierkey == "Shift"){
        rect(x, y, 100, 70, 10);
        fill(255, 255, 255);
        text("Shift", x+10, y+40, 300, 150);

      }
      else if (modifierkey == "Option"){
        rect(x, y, 100, 70, 10);
        fill(255, 255, 255);
        text("option", x+20, y+40, 300, 150);
        textSize(15);
        text("alt", x+60, y+5, 300, 150);
        
      }
      else if (modifierkey == "Ctrl"){
        rect(x, y, 100, 70, 10);
        fill(255, 255, 255);
        text("control", x+15, y+40, 300, 150);
      }

      textSize(30);
      if (label=="up" || label=="down" || label=="left" || label=="right")
        image(iconSet.get(label+"_"+"key"), x+200, y, 50, 50);
      else
        text(label, x+210, y+20, 300, 150);
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
    //image(iconSet.get("meteor"), this.meteorX, this.meteorY, 100, 100);
    //fill(14, 170, 14);
  }

  // If the drop is caught
  void caught() {
    hit.play();
    // Stop it from moving by setting speed equal to zero
    this.speed = 0;
    this.isCaught = true;
    // Set the location to somewhere way off-screen
    this.y = height+10;
    loghelper.logTrialEnd(this.label, this.type, "hit");
    // "#<time>,E,task,{type:end, action:<success>, targetType:<targetType>, num:<taskNum>, endReason:<caught, missed>, datetime:<time>, duration:<numSeconds>}",
  }
  // If the drop is caught
  void missed() {
    miss.play();
    // Stop it from moving by setting speed equal to zero
    this.speed = 0;
    this.isMissed = true;
    // Set the location to somewhere way off-screen
    this.y = height+10;
    loghelper.logTrialEnd(this.label, this.type, "miss");
  }
}
