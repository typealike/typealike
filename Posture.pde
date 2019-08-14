import java.lang.Math; 
class Posture{
  String hand, form, area, degree;
  int x, y, xMin, yMin, xMax, yMax;
  int surfaceX, surfaceY, surfaceW, surfaceH;
  int sw = width/2, sh=height/2;
  WiggleMode mode;
  PImage icon;
  
  Posture(String label){
    String [] labelIndex = split(label,"_");
    this.hand = labelIndex[0];
    this.form = labelIndex[1];
    this.degree = labelIndex[2];
    this.area = labelIndex[3];
    
    this.icon = iconSet.get(hand+"_"+form+"_"+degree);
    this.setPositionParameters();
    if (this.hand.equals("Left")){
      this.x = this.xMin;
      this.y = this.yMin;
      this.mode = WiggleMode.INC;
    }
    else if (this.hand.equals("Right")){
      this.x = this.xMax;
      this.y = this.yMax;
      this.mode = WiggleMode.DEC;
    }
  }
  public void wigglePose(int jitter){
    switch(this.area){
    case "On":
                  if (this.mode == WiggleMode.INC){
                    this.x+=jitter;
                    //this.y+=Math.sin(this.x);
                  }
                  else{
                    this.x-=jitter;
                    //this.y+=(Math.sin(this.x));
                  }
                  if (this.x+jitter == this.xMax)
                    this.mode = WiggleMode.DEC; 
                  else if (this.x+jitter == this.xMin)
                    this.mode = WiggleMode.INC; 
                    //Float b = ;
                   //text((float) Math.sin(2-this.x),200,200);
                  break;
    case "Below": 
                  if (this.mode == WiggleMode.INC)
                    this.x+=jitter;
                  else
                    this.x-=jitter;

                  if (this.x+jitter == this.xMax)
                    this.mode = WiggleMode.DEC; 
                  else if (this.x+jitter == this.xMin)
                    this.mode = WiggleMode.INC; 
                  break;
    case "Beside": 
                  if (this.mode == WiggleMode.INC)
                    this.y+=jitter;
                  else if (this.mode == WiggleMode.DEC)
                    this.y-=jitter;

                  if (this.y+jitter == this.yMax)
                    this.mode = WiggleMode.DEC; 
                  else if (this.y+jitter == this.yMin)
                    this.mode = WiggleMode.INC;
                  break;
    }
  }
  
  public void setPositionParameters(){
    
    if (this.hand.equals("Left") && this.form.equals("Close") && this.area.equals("On")){
      this.xMin = sw-210; this.yMin = sh-150;
      this.xMax = sw-170; this.yMax = sh-150;
      this.surfaceX = sw-220+70; this.surfaceY = sh-150+8;
      this.surfaceW = 150; this.surfaceH = 130;
    }
    else if (this.hand.equals("Left") && this.form.equals("Close") && this.area.equals("Below")){
      this.xMin = sw-250; this.yMin = sh-50;
      this.xMax = sw-170; this.yMax = sh-50;
      this.surfaceX = sw-250+60; this.surfaceY = sh-50+40;
      this.surfaceW = 180; this.surfaceH = 80;
    }
    else if (this.hand.equals("Left") && this.form.equals("Close") && this.area.equals("Beside")){
      this.xMin = sw-280; this.yMin = sh-200;
      this.xMax = sw-280; this.yMax = sh-150;
      this.surfaceX = sw-280+90; this.surfaceY = sh-150-10;
      this.surfaceW = 40; this.surfaceH = 150;
    }
    else if (this.hand.equals("Left") && this.form.equals("Open") && this.area.equals("On")){
      this.xMin = sw - 220; this.yMin = sh - 150;
      this.xMax = sw - 170; this.yMax = sh - 150;
      this.surfaceX = sw-220+70; this.surfaceY = sh-150+8;
      this.surfaceW = 150; this.surfaceH = 130;
    }
    else if (this.hand.equals("Left") && this.form.equals("Open") && this.area.equals("Below")){
      this.xMin = sw - 270; this.yMin = sh - 50;
      this.xMax = sw - 170; this.yMax = sh - 50;
      this.surfaceX = sw-250+60; this.surfaceY = sh-50+40;
      this.surfaceW = 180; this.surfaceH = 80;
    }
    else if (this.hand.equals("Left") && this.form.equals("Open") && this.area.equals("Beside")){
      this.xMin = sw - 280; this.yMin = sh - 180;
      this.xMax = sw - 280; this.yMax = sh - 150;
      this.surfaceX = sw - 280+90; this.surfaceY = sh-150-10;
      this.surfaceW = 40; this.surfaceH = 150;
    }
    else if (this.hand.equals("Right") && this.form.equals("Close") && this.area.equals("On")){
      this.xMin = sw - 60; this.yMin = sh - 150;
      this.xMax = sw - 10; this.yMax = sh - 150;
      this.surfaceX = sw-60+40; this.surfaceY = sh-150+8;
      this.surfaceW = 150; this.surfaceH = 130;
    }
    else if (this.hand.equals("Right") && this.form.equals("Close") && this.area.equals("Below")){
      this.xMin = sw - 50; this.yMin = sh - 50;
      this.xMax = sw + 30; this.yMax = sh - 50;
      this.surfaceX = sw-50+40; this.surfaceY = sh-50+40;
      this.surfaceW = 180; this.surfaceH = 80;
    }
    else if (this.hand.equals("Right") && this.form.equals("Close") && this.area.equals("Beside")){
      this.xMin = sw + 70; this.yMin = sh - 200;
      this.xMax = sw + 70; this.yMax = sh - 150;
      this.surfaceX = sw+70+60; this.surfaceY = sh-180+10;
      this.surfaceW = 40; this.surfaceH = 150;
    }
    else if (this.hand.equals("Right") && this.form.equals("Open") && this.area.equals("On")){
      this.xMin = sw - 60; this.yMin = sh - 150;
      this.xMax = sw + 10; this.yMax = sh - 150;
      this.surfaceX = sw-60+40; this.surfaceY = sh-150+8;
      this.surfaceW = 150; this.surfaceH = 130;
    }
    else if (this.hand.equals("Right") && this.form.equals("Open") && this.area.equals("Below")){
      this.xMin = sw - 50; this.yMin = sh - 50;
      this.xMax = sw + 50; this.yMax = sh - 50;
      this.surfaceX = sw-50+40; this.surfaceY = sh-50+40;
      this.surfaceW = 180; this.surfaceH = 80;
    }
    else if (this.hand.equals("Right") && this.form.equals("Open") && this.area.equals("Beside")){
      this.xMin = sw + 70; this.yMin = sh - 180;
      this.xMax = sw + 70; this.yMax = sh - 150;
      this.surfaceX = sw+70+60; this.surfaceY = sh-180+10;
      this.surfaceW = 40; this.surfaceH = 150;
    }
  }
}
