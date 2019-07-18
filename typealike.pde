import processing.net.*; //<>// //<>//
import java.util.List;
import java.util.ListIterator;
import processing.video.*;
import com.hamoid.*;
import processing.sound.*;

void setup() {
   //movie = new Movie (this,"hit.mp3");
  hit = new SoundFile(this,"hit.aiff");
  miss = new SoundFile(this,"miss.aiff");
  
  iconSet.put("grass",requestImage("images/grass.png"));
  iconSet.put("keyboardBase",requestImage("images/keyboardBase.png"));
  iconSet.put("meteor",requestImage("images/meteor.png"));
  iconSet.put("left_key",requestImage("images/left.png"));
  iconSet.put("right_key",requestImage("images/right.png"));
  iconSet.put("up_key",requestImage("images/up.png"));
  iconSet.put("down_key",requestImage("images/down.png"));
  iconSet.put("Left_Close_90",requestImage("images/Left_Close_90.png"));
  iconSet.put("Right_Close_90",requestImage("images/Right_Close_90.png"));
  iconSet.put("Left_Open_90",requestImage("images/Left_Open_90.png"));
  iconSet.put("Right_Open_90",requestImage("images/Right_Open_90.png"));
  iconSet.put("Left_Close_0",requestImage("images/Left_Close_0.png"));
  iconSet.put("Right_Close_0",requestImage("images/Right_Close_0.png"));
  iconSet.put("Left_Open_0",requestImage("images/Left_Open_0.png"));
  iconSet.put("Right_Open_0",requestImage("images/Right_Open_0.png"));
  iconSet.put("Left_Open_180",requestImage("images/Left_Open_180.png"));
  iconSet.put("Right_Open_180",requestImage("images/Right_Open_180.png"));
  iconSet.put("Left_Close_180",requestImage("images/Left_Close_180.png"));
  iconSet.put("Right_Close_180",requestImage("images/Right_Close_180.png"));

  loghelper = new LogHelper();
  
  logger = new Logger(participantId, new GameEventWriter());
  logger.enableLogging();
  loghelper.logExperimentStart();

  taskOrders = (modeId=="practice")?practiceOrder:experimentOrder;
  numBlocks = taskOrders.length;
  numSequences = taskOrders[0].length;
  numTrials = taskOrders[0][0].length;

  frameRate(30);
  fullScreen();
  if(experimentId=="one"){
    //cam = new Capture(this, 800, 600);
    //cam.start();
    //String filename = String.format("%s_%s_%s", participantId, modeId, startTime);
    //videoExport = new VideoExport(this, "videos/one/"+filename+".mp4", cam);
    //videoExport.setFrameRate(30); 
    //videoExport.setQuality(30,0);
    //videoExport.startMovie();
    //thread = new CaptureFrame(this);
    //thread.start();
    recordVideo = true;
    //myServer = new Server(this, 5204);
    myClient = new Client(this, "127.0.0.1", 25000);
  }
  else if(experimentId=="two"){
    println("connected");
    myClient = new Client(this, "127.0.0.1", 25000);
  }
  //modeId = "practice";
  //size(1400, 880);
  app=new App();
}

void captureEvent(Capture video) {
  if(experimentId=="one"){
    video.read();
  }
}

void draw() {

  background(255);

    if(!taskStarted){
      drawExperimentMenu();
    }
    else{
      if (recordVideo && experimentId=="one" && !gameoverflag){
        if(verbose)
          loghelper.VideoFrameEvent();
        //videoExport.saveFrame();
        //thread.de_que.addFirst(10);
        //myServer.write("capture");
        myClient.write("capture");
      }
      app.game.draw();    
    }

}

void drawExperimentMenu(){
    textSize(30);
    fill(0,0,0);
    rect(width/2-100, height/2-200, 250, 80,5);
    //rect(width/2-100, height/2-100, 250, 80,5);
    //rect(width/2-100, height/2, 200, 80,5);
    //rect(width/2-100, height/2+100, 200, 80,5);
    text("Experiment: "+experimentId,width/2-120,height/2-250);
    fill(255,255,255);
    text("Start",width/2-80,height/2-150);
    //text("Experiment",width/2-80,height/2-50);
    //text("Task 2",width/2-50,height/2+50);
    //text("Task 3",width/2-50,height/2+150);
}  


void mouseMoved(){
  if(experimentId!="" && modeId!="")
    logger.doLog(new MouseInputEvent("moved",mouseX,mouseY));
}

void mousePressed(){
  if(experimentId!="" && modeId!="")
    logger.doLog(new MouseInputEvent("mousepressed",mouseX,mouseY));
}

void mouseReleased() {

if(!taskStarted){
    if (mouseX >= width/2-100 && mouseX <= width/2+150 && 
        mouseY >= height/2-200 && mouseY <= height/2-120) {
          app.game.addSequence();
          taskStarted=true;
          //thread.start();
          myClient.write("start");
        }
    else if (mouseX >= width/2-100 && mouseX <= width/2+150 && 
        mouseY >= height/2-100 && mouseY <= height/2-20){
          modeId="experiment";
          taskOrders = experimentOrder;
          numBlocks = taskOrders.length;
          numSequences = taskOrders[0].length;
          numTrials = taskOrders[0][0].length;
        }
    //else if (mouseX >= width/2-100 && mouseX <= width/2+100 && 
    //    mouseY >= height/2 && mouseY <= height/2+80){
    //      modeId="two";
    //    }
    //else if (mouseX >= width/2-100 && mouseX <= width/2+100 && 
    //    mouseY >= height/2+100 && mouseY <= height/2+180){
    //      modeId="three";
    //    }
    // Initialize corresponding set
    //app.game.addSequence();
  }
  else{

      if (app.game.sequence.trial.type=="click")
        if (mouseX >= app.game.sequence.trial.x && mouseX <= app.game.sequence.trial.x+app.game.sequence.trial.w && 
          mouseY >= app.game.sequence.trial.y && mouseY <= app.game.sequence.trial.y+app.game.sequence.trial.h) {
          //return true;
          logger.doLog(new MouseInputEvent("mousereleased",mouseX,mouseY));
          app.game.sequence.trial.caught();  //return false;
          //app.game.sequence.trial = null;
          //itr.remove();
        }

  }
  //if (mouseX > width-100 && mouseY> height-100) {
  //  saveVideo();
  //}
}

void keyPressed(KeyEvent ev) {
  //String label = String.valueOf(key);
  char k = key;
  
  if (key == ESC){
      key = '\n';
  }
  
  // Press space to continue
  if(k == 32 && app.game.gameStopped){
    app.game.gameStopped=false;
    loghelper.logBlockStart(app.game.currentBlock);
    app.game.addSequence();
   }
  //list = app.game.sets[app{.game.currentBlock];
  if (k == BACKSPACE)  wordBeingTyped = wordBeingTyped.substring(0, max(0, wordBeingTyped.length()-1));
  //else if (wordBeingTyped.length() >= lim)  return;
  else if (k == ENTER || k == RETURN) {
    // this ends the entering 
    //println(wordBeingTyped);
    //state  = stateNormal; // close input box
    if(app.game.currentSequence == numSequences)
      return;

      if (wordBeingTyped.equals(app.game.sequence.trial.label) && !app.game.sequence.trial.isCaught) {
        app.game.sequence.trial.caught();
        //app.game.sequence.trial = null;
        //itr.remove();
        //itr.remove();

      }

    wordBeingTyped="";
  } else if(experimentId!="" && modeId!=""){
    //if (keyCode != 16 && keyCode != 17 && keyCode != 18) {
    if(ev.isShiftDown() || ev.isControlDown() || ev.isAltDown()){
      //println(app.game.currentSequence);

        if (app.game.sequence.trial.modifierkey != "" && !app.game.sequence.trial.isCaught ) {
          if(app.game.sequence.trial.shortcutkeycode==keyCode && ((app.game.sequence.trial.modifierkey=="Ctrl" && ev.isControlDown()) || (app.game.sequence.trial.modifierkey=="Shift" && ev.isShiftDown()) || (app.game.sequence.trial.modifierkey=="Option" && ev.isAltDown()))){
            logger.doLog(new KeyboardInputEvent("keypressed",Integer.toString(keyCode),app.game.sequence.trial.modifierkey));
            app.game.sequence.trial.caught();
            //app.game.sequence.trial = null;
            //itr.remove();
          }
          //break;
        }

    }
    //println(keyCode);
    if (keyCode != 32 && keyCode != 16 && keyCode != 17 && keyCode != 18 && (keyCode < 112 || keyCode > 123) && (keyCode < 33|| keyCode > 40 ) && !ev.isControlDown() && !ev.isAltDown()){
        if(ev.isShiftDown())
          logger.doLog(new KeyboardInputEvent("keypressed",Integer.toString(keyCode),"Shift"));
        else
          logger.doLog(new KeyboardInputEvent("keypressed",Integer.toString(keyCode),"none"));
        wordBeingTyped+=String.valueOf(key);
    }
  }
  //print(key);
}

void keyReleased(){
  if(experimentId!="" && modeId!="")
    logger.doLog(new KeyboardInputEvent("keyreleased", Integer.toString(keyCode),"none"));
}

/*
Stops game in middle
*/
void exit() {
  loghelper.logExperimentEnd();
  if(experimentId=="one"){
    println(experimentId);
    println(modeId);
    println("VIDEO ENDED");
    //if (modeId=="experiment")
    //myServer.write("complete");
    myClient.write("complete");
    //thread.complete = true;
    //videoExport.endMovie();
    recordVideo = false;
  }
  if(cam!=null){
    println("stopping camera");
    cam.stop();
  }
  else
    println("NOT stopping camera");
  super.exit();
}
