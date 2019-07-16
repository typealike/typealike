import processing.net.*;
import java.util.List;
import java.util.ListIterator;
import processing.video.*;
import com.hamoid.*;
import processing.sound.*;

VideoExport videoExport;
Capture cam;
SoundFile hit,miss;
PImage grass;
Client myClient; 
LogHelper loghelper;
String wordBeingTyped="";
Boolean recordVideo=false;
Boolean taskStarted=false; //<>// //<>//

App app;
String experimentStartTime, experimentEndTime, blockStartTime, blockEndTime, setStartTime, setEndTime, targetStartTime, targetEndTime;
void setup() {
   //movie = new Movie (this,"hit.mp3");
  hit = new SoundFile(this,"hit.aiff");
  miss = new SoundFile(this,"miss.aiff");
  grass = requestImage("images/grass.png");

  loghelper = new LogHelper();
  frameRate(30);
  fullScreen();
  experimentId = "one";
  //modeId = "practice";
  //size(1400, 880);
}

void captureEvent(Capture video) {
  if(experimentId=="one"){
    video.read();
  }
}

void draw() {

  background(255);
  image(grass, 0, height-200, width, 400);
  if(experimentId==""){
    drawExperimentMenu();
  }
  else if(modeId==""){
    drawTaskMenu();

  }
  else if(experimentId!="" && modeId!=""){
    if(!taskStarted){
      logger = new Logger(participantId, new GameEventWriter());
      logger.enableLogging();

      if(experimentId=="one"){
        cam = new Capture(this, 800, 600);
        cam.start();
        String filename = String.format("%s_%s_%s", participantId, modeId, time);
        videoExport = new VideoExport(this, "videos/one/"+filename+".mp4", cam);
        videoExport.setFrameRate(30); 
        //videoExport.setQuality(100);
        videoExport.startMovie();
        recordVideo = true;
      }
      else if(experimentId=="two"){
        println("connected");
        myClient = new Client(this, "127.0.0.1", 25000);
      }
      
      loghelper.logExperimentStart();
      app=new App();
      app.game.addSequence();
      taskStarted=true;
    }
    if (recordVideo && experimentId=="one" && !gameoverflag){
      if(verbose)
        loghelper.VideoFrameEvent();
      videoExport.saveFrame();
    }
    app.game.draw();
  }
}

void drawExperimentMenu(){
    textSize(30);
    fill(0,0,0);
    rect(width/2-200, height/2-200, 210, 80,5);
    //rect(width/2+50, height/2-200, 210, 80,5);
    fill(255,255,255);
    text("Experiment 1",width/2-190,height/2-150);
    //text("Experiment 2",width/2+60,height/2-150);
}

void drawTaskMenu(){
    textSize(30);
    fill(0,0,0);
    rect(width/2-100, height/2-200, 250, 80,5);
    rect(width/2-100, height/2-100, 250, 80,5);
    //rect(width/2-100, height/2, 200, 80,5);
    //rect(width/2-100, height/2+100, 200, 80,5);
    text("Experiment: "+experimentId,width/2-120,height/2-250);
    fill(255,255,255);
    text("Practice",width/2-80,height/2-150);
    text("Experiment",width/2-80,height/2-50);
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
if(experimentId==""){
    if (mouseX >= width/2-200 && mouseX <= width/2+10 && 
        mouseY >= height/2-200 && mouseY <= height/2-120) {
          experimentId="one";
        }
    if (mouseX >= width/2+50 && mouseX <= width/2+260 && 
        mouseY >= height/2-200 && mouseY <= height/2-120) {
          experimentId="two";
        }
  }
  else if(modeId==""){
    if (mouseX >= width/2-100 && mouseX <= width/2+150 && 
        mouseY >= height/2-200 && mouseY <= height/2-120) {
          modeId="practice";//"experiment";//
          taskOrders = practiceOrder;
          numBlocks = taskOrders.length;
          numSequences = taskOrders[0].length;
          numTrials = taskOrders[0][0].length;
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
    ListIterator<Trial> itr = app.game.sets[app.game.currentSequence].sequence.listIterator();
    while ( itr.hasNext() ) {
      Trial c = itr.next();
      if (c.type!="click")
        continue;
      if (mouseX >= c.x && mouseX <= c.x+c.w && 
        mouseY >= c.y && mouseY <= c.y+c.h) {
        //return true;
        logger.doLog(new MouseInputEvent("mousereleased",mouseX,mouseY));
        c.caught();  //return false;
        c = null;
        //itr.remove();
      }
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
    ListIterator<Trial> itr = app.game.sets[app.game.currentSequence].sequence.listIterator();
    while ( itr.hasNext() ) {
      Trial c = itr.next();
      if (wordBeingTyped.equals(c.label) && !c.isCaught) {
        c.caught();
        c = null;
        //itr.remove();
        //itr.remove();
        break;
      }
    }
    wordBeingTyped="";
  } else if(experimentId!="" && modeId!=""){
    //if (keyCode != 16 && keyCode != 17 && keyCode != 18) {
    if(ev.isShiftDown() || ev.isControlDown() || ev.isAltDown()){
      //println(app.game.currentSequence);
      ListIterator<Trial> itr = app.game.sets[app.game.currentSequence].sequence.listIterator();
      while ( itr.hasNext() ) {
        Trial c = itr.next();
        if (c.modifierkey != "" && !c.isCaught ) {
          if(c.shortcutkeycode==keyCode && ((c.modifierkey=="Ctrl" && ev.isControlDown()) || (c.modifierkey=="Shift" && ev.isShiftDown()) || (c.modifierkey=="Option" && ev.isAltDown()))){
            logger.doLog(new KeyboardInputEvent("keypressed",Integer.toString(keyCode),c.modifierkey));
            c.caught();
            c = null;
            //itr.remove();
          }
          break;
        }
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
    videoExport.endMovie();
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
