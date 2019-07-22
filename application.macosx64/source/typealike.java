import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import processing.net.*; 
import java.util.List; 
import java.util.ListIterator; 
import processing.video.*; 
import com.hamoid.*; 
import processing.sound.*; 
import java.util.Deque; 
import java.util.concurrent.ConcurrentLinkedDeque; 
import java.time.Instant; 
import java.time.Duration; 
import java.text.DateFormat; 
import java.text.SimpleDateFormat; 
import java.io.FileWriter; 
import java.io.PrintWriter; 
import java.util.Calendar; 
import java.lang.Math; 
import java.util.ArrayList; 
import java.util.Arrays; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class typealike extends PApplet {

 //<>// //<>//






public void setup() {
  initVariables();
   //movie = new Movie (this,"hit.mp3");
  hit = new SoundFile(this,"hit.aiff");
  miss = new SoundFile(this,"miss.aiff");
  
  print(taskOrders[0][0][0]);
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

  frameRate(30);
  
  if(experimentId.equals("one")){
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
    myClient = new Client(this, HOST, PORT);
    myClient.write(participantId+"_"+modeId+"_"+startTime);
  }
  else if(experimentId.equals("two")){
    println("connected");
    myClient = new Client(this, HOST, PORT);
  }
  //modeId = "practice";
  //size(1400, 880);
  app=new App();
}

public void captureEvent(Capture video) {
  if(experimentId.equals("one")){
    video.read();
  }
}

public void draw() {

  background(255);

    if(!taskStarted){
      drawExperimentMenu();
    }
    else{
      if (recordVideo && experimentId.equals("one") && !gameoverflag){
        if(verbose)
          loghelper.VideoFrameEvent();
        //videoExport.saveFrame();
        //thread.de_que.addFirst(10);
        //myServer.write("capture");
        //if (myClient != null)
          myClient.write("capture");
      }
      app.game.draw();    
    }

}

public void drawExperimentMenu(){
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


public void mouseMoved(){
  if(experimentId!="" && modeId!="")
    logger.doLog(new MouseInputEvent("moved",mouseX,mouseY));
}

public void mousePressed(){
  if(experimentId!="" && modeId!="")
    logger.doLog(new MouseInputEvent("mousepressed",mouseX,mouseY));
}

public void mouseReleased() {

if(!taskStarted){
    if (mouseX >= width/2-100 && mouseX <= width/2+150 && 
        mouseY >= height/2-200 && mouseY <= height/2-120) {
          app.game.addSequence();
          taskStarted=true;
          //thread.start();
          //if (myClient != null)
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

public void keyPressed(KeyEvent ev) {
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

public void keyReleased(){
  if(experimentId!="" && modeId!="")
    logger.doLog(new KeyboardInputEvent("keyreleased", Integer.toString(keyCode),"none"));
}

/*
Stops game in middle
*/
public void exit() {
  loghelper.logExperimentEnd();
  if(experimentId.equals("one")){
    println(experimentId);
    println(modeId);
    println("VIDEO ENDED");
    //if (modeId=="experiment")
    //myServer.write("complete");
    if (myClient != null)
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
class App{
  Game game;
// Recognizer recognizer;
  App(){
    this.game=new Game();
  }
  public void draw(){
    //game.draw();
  }
  //void update(String type,String label){
  //  game.update(type,label);
  //}
}


public class CaptureFrame extends Thread
   {
     Capture cam;
     VideoExport videoExport;
     ConcurrentLinkedDeque<Integer> de_que = new ConcurrentLinkedDeque<Integer>(); 
     public volatile boolean complete = false;
     CaptureFrame (PApplet that) {
      cam = new Capture(that, 800, 600);
      String filename = String.format("%s_%s_%s", participantId, modeId, startTime);
      videoExport = new VideoExport(that, "videos/one/"+filename+".mp4");
      //cam = cam1;
      //videoExport = vExport;
      videoExport.setFrameRate(30);
      videoExport.setGraphics(cam);      
      print("THREAD STRAT");
      //String filename = String.format("%s_%s_%s", participantId, modeId, startTime);
      //ve = new VideoExport(this, "videos/one/"+filename+".mp4", cam);
       
      //videoExport.setQuality(100);
      cam.start();
      videoExport.startMovie();
    }

     public void run()
     {
       //videoExport.startMovie();
       print("Begin Capture");
       
      //captureImages();
      while(!this.complete){
        
        if (!de_que.isEmpty()){
          de_que.removeLast();
          print("frame captured\n");
          videoExport.saveFrame();
        }
        
        //try{
        //    Thread.sleep(30);
        //}catch(InterruptedException e){}

      }
      
      cam.stop();
      videoExport.endMovie();
      println("VIDEO ENDED");
      println("End of Capture");
     }
     
     //void complete() {
     //  exit = true;
     //}
   }
class Game{
  //Timer timer = new Timer(postureTimer);    // Create a timer that goes off every 300 milliseconds
  Sequence sequence;    // Create 1000 spots in the array;       // An array of task objects  // UGLY LOGIC
  int currentBlock=-1;
  int currentSequence=-1;
  // stages
  int totalNumStages;
  int[] stageTypes;
  //final int[] normalStageTypes = {slow, medium, fast, medium}; // the order the rounds will go in
  int score = 0; // total score of the game so far, not including currStage
  boolean gameOver; // true if game is over
  boolean started; // has the game started
  boolean gameStopped = false; // game is stopped after started. MUST START AS FALSE ONLY TRUE WHEN DELAYED RECEIVED
  boolean betweenBlockBreak; // in break between stage
  boolean endBreak; // set when break set to end
  int randomSeed;
  //PApplet parent; // needed to shuffle properly
  boolean showScore = true;
  boolean showInfo = false; 
  boolean timerFlag= true;
  
  /*
  Input: randomSeed is the random seed for the game
         parent is the sketch, needed to shuffle with random seed
  */
  Game(){
    this.score = 0; // startScore is global
    updateBlockIndex();
    loghelper.logBlockStart(this.currentBlock);
    updateSequenceIndex();
    this.gameOver = false;
    this.started = false;
    logGameStart();
    this.addSequence();
    
    //timer.start();             // Starting the timer
    //targets[totalTargets] = new Trial(1,getRandomLabel());//, sprites[1]);
    //// Increment totalTargets
    //this.totalTargets ++postureMa
    
    postureMap = new StringDict();
    postureMap.set("0","no-op");
    postureMap.set("1","typing");
    for(int i=0;i<postures.length;i++){
      postureMap.set(String.valueOf(i+2),postures[i]);
    }
  }
  public void updateBlockIndex(){
      this.currentBlock+=1;
  }
  public void updateSequenceIndex(){
      this.currentSequence+=1;
  }
  /*
  Command to start the game. Currently when conte connects but will be when user leaves splash screen
  */
  public void addSequence(){
    this.sequence = new Sequence(this.currentBlock, this.currentSequence);
    loghelper.logSequenceStart();
    //Trial t = this.sets[this.currentSequence].sequence.get(this.sets[this.currentSequence].targetIndex);
    this.sequence.trial = null;
    this.sequence.addTarget();

    ////if(this.sets[this.currentSequence].targetIndex!=7)
    //println("WTH");
    //  loghelper.logTargetStart(t.label, t.type, t.x);
  }
  
  /*
  Logs the start of the game
  */
  public void logGameStart(){
    //String[] stageOrder = new String[totalNumStages];
    //for(int i = 0; i < stageOrder.length; i++){
    //  int stageInt = stageTypes[i];
    //  String stageStr = stageNameToString(stageInt);
    //  stageOrder[i] = "\"" + stageStr + "\""; // need escaped quotes for json string
    //}
    //String stagerOrderJSONArr = logger.buildJSONArr(stageOrder);
    //String JSONStr = logger.buildJSON("\"type\"", "\"start\"", "\"id\"", str(participantId),
    //                                  "\"menuType\"", "\"" + gameType + "\"",
    //                                  "\"numStages\"", str(totalNumStages), "\"stageOrder\"", stagerOrderJSONArr, 
    //                                  "\"randomSeed\"", str(randomSeed), "\"numCommands\"", str(numCommands), 
    //                                  "\"contactCommandPairs\"", app.contactCommandJSON());
    //logger.doLog(new JSONEvent("E", "experiment", true, JSONStr));    
  }

  
  /*
  Updates the game score
  Input: deltaScore is the new score to add to the current score
  */
  public void updateScore(int deltaScore){
    this.score += deltaScore;
  }
  
  /*
  End of game
  */
  public void gameFinished(){
    gameOver = true;
    started = false;
    logGameEnd();
  }
  
  /*
  Logs game finished event
  */
  public void logGameEnd(){
    //String JSONStr = logger.buildJSON("\"type\"", "\"end\"", "\"id\"", str(participantId), "\"score\"", str(score));
    //logger.doLog(new JSONEvent("E", "experiment", true, JSONStr));
  }
  
  /*---------- DRAW -----------*/
  
  /*
  Draws the current stage. Gets called after update so there is something to draw
  */
  public void draw(){
    
  // Check the timer        
    //if (experimentId.equals("two") && timer.isFinished()) {
    //  //this.targets[totalTargets] = new Trial(1,getRandomLabel());//, sprites[totalTargets%sprites.length]);
    //  //this.totalTargets ++ ;
    //  //if (this.totalTargets >= this.targets.length) {
    //  //  this.totalTargets = 0; // Start over
    //  //}
    //  //this.sets[this.currentSequence].sequence.add(this.sets[this.currentSequence].addTarget());
    //  this.timer.start();
    //}
    if(gameOver){
      drawGameOver();
    }
    else if(!gameStopped){
      if (experimentId.equals("two") && myClient.available() > 0) {
        dataIn = myClient.read();
        identifiedPosture = postureMap.get(String.valueOf(dataIn));
        fill(255,0,0);
        text(identifiedPosture,width-300,height-150);
        println(dataIn+", "+identifiedPosture);
      }
  
      //if(this.currentSequence > this.sets.length){
      //  drawGameOver();
      //  return;
      //}
      //println(this.sets[this.currentSequence].loadNextSequence);
      if(this.sequence.loadNextSequence){
        println("load next set");
        if(this.currentSequence+1==numSequences){
          if(this.currentBlock+1==numBlocks){
            loghelper.logSequenceEnd();
            gameOver=true;
            //drawGameOver();
          }
          else{
            loghelper.logSequenceEnd();
            updateBlockIndex();
            this.currentSequence=0;
            this.gameStopped=true;
          }
          loghelper.logBlockEnd();
        }
        else if(!gameOver && !gameStopped){
          //if(this.currentSequence+1!=numSequences){
            this.currentSequence++;
            loghelper.logSequenceEnd();
            this.addSequence();
          //}
        }
      }
      else{
          if(!app.game.sequence.trial.isCaught && !app.game.sequence.trial.isMissed){
            app.game.sequence.trial.move();
            app.game.sequence.trial.display();
          }
          if(!app.game.sequence.trial.isMissed && millis()-app.game.sequence.trial.trialStartTime > postureTimer){//app.game.sequence.trial.meteorY>height-100){
            app.game.sequence.trial.missed();
            //this.score-=5;
            if (experimentId == "one" && app.game.sequence.trial.type == "posture")
              this.updateScore(5);
            else
              this.updateScore(-5);
            //if(experimentId.equals("one"))
            this.sequence.trial = null;
            this.sequence.addTarget();
            //this.sets[this.currentSequence].addTarget();
          }
          if(app.game.sequence.trial.isCaught){
            //this.score+=10;
            this.updateScore(10);
            //if(experimentId.equals("one"))
            //itr.add(this.sets[this.currentSequence].addTarget());
            this.sequence.trial = null;
            this.sequence.addTarget();
          }
          if(experimentId.equals("two") && identifiedPosture.equals(app.game.sequence.trial.label)){
            logger.doLog(new PostureEvent(identifiedPosture));
            //this.score+=10;
            app.game.sequence.trial.caught();
            this.updateScore(10);
            //itr.add(this.sets[this.currentSequence].addTarget());
            this.sequence.trial = null;
            this.sequence.addTarget();
          }
          //if(experimentId.equals("one") && c.type=="posture" && timerFlag){
          //  println("TIMER STRT");
          //  timerFlag = false;
          //  this.timer.start();
          //}
          //else if(experimentId.equals("one") && c.type=="posture" && timer.isFinished()){
          //  println("TIMER END");
          //  c.caught();
          //  itr.remove();
          //  itr.add(this.sets[this.currentSequence].addTarget());
          //  timerFlag = true;
          //} 
      }
      if(this.sequence.trial.type=="word")
        drawTextbox();
      drawInfo();
    }
    else if(gameStopped){
      drawBetweenBlockBreak();
    }

  }
    
  /*
  Draws screen between stages
  */
  public void drawBetweenBlockBreak(){
    //background(app.getBackground());
    String displayStr = "BREAK TIME";
    String littleDisplayStr = "push space to continue";
    gameStopped=true;
    fill(0,0,0);
    textSize(40);
    text(displayStr, width/2-60, height/2 - 30);
    textSize(30);
    text(littleDisplayStr, width/2-120, height/2 + 30);
  }
  
  /*
  Draws game info at bottom of screen.
  Draws score at top
  */
  public void drawInfo() {
    //draw text with stage #, set #, enemy #
    String experiment = "Experiment: "+ experimentId;
    String player = "ParticipantID: " + participantId;
    String block = "B: " + this.currentBlock;
    String set = "S: " + this.currentSequence;
    String score = "Score: "+ this.score;
    //textAlign(CENTER, BOTTOM);
    fill(0, 0, 0);
    textSize(20);
    text(experiment, 10, height-60);
    text(player, 10, height-10);
    text(block, width-200, height-10);
    text(set, width-100, height-10);
    text(score, width-200, height-60);
  }
    
  public void drawTextbox() {
    fill(0, 0, 0);
    //rect(0, height-100, width, 100, 1);
    fill(50, 180, 50);
    textSize(40);
    text(wordBeingTyped+blinkChar(), width/2-50, height-80, 300, 50);
  }

  
  public String blinkChar() {
    return (frameCount>>2 & 1) == 0 ? "_" : "";
  }  
  /*
  Draws the current score on the screen
  */
  public void drawScore(){
    //String scoreStr = "Score: " + score;
    //textAlign(CENTER, TOP);
    //fill(0);
    //textSize(40);
    //text(scoreStr, width/2.0, 10);
  }
  
  /*
  Draws game over screen
  */
  public void drawGameOver(){
    String gameOverStr;
    if(showScore){
      gameOverStr = "FINAL SCORE: " + score;
    } else {
      gameOverStr = "END!";
    }    
    textAlign(CENTER, CENTER);
    fill(0,0,0);
    textSize(40);
    text(gameOverStr, width/2, height/2);
    if(!gameoverflag){
      gameoverflag = true;
      exit();
    }
    
  }
  
  /*---------- SETUP ----------*/

 /*
 Returns the current enemy
 Output: current enemy, null if there's isn't one
 */
 //Enemy getCurrEnemy(){
 //  if(currStage != null){
 //    return currStage.getCurrEnemy();
 //  } else {
 //    return null;
 //  }
 //}
  
 /*
 Disables score being shown. It's still counted
 */
 public void disableScore(){
   showScore = false;
 }
 
 /*
 Enables score being shown.
 */
 public void enableScore(){
   showScore = true;
 }
 
 /*
 Returns current score of game
 */
 public int getScore(){
   return score;
 }
 
 public void toggleInfo(){
   //showInfo = !showInfo;
   //app.showInfo = !app.showInfo;
 }
}
class GameEventWriter extends EventWriter {
  GameEventWriter() {
    super();
  }

  public void logSchema() {
    String[] schemaArr = {
      "# Typealike Interactions", 
      "#<time>,E,experiment,{type:start, participantid:<participantId>, study:<studyId>, datetime:<time>}", 
      "#<time>,E,experiment,{type:end, participantid:<participantId>, score:<score>, datetime:<time>, duration:<duration>}", 
      "#<time>,E,block,{type:start, num:<blockNum>, numBlocks:<numBlocks>, datetime:<time>}", 
      "#<time>,E,block,{type:end, num:<blockNum>, datetime:<time>, duration:<numSeconds>}", 
      "#<time>,E,sequence,{type:start, blockNum:<blockNum>, num:<sequenceNum>, datetime:<time>, taskOrder:<taskOrderIndex>}", 
      "#<time>,E,sequence,{type:end, num:<sequenceNum>, datetime:<time>, duration:<numSeconds>}", 
      "#<time>,E,trial,{type:start, label:<labelName>, targetType:<targetType>, datetime:<time>, sequenceNum:<sequenceNum>, blockNum:<blockNum>, num:<targetNum>, startX:<startX>, startY:<startY>, width:<targetWidth>, height:<targetHeight>}", 
      "#<time>,E,trial,{type:end, label:<labelName>, action:<hit/miss>, targetType:<targetType>, num:<taskNum>, blockNum:<blockNum>, sequenceNum:<sequenceNum>, datetime:<time>, duration:<numSeconds>}", 
      "#<time>,M,video, datetime:<time>", 
      "# schema,{type:I, subtype:key, data:[event, keyname, modifierkey], type:[str,str], description:[<pressed/released>, <keycode>, <Shift/Ctrl/Alt/none>] }", 
      "# schema,{type:I, subtype:mouse, data:[event, x, y], type:[str, int,int], description:[moved/pressed/released,<x-coordinate>,<y-coordinate>]}", 
      "# schema,{type:I, subtype:posture, data:[name], type:[str], description:[<posture name>] }"
    };
    for (String schemaStr : schemaArr) {
      this.writer.print(schemaStr+"\n");
    }
    super.logSchema();
  }
}



class LogHelper{

  LogHelper(){
  }
  
  public void logExperimentStart(){
    experimentStartTime = Instant.now().toString();
    String JSONStr = logger.buildJSON("\"type\"", "\"start\"", "\"participantid\"", "\"" + participantId+ "\"",
                    "\"study\"", "\"" + experimentId + "\"",
                    "\"datetime\"", "\"" + experimentStartTime + "\"");
    logger.doLog(new JSONEvent("E", "experiment", true, JSONStr));
  }
  public void logBlockStart(int currentBlock){
    blockStartTime = Instant.now().toString();
    String JSONStr = logger.buildJSON("\"type\"", "\"start\"", "\"num\"", "\"" + currentBlock+ "\"",
                    "\"numBlocks\"", "\"" + numBlocks + "\"",
                    "\"datetime\"", "\"" + blockStartTime + "\"");
    logger.doLog(new JSONEvent("E", "block", false, JSONStr));
  }
  public void logSequenceStart(){
    if(isFirst){
      //isFirst=false;
      return;
    }
    setStartTime = Instant.now().toString();
    //println(app.game.currentSequence);
    String JSONStr = logger.buildJSON("\"type\"", "\"start\"", "\"blockNum\"", "\"" + app.game.currentBlock+ "\"",
                    "\"num\"", "\"" + app.game.currentSequence + "\"",
                    "\"taskOrder\"", "\"" + app.game.currentSequence + "\"",
                    "\"datetime\"", "\"" + setStartTime + "\"");
    logger.doLog(new JSONEvent("E", "sequence", false, JSONStr));
  }
  public void logTrialStart(String label, String targetType, int startX){
    if(isFirst){
      isFirst=false;
      return;
    }
    targetStartTime = Instant.now().toString();
// "#<time>,E,task,{type:start, label:<labelName>, targetType:<targetType>, datetime:<time>, currScore:<currScore>, setNum:<setNum>, blockNum:<blockNum>, num:<targetNum>, speed:<targetSpeed>, startX:<startX>, startY:<startY>, width:<targetWidth>, height:<targetHeight>}",    
    String JSONStr = logger.buildJSON("\"type\"", "\"start\"", "\"label\"", "\"" + label+ "\"",
                    "\"targetType\"", "\"" + targetType + "\"",
                    "\"sequenceNum\"", "\"" + app.game.currentSequence + "\"",
                    "\"blockNum\"", "\"" + app.game.currentBlock + "\"",
                    "\"num\"", "\"" + app.game.sequence.targetIndex + "\"",
                    "\"startX\"", "\"" + startX + "\"",
                    "\"startY\"", "\"" + 0 + "\"",
                    "\"width\"", "\"" + 100 + "\"",
                    "\"height\"", "\"" + 100 + "\"",
                    "\"datetime\"", "\"" + targetStartTime + "\"");
    logger.doLog(new JSONEvent("E", "trial", false, JSONStr));
  }
  
  public void logExperimentEnd(){
    experimentEndTime = Instant.now().toString();
    if(experimentStartTime == null)
      return;
    Duration d = Duration.between(Instant.parse(experimentStartTime),Instant.parse(experimentEndTime));
    String JSONStr = logger.buildJSON("\"type\"", "\"end\"", "\"participantid\"", "\"" + participantId+ "\"",
                    "\"score\"", "\"" + app.game.score + "\"",
                    "\"datetime\"", "\"" + experimentEndTime + "\"",
                    "\"duration\"", "\"" + d+ "\"");
    logger.doLog(new JSONEvent("E", "experiment", true, JSONStr));
  }
  public void logBlockEnd(){
    blockEndTime = Instant.now().toString();
    Duration d = Duration.between(Instant.parse(blockStartTime),Instant.parse(blockEndTime));
    String JSONStr = logger.buildJSON("\"type\"", "\"end\"", "\"num\"", "\"" + app.game.currentBlock + "\"",
                    "\"datetime\"", "\"" + Instant.now().toString() + "\"",
                    "\"duration\"", "\"" + d+ "\"");
    logger.doLog(new JSONEvent("E", "block", true, JSONStr));
  }
  public void logSequenceEnd(){
    setEndTime = Instant.now().toString();
    Duration d = Duration.between(Instant.parse(setStartTime),Instant.parse(setEndTime));
    String JSONStr = logger.buildJSON("\"type\"", "\"end\"", "\"num\"", "\"" + app.game.currentSequence + "\"",
                    "\"datetime\"", "\"" + setEndTime + "\"",
                    "\"duration\"", "\"" + d+ "\"");
    logger.doLog(new JSONEvent("E", "sequence", false, JSONStr));
  }
  public void logTrialEnd(String label, String targetType, String status){
    //println("end");
    //println(targetStartTime);
    //println(targetEndTime);
    targetEndTime = Instant.now().toString();
    Duration d = Duration.between(Instant.parse(targetStartTime),Instant.parse(targetEndTime));

// "#<time>,E,task,{type:end, label:<labelName>, action:<hit/miss>, targetType:<targetType>, num:<taskNum>, blockNum:<blockNum>, setNum:<setNum>, datetime:<time>, duration:<numSeconds>}",
    String JSONStr = logger.buildJSON("\"type\"", "\"end\"", "\"label\"", "\"" + label+ "\"",
                    "\"action\"", "\"" + status + "\"",
                    "\"currScore\"", "\"" + app.game.score + "\"",                    
                    "\"targetType\"", "\"" + targetType + "\"",
                    "\"num\"", "\"" + app.game.sequence.targetIndex + "\"",
                    "\"sequenceNum\"", "\"" + app.game.currentSequence + "\"",
                    "\"blockNum\"", "\"" + app.game.currentBlock + "\"",
                    "\"datetime\"", "\"" + targetEndTime + "\"",
                    "\"duration\"", "\"" + d+ "\"");
    logger.doLog(new JSONEvent("E", "trial", false, JSONStr));
  }  
  public void VideoFrameEvent(){
    String JSONStr = logger.buildJSON("\"datetime\"", "\"" + Instant.now().toString() + "\"");
    logger.doLog(new JSONEvent("M", "video", false, JSONStr));
  }
}






/*---------- LOGGER -----------*/
class Logger{
  EventWriter eventWriter = null;
  boolean loggingEnabled = false; // gets turned on on game start
  
  /*
  Input: participantId is an 1 or 2 digit int representing the participant number
  */
  Logger(String participantId, EventWriter eventWriter){
    DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd-HH-mm-ss");
    startTime = dateFormat.format(Calendar.getInstance().getTime());
    
    // file name
    String filename;
    String dirName = String.format("log/%s", experimentId);
    filename = String.format("log/%s/%s_%s_%s.txt",experimentId, participantId, modeId, startTime);
    this.eventWriter = eventWriter;
    this.eventWriter.createFile(filename, dirName);
    println("Logging to", filename);
    eventWriter.logSchema();
  }
  
  /*
  Logs an event
  Input: event is the event to log
  */
  public void doLog(Event event){
    if(loggingEnabled){
      eventWriter.doLog(System.currentTimeMillis(), event);
    }
  }
  
  /*
  Enable logging
  */
  public void enableLogging(){
    loggingEnabled = true;
  }
  
  /*
  Disable logging
  */
  public void disableLogging(){
    loggingEnabled = false;
  }
  
  /*
  To query if logger is enabled
  */
  public boolean isEnabled(){
    return loggingEnabled;
  }
  
  /*
  Input format: label, value, label, value,...
  Input: Strings in the order of label, value pairs
  Output: valid JSON string
  */
  public String buildJSON(String... args){
    StringBuilder result = new StringBuilder();
    result.append("{");
    for(int i = 0; i < args.length; i+=2){
      String label = args[i];
      String value = args[i+1];
      result.append(label);
      result.append(":");
      result.append(value);
      result.append(",");
    }
    if(args.length > 0){
      result.deleteCharAt(result.length() - 1); // delete comma at end
    }
    result.append("}");
    return result.toString();
  }
  
  /*
  Builds and single JSON array containing args and returns it
  Input: Strings to be put into an array
  Output: A JSON array containing the elements of args
  */
  public String buildJSONArr(String... args){
    StringBuilder result = new StringBuilder();
    result.append("[");
    for(int i = 0; i < args.length; i++){
      result.append(args[i]);
      result.append(",");
    }
    if(args.length > 0){
      result.deleteCharAt(result.length() - 1); // remove comma at end
    }
    result.append("]");
    return result.toString();
    // OLD
  }
}

/*
An interface for anything which can be recorded in the logfile.
*/

interface Event {  
  /*
   A unique identifier that can be used to identify the class of this event.
   Output: the unique identifier
   */
  public String eventType();
  
  /*
  A comma delineated string containing all the extra parameters specific to the event. 
  One parameter might be a JSON str
  Output: the string
  */
  public String details();
  
  /*
  Returns true if the logger should be flushed immediately after this event.
  If this is false, the buffer will not be flushed until it receives a flush event.
  Output: true if should flush, false otherwise
  */
  public boolean isFlushEvent();
}

/*
Log Input events
*/
class InputEvent implements Event{
  String subtype;
  String eventSource;
  InputEvent(String subtype, String eventSource){
    this.eventSource = eventSource;
    this.subtype = subtype;
  }
  public String eventType(){ return "I"; }
  public String details(){
    String result = String.format("%s,%s", subtype, eventSource);
    return result;
  }
  public boolean isFlushEvent(){ return false; }
}
/*
Log keyboard events
Log format: I,k,keycode,modifier
*/
class KeyboardInputEvent extends InputEvent{
  static final String subtype = "keyboard";
  String modifierKey, keyname;
  KeyboardInputEvent(String eventSource, String keyname, String modifier){
    super(subtype, eventSource);
    this.modifierKey = modifier;
    this.keyname = keyname;
  }
  public String details(){
    String result = super.details();
    result = String.format("%s,%s,%s", result, keyname, modifierKey);
    return result;    
  }
}


/*
Log mouse events
Log format: I,m,click,x,y
*/
class MouseInputEvent extends InputEvent{
  static final String subtype = "mouse";
  int x, y;
  MouseInputEvent(String eventSource, int x, int y){
    super(subtype, eventSource);
    this.x = x;
    this.y = y;
  }
  public String details(){
    String result = super.details();
    result = String.format("%s,%d,%d", result,x,y);
    return result;    
  }
}

/*
Log posture events
Log format: I,g,posturename
*/
class PostureEvent extends InputEvent{
  static final String subtype = "posture";
  PostureEvent(String eventSource){
    super(subtype, eventSource);
  }
}

/*
Log any event with the format: type,subtype,JSON
Eg: E,block,JSON
*/
class JSONEvent implements Event{
  String type;
  String subtype;
  boolean flushEvent;
  String JSON;
  JSONEvent(String type, String subtype, boolean flushEvent, String JSON){
    this.type = type;
    this.subtype = subtype;
    this.flushEvent = flushEvent;
    this.JSON = JSON;
  }
  public String eventType(){ return type; }
  public String details(){
    return String.format("%s,%s", subtype, JSON);
  }
  public boolean isFlushEvent(){ return flushEvent; }
}

/*---------- EVENT WRITER -----------*/

/*
A writer that prints output to a log file. The format is a series of lines:
  timestamp, event, details
The timestamp is the system time in milliseconds when the event occured
The event is a unique identifier saying what kind of event it is
The details are the event-specific details, sometimes containing JSON.
*/
class EventWriter{
  PrintWriter writer;
  ArrayList<String> buffer;
  EventWriter() {
      this.buffer = new ArrayList<String>();
  }
  
  public void createFile(String filename, String dirName){
    try {
      // create dir if not exists
      File dir = new File(sketchPath(dirName));
      if(!dir.exists()){
        dir.mkdirs();
      }
      // create new fileR
      File file = new File(sketchPath(filename));
      this.writer = new PrintWriter(new FileWriter(file));
    } catch (IOException ex) {
      println("Uncaught exception:");
      println(ex);
      System.exit(0);
    }
  }
  
  public void doLog(long timestamp, Event event) {
    this.buffer.add(String.format("%d,%s,%s\n", timestamp, event.eventType(), event.details())); 
    //print("\nBuffer Size:\t"+this.buffer.size());
    if (event.isFlushEvent() || this.buffer.size() > 500) {
      for (String line: this.buffer) {
        this.writer.print(line);
      }
      this.buffer.clear();
      this.writer.flush();
    }
  }
  
  /*
  Logs schema to file
  */
  public void logSchema(){
    this.writer.print("# START LOG\n");
    this.writer.flush();
  }  
}
 
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
                   text((float) Math.sin(2-this.x),200,200);
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


class Sequence{
  Trial trial;
  Boolean loadNextSequence;
  int sequenceIndex, blockIndex;
  int targetIndex;
  String[] type_array;// = {"shortcut","shortcut","shortcut","shortcut","shortcut","shortcut","shortcut"};
  //Timer t;
  Sequence(int blockIndex, int sequenceIndex){
      this.targetIndex=-1;
      this.sequenceIndex= sequenceIndex;
      this.blockIndex= blockIndex;
      this.loadNextSequence = false;

      this.type_array = taskOrders[this.blockIndex][this.sequenceIndex];
  }
  public void addTarget(){
    String type="word";
    this.targetIndex+=1;  
    //"#<time>,E,task,{type:start, label:<labelName>, targetType:<targetType>, datetime:<time>, currScore:<currScore>, setNum:<setNum>, blockNum:<blockNum>, num:<targetNum>, speed:<targetSpeed>, startX:<startX>, startY:<startY>, width:<targetWidth>, height:<targetHeight>}",
    if(this.targetIndex == numTrials)
      this.loadNextSequence = true;
    else{
      // if(experimentId.equals("one") && modeId=="practice"){
      //   String[] typing_task = {"word","equation"};
      //   int index = (int)random(0,typing_task.length);
      //   type= typing_task[index];
      // }
      // else //if(experimentId.equals("one") && modeId=="two")
      type = type_array[this.targetIndex];
    }

    this.trial = new Trial(type,getLabel(type));
    if(this.targetIndex!=numTrials)
      loghelper.logTrialStart(this.trial.label,this.trial.type,this.trial.x);
    
    wordBeingTyped="";
  }

  public String getLabel(String type){
    String label;
    if(type=="word"){
      int index = (int)random(0,words.length);
      label = words[index];
    }
    else if(type=="posture"){
      label = postures[this.sequenceIndex];
    }
    else if(type=="shortcut"){
      int index = (int)random(0,shortcuts.length);
      label = shortcuts[index];
    }
    else{
      label="click me";
    }
   
    return label;
  }
}


class Trial {
    int x, y;   // Variables for location of Object(text, button, posture)
    int meteorX, meteorY;   // Variables for location of Meteor
    
    Posture posture;   // Contain posture variables for location, form, hand, coordinates etc
    float speed = taskSpeed;  // Speed of Trial
    int jitter;
    Boolean flag=true;
    int c;
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
    List<String> blockWords = Arrays.asList("left", "up", "right", "down", "J", "H");
    Trial(String type, String lbl) {
      this.type=type;
      r = 8;                   // All raindrops are the same size
      // Start with a random x location
      trialStartTime = millis();
      if (this.type=="posture") {
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
  public void move() {
    // Increment by speed
    //if ((this.type!="posture" || experimentId!="one") && this.type!="click") {
    //  y += speed;
    //}
    
    this.meteorY = PApplet.parseInt((millis()-this.trialStartTime)*0.18f);
    //this.meteorY+=speed;
    
  }

  // Check if it hits the bottom
  public boolean reachedBottom() {
    // If we go a little beyond the bottom
    if (y > height + r*4) { 
      return true;
    } else {
      return false;
    }
  }

  // Display the raindrop
  public void display() {
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
    if (this.type=="word") {
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
  public void caught() {
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
  public void missed() {
    miss.play();
    // Stop it from moving by setting speed equal to zero
    this.speed = 0;
    this.isMissed = true;
    // Set the location to somewhere way off-screen
    this.y = height+10;
    loghelper.logTrialEnd(this.label, this.type, "miss");
  }
}
JSONObject json;

App app;
Capture cam;
Client myClient; 
Server myServer;
SoundFile hit,miss;
VideoExport videoExport;
Logger logger;
LogHelper loghelper;
CaptureFrame thread;

StringDict postureMap;
enum WiggleMode { INC, DEC};
HashMap<String,PImage> iconSet;
int[] codes;
Boolean verbose,recordVideo,taskStarted,isFirst,gameoverflag;
int numBlocks, numSequences, numTrials, taskSpeed, postureTimer, dataIn, PORT;
String participantId, experimentId, modeId, wordBeingTyped, startTime, identifiedPosture, experimentStartTime, experimentEndTime, blockStartTime, blockEndTime, setStartTime, setEndTime, targetStartTime, targetEndTime, HOST;
String[][][] taskOrders, practiceOrder, experimentOrder;
String[] shortcuts, modifierkeys, words, postures;

  
public void initVariables(){
  json = loadJSONObject("variables.json");
  HOST= json.getString("host");
  PORT= json.getInt("port");
  participantId = json.getString("participant_id");
  experimentId = json.getString("experiment_id"); //one/two
  modeId = json.getString("mode_id");// practice/experiment
  taskSpeed = 6;//json.getInt("task_speed");
  postureTimer = 6000;//json.getInt("task_speed"); 
  verbose = json.getBoolean("verbose");//false;// log video frame events
  
  wordBeingTyped="";
  recordVideo=false;
  taskStarted=false; //<>//
  identifiedPosture="";
  isFirst=true;
  gameoverflag=false;

  iconSet = new HashMap<String,PImage>();
  
  shortcuts= new String[]{"left", "up", "right", "down", "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"};
  codes= new int[]{37, 38, 39, 40, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90}; 
  modifierkeys= new String[]{"Option", "Ctrl", "Shift"};

  words =new String[] {"power", "radio", "alley", "Throw", "going", "who's", "Hedda", "sky's", "Timon", "found", "bulky", "locks", "peace", "young", "Their", "cover", "Luisa", "child", "after", "value", "Bucer", "cared", "mania", "stoop", "While", "ahead", "acted", "depot", "enemy", "sixty", "irons", "await", "named", "asses", "fleck", "trust", "safer", "Negro", "bleak", "irony", "paths", "grows", "ideal", "curly", "Staff", "Labor", "honor", "White", "walls", "novel", "banks", "House", "woods", "state", "Eli's", "likes", "upset", "Walsh", "dress", "She'd", "Greek", "Scout", "piled", "merit", "grown", "Uncle", "towns", "Along", "carts", "abbot", "edges", "liked", "scrub", "while", "spend", "Music", "fifty", "kinds", "raped", "three", "barge", "meant", "mucus", "lovin", "eager", "Payne", "civic", "You'd", "noted", "style", "lulls", "Whigs", "tears", "event", "tract", "fires", "calls", "Fists", "niche", "roofs", "Which", "eased", "Still", "queer", "moral", "cluck", "added", "beans", "smoke", "month", "bathe", "bully", "fight", "Anita", "abbey", "Creek", "weary", "greet", "Booth", "hover", "fears", "dimly", "today", "faces", "lover", "faded", "Odilo", "Offer", "Clara", "linen", "Fetch", "Lemme", "pulls", "stock", "shore", "dusty", "bosom", "older", "Dover", "sails", "horns", "chick", "wires", "cloud", "fried", "rocks", "Burly", "start", "stand", "plump", "rider", "below", "glory", "drown", "stuff", "Dirty", "wired", "drift", "clock", "drunk", "Poles", "he'll", "grunt", "laden", "shaft", "night", "label", "slits", "gleam", "tired", "signs", "naked", "birth", "How's", "phone", "rites", "breed", "Pieta", "glass", "cards", "twist", "C'est", "games", "shape", "shone", "coast", "Sound", "gonna", "enter", "alive", "crack", "Abbot", "favor", "harem", "voice", "hens'", "image", "Maria", "stool", "words", "Elder", "fiery", "could", "paced", "sober", "Isaac", "shock", "close", "knoll", "sides", "traps", "jaded", "Swiss", "sorry", "court", "Quick", "chose", "faith", "bride", "there", "dog's", "suits", "tools", "aisle", "pains", "Early", "waded", "amuse", "serve", "winds", "choke", "freed", "Blois", "wrote", "quick", "minds", "touch", "fling", "lousy", "wages", "broke", "grate", "ruler", "fists", "shrub", "Byron", "cleat", "taken", "speck", "agree", "Leona", "ivory", "idols", "clips", "bills", "tough", "color", "teeth", "dream", "watch", "flung", "lusty", "sheer", "plays", "thorn", "catch", "balls", "ships", "paint", "halos", "razor", "Drury", "panic", "loved", "shall", "packs", "clung", "cleft", "weeks", "Drunk", "abyss", "rails", "Going", "essay", "gowns", "belch", "Hired", "you'd", "Later", "Judea", "brush", "leave", "split", "Fifth", "movie", "given", "Tours", "pique", "drops", "devil", "flare", "relax", "one's", "hopes", "grand", "bells", "wrist", "geese", "death", "Order", "known", "front", "spume", "Water", "lance", "torso", "guest", "Favre", "vogue", "Souci", "views", "Eliot", "maybe", "crept", "beach", "royal", "swell", "beset", "slept", "South", "wails", "wheel", "clerk", "Ferry", "first", "tight", "other", "sight", "wiped", "robed", "Leave", "beech", "quite", "we're", "drier", "bowed", "Debts", "gusto", "lying", "fence", "maids", "guilt", "Lousy", "scope", "hurry", "Joe's", "Maybe", "usual", "plate", "day's", "Italy", "print", "oddly", "cuffs", "frees", "begun", "mourn", "exile", "frail", "agent", "prove", "skirt", "stood", "sushi", "chain", "Derby", "folks", "sighs", "Annie", "haunt", "along", "right", "spell", "quart", "blade", "chest", "porch", "midst", "takes", "times", "daunt", "shook", "Mines", "piano", "loyal", "Pat's", "drank", "Lying", "strut", "waist", "smelt", "folds", "judge", "manor", "aware", "swept", "would", "plush", "meals", "let's", "hafta", "gauge", "flick", "Times", "magic", "Booby", "Naked", "might", "begin", "plant", "horse", "brand", "son's", "level", "basin", "Saint", "After", "Lippi", "humor", "flour", "buddy", "stove", "Melzi", "sleep", "sizes", "Marsh", "pilot", "Astor", "Those", "patch", "sends", "blood", "links", "aloof", "isn't", "Frank", "tempt", "giant", "Never", "shift", "hinge", "flies", "chief", "these", "doing", "stern", "Craig", "chafe", "awful", "Anger", "caved", "write", "range", "Above", "model", "index", "serge", "Under", "reach", "Texas", "halls", "funny", "worry", "ready", "boats", "knack", "takin", "Fixed", "ports", "Yooee", "Gouge", "booth", "point", "Sixty", "rapid", "goose", "mouth", "short", "baths", "notes", "Tears", "misty", "sweat", "eaten", "We'll", "untie", "Davao", "build", "waved", "sofas", "think", "fancy", "cares", "terms", "myrrh", "ruled", "David", "album", "Scrub", "fired", "Won't", "Jorge", "argue", "shade", "Gogol", "Edwin", "vague", "march", "Ain't", "Hotel", "Below", "bring", "tango", "raced", "howls", "stray", "Laura", "choir", "steak", "paled", "bacon", "gasps", "store", "raged", "Verdi", "March", "Brest", "human", "blink", "aside", "allow", "angry", "forms", "spike", "brink", "spare", "wanta", "still", "Irvin", "inane", "gaily", "groin", "hired", "throw", "jerky", "paces", "moved", "tries", "skulk", "ashen", "least", "songs", "saved", "flats", "paper", "again", "cages", "cents", "inert", "south", "Lovie", "trash", "prize", "haste", "Knows", "tenth", "party", "press", "hoops", "wrack", "scale", "knows", "Tolek", "mercy", "Enjoy", "merge", "loins", "lucky", "sound", "Styka", "broad", "Metro", "niece", "Corne", "skies", "wring", "out'n", "brave", "heavy", "eight", "kid's", "Linda", "goals", "blame", "works", "Grove", "Dimes", "ROK's", "metal", "crime", "flood", "exist", "aloud", "order", "robes", "alert", "stuck", "guard", "Cycly", "silky", "fifth", "lawns", "track", "check", "cling", "coals", "loves", "miles", "score", "wrath", "doubt", "burst", "swung", "hotel", "weeds", "spire", "comes", "speak", "bunch", "C'mon", "cruel", "shake", "Duane", "cause", "beard", "rabbi", "wakes", "wines", "scrap", "Sheer", "wryly", "bench", "Place", "cough", "glued", "Muses", "Among", "heads", "spite", "stage", "Union", "Human", "Santa", "tepid", "grace", "charm", "wanna", "Flies", "shack", "shame", "fetid", "title", "barns", "rowed", "Light", "share", "lines", "sneer", "lemon", "trees", "fault", "Fanny", "bower", "queen", "berry", "drove", "anger", "teach", "Gre't", "tales", "plots", "gaunt", "husky", "grave", "scent", "asked", "glare", "tubes", "gummy", "Katie", "sired", "peaks", "light", "Would", "Ecole", "urine", "Corps", "It'll", "flame", "keeps", "crawl", "dirty", "silly", "North", "slope", "clump", "creep", "Today", "Wised", "items", "grief", "leaps", "rigid", "earth", "topic", "stick", "worst", "Devil", "panes", "alien", "brown", "slack", "story", "quiet", "deals", "boy's", "slice", "ought", "purse", "Irish", "round", "Husky", "pouch", "apple", "draws", "whirl", "honey", "noble", "bones", "spill", "stare", "lamps", "brain", "built", "Chief", "stars", "waxed", "sheaf", "fumes", "teens", "china", "quill", "Allen", "place", "plank", "bunks", "Krist", "haint", "until", "began", "flops", "hound", "crash", "pokes", "trace", "Black", "years", "faint", "shoes", "Funny", "surge", "juicy", "curse", "doves", "white", "enact", "Three", "cagey", "chase", "their", "filed", "guess", "shirt", "weirs", "imply", "holds", "Santo", "she'd", "waste", "rural", "spots", "drawl", "bored", "needs", "Heart", "Again", "Since", "flint", "Y'all", "weigh", "plied", "chaos", "shyly", "badly", "trips", "voted", "never", "Major", "using", "flock", "anvil", "Gonna", "toast", "hated", "froze", "crude", "vivid", "steel", "elfin", "cried", "Stick", "large", "knife", "chops", "blind", "storm", "drive", "decry", "weird", "crest", "Front", "carry", "Bible", "Ching", "crook", "alors", "stiff", "eagle", "bluff", "Can't", "tweed", "There", "inter", "edged", "Royal", "pages", "snail", "sadly", "Could", "hoist", "treat", "gloom", "whole", "sharp", "Siege", "sword", "Let's", "palms", "cigar", "opera", "attic", "lunch", "hen's", "can't", "inept", "Mavis", "reins", "Tokyo", "nymph", "strip", "furor", "don't", "bloom", "visit", "shout", "Tiber", "yours", "tying", "house", "skill", "grasp", "faced", "facts", "labor", "smell", "ankle", "sun's", "spark", "crags", "hulks", "angel", "homes", "rifle", "hints", "farms", "lived", "flash", "growl", "avoid", "coats", "seems", "silos", "Macon", "twice", "shoot", "woman", "hoped", "Stand", "limit", "every", "awake", "rasps", "lives", "clear", "great", "rules", "trial", "Chris", "About", "angle", "regal", "birds", "scant", "waves", "north", "brass", "Aggie", "shawl", "files", "where", "Dives", "books", "women", "Right", "tiled", "buggy", "piece", "speed", "Brook", "grass", "trade", "thing", "sayin", "early", "saint", "tryin", "group", "offer", "straw", "veils", "dingy", "Ahead", "towel", "we'll", "brick", "borne", "Cheat", "Bobby", "daily", "reply", "sense", "cloth", "green", "corps", "undid", "leash", "clean", "pussy", "Plans", "Dutch", "Whole", "mount", "doors", "flail", "ridge", "dozen", "Cheap", "dying", "She's", "upper", "fused", "petit", "yield", "solid", "hours", "baton", "yards", "obeys", "poems", "Grimm", "enjoy", "souls", "turns", "ended", "casts", "risen", "bulge", "nerve", "rolls", "pupil", "mewed", "Sally", "James", "Cover", "tells", "Billy", "wings", "showy", "bread", "hasps", "ranks", "Don't", "Louis", "budge", "wound", "backs", "sugar", "ached", "chute", "cross", "Rebel", "happy", "cavin", "money", "suite", "valet", "slide", "jelly", "ducks", "black", "swing", "hairy", "ideas", "crows", "staff", "local", "opens", "pumps", "beefy", "Canal", "sweep", "Giles", "Ludie", "Cried", "drink", "stone", "fever", "lists", "riven", "under", "Paris", "We've", "field", "elder", "eared", "later", "spent", "Great", "vocal", "pasty", "creek", "poked", "rooms", "alter", "pride", "girls", "worse", "moist", "third", "We're", "fuzzy", "gaudy", "youth", "widow", "being", "since", "cheer", "wagon", "shown", "Honor", "stump", "uncle", "basis", "proud", "truth", "which", "herbs", "crank", "Seems", "Jim's", "foyer", "hunch", "bugle", "dared", "Peter", "Fresh", "Henry", "dough", "smirk", "smart", "Slice", "hills", "vital", "blast", "spoke", "tried", "logic", "dates", "China", "sworn", "block", "Trust", "plans", "squad", "fille", "notch", "board", "comin", "occur", "count", "privy", "frame", "entry", "knock", "fixed", "boots", "skull", "admit", "clams", "final", "fucks", "water", "inner", "raise", "Rumor", "Medal", "belly", "lands", "uh-uh", "Clean", "forth", "cases", "equal", "rides", "God's", "Jesus", "means", "hairs", "mines", "Ada's", "boxes", "learn", "sloop", "erect", "fully", "camps", "scarf", "lairs", "Aaron", "laugh", "couch", "Sleep", "pause", "shops", "shred", "River", "pants", "lanky", "apron", "dance", "Queen", "world", "holes", "major", "noise", "Young", "drawn", "cheek", "lined", "guide", "Rabbi", "shave", "tumor", "slave", "hands", "Brown", "olive", "crowd", "rocky", "Alone", "cat's", "knees", "flesh", "falls", "roads", "swirl", "knelt", "Every", "dirge", "worth", "spray", "parts", "drama", "gates", "H'all", "Chiba", "lower", "cream", "civil", "colts", "Board", "Abbey", "Sloan", "Where", "sized", "plain", "Keene", "handy", "owner", "snake", "steps", "tower", "slums", "small", "exact", "truce", "booby", "stole", "Until", "scuff", "makes", "craft", "study", "tread", "force", "heart", "slate", "dried", "Roman", "awoke", "Simms", "Yehhh", "Opera", "Ethel", "sixth", "scene", "climb", "shied", "forty", "fresh", "mooed", "Faint", "rough", "alone", "lungs", "prick", "rowdy", "cheap", "chair", "frise", "won't", "muddy", "train", "theme", "acres", "crazy", "Solid", "Rifle", "muted", "peril", "urged", "'nuff", "among", "First", "wedge", "Seven", "beams", "fiend", "loose", "poles", "spies", "Civil", "sulky", "Venus", "sweet", "bonds", "groom", "whose", "extra", "Bosch", "shove", "owl's", "she's", "ain't", "These", "April", "roast", "Sands", "He'll", "class", "threw", "State", "brief", "merry", "disks", "looks", "break", "often", "aloes", "Point", "gross", "Harry", "river", "sandy", "bulks", "wants", "outer", "seven", "tones", "waked", "floor", "wares", "steal", "gives", "table", "harpy", "Maple", "nails", "dumps", "dined", "who'd", "stall", "truly", "focal", "gangs", "alarm", "puppy", "thick", "skiff", "unwed", "perch", "focus", "colds", "above", "man's", "music", "heard", "names", "spoon", "Leale", "genre", "gazed", "leapt", "chord", "empty", "about", "smile", "those", "coils", "wrong", "beast", "Izaak"};

  postures = new String[]{
    "Left_Close_0_On",//};
    "Left_Close_0_Below", "Left_Close_0_Beside", "Left_Close_90_On", "Left_Close_90_Below", "Left_Close_90_Beside", "Left_Close_180_On", "Left_Close_180_Below", "Left_Close_180_Beside",
    "Left_Open_0_On","Left_Open_0_Below", "Left_Open_0_Beside", "Left_Open_90_On", "Left_Open_90_Below", "Left_Open_90_Beside", "Left_Open_180_On", "Left_Open_180_Below", "Left_Open_180_Beside",
    "Right_Close_0_On","Right_Close_0_Below", "Right_Close_0_Beside", "Right_Close_90_On", "Right_Close_90_Below", "Right_Close_90_Beside", "Right_Close_180_On", "Right_Close_180_Below", "Right_Close_180_Beside",
    "Right_Open_0_On","Right_Open_0_Below", "Right_Open_0_Beside", "Right_Open_90_On", "Right_Open_90_Below", "Right_Open_90_Beside", "Right_Open_180_On", "Right_Open_180_Below", "Right_Open_180_Beside"
  };

  
  practiceOrder = new String[][][]{
                               {
                                  //{"word"}
                                   {"word","posture"}, {"shortcut","posture"}, {"click","posture"}, {"word","posture"},
                                   {"shortcut","posture"}, {"click","posture"}, {"word","posture"}, {"click","posture"},
                                   {"word","posture"}, {"click","posture"}, {"shortcut","posture"}, {"click","posture"},
                                   {"word","posture"}, {"click","posture"}, {"shortcut","posture"}, {"click","posture"},
                                   {"word","posture"}, {"click","posture"}, {"word","posture"}, {"click","posture"},
                                   {"shortcut","posture"}, {"click","posture"}, {"word","posture"}, {"click","posture"},
                                   {"word","posture"}, {"click","posture"}, {"shortcut","posture"}, {"click","posture"},
                                   {"word","posture"}, {"click","posture"}, {"word","posture"}, {"click","posture"},
                                   {"shortcut","posture"}, {"click","posture"}, {"word","posture"}, {"click","posture"}
                                }
                             };

  experimentOrder= new String[][][]{
                                  {
                                    //{"word", "equation", "shortcut", "equation", "posture"}, 
                                    //{"click", "word", "posture", "word", "shortcut"}, 
                                    //{"word", "shortcut", "equation", "posture", "click"}, 
                                    //{"word", "word", "posture", "word", "shortcut"}, 
                                    //{"equation", "shortcut", "click", "word", "posture"}, 
                                    //{"equation", "shortcut", "click", "equation", "posture"}, 
                                    //{"word", "posture", "word", "equation", "shortcut"}, 
                                    //{"word", "word", "shortcut", "click", "posture"}, 
                                    //{"equation", "posture", "word", "click", "shortcut"}, 
                                    //{"equation", "equation", "shortcut", "equation", "posture"}, 
                                    //{"click", "click", "posture", "equation", "shortcut"}, 
                                    //{"word", "equation", "shortcut", "equation", "posture"}, 
                                    //{"click", "equation", "posture", "equation", "shortcut"}, 
                                    {"click", "shortcut", "click", "equation", "posture"}
                                  }, 
                                  {
                                    {"click", "word", "shortcut", "click", "posture"}, 
                                    {"click", "posture", "click", "word", "shortcut"}, 
                                    {"word", "posture", "word", "word", "shortcut"}, 
                                    {"equation", "shortcut", "word", "word", "posture"}, 
                                    {"equation", "posture", "click", "equation", "shortcut"}, 
                                    {"click", "word", "posture", "click", "shortcut"}, 
                                    {"equation", "posture", "equation", "shortcut", "equation"}, 
                                    {"equation", "word", "posture", "equation", "shortcut"}, 
                                    {"click", "posture", "equation", "word", "shortcut"}, 
                                    {"equation", "shortcut", "word", "posture", "word"}, 
                                    {"click", "shortcut", "click", "posture", "click"}, 
                                    {"click", "equation", "shortcut", "word", "posture"}, 
                                    {"click", "equation", "posture", "word", "shortcut"}, 
                                    {"word", "shortcut", "equation", "click", "posture"}
                                  }, 
                                  {
                                    {"word", "shortcut", "equation", "posture", "equation"}, 
                                    {"equation", "word", "shortcut", "word", "posture"}, 
                                    {"word", "posture", "word", "shortcut", "equation"}, 
                                    {"equation", "posture", "equation", "word", "shortcut"}, 
                                    {"word", "posture", "click", "shortcut", "word"}, 
                                    {"click", "shortcut", "equation", "equation", "posture"}, 
                                    {"click", "shortcut", "equation", "click", "posture"}, 
                                    {"word", "posture", "equation", "click", "shortcut"}, 
                                    {"click", "posture", "equation", "click", "shortcut"}, 
                                    {"click", "posture", "click", "shortcut", "equation"}, 
                                    {"word", "click", "shortcut", "click", "posture"}, 
                                    {"click", "posture", "click", "shortcut", "word"}, 
                                    {"word", "click", "shortcut", "click", "posture"}, 
                                    {"word", "click", "posture", "click", "shortcut"}
                                  }
                                };
  
  taskOrders = (modeId.equals("practice"))?practiceOrder:experimentOrder;
  numBlocks = taskOrders.length;
  numSequences = taskOrders[0].length;
  numTrials = taskOrders[0][0].length;

}
  public void settings() {  fullScreen(); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "typealike" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
