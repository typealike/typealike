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
  void updateBlockIndex(){
      this.currentBlock+=1;
  }
  void updateSequenceIndex(){
      this.currentSequence+=1;
  }
  /*
  Command to start the game. Currently when conte connects but will be when user leaves splash screen
  */
  void addSequence(){
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
  void logGameStart(){
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
  void updateScore(int deltaScore){
    this.score += deltaScore;
  }
  
  /*
  End of game
  */
  void gameFinished(){
    gameOver = true;
    started = false;
    logGameEnd();
  }
  
  /*
  Logs game finished event
  */
  void logGameEnd(){
    //String JSONStr = logger.buildJSON("\"type\"", "\"end\"", "\"id\"", str(participantId), "\"score\"", str(score));
    //logger.doLog(new JSONEvent("E", "experiment", true, JSONStr));
  }
  
  /*---------- DRAW -----------*/
  
  /*
  Draws the current stage. Gets called after update so there is something to draw
  */
  void draw(){
    
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
          if(experimentId=="two" && identifiedPosture.equals(app.game.sequence.trial.label)){
            logger.doLog(new PostureEvent(identifiedPosture));
            //this.score+=10;
            app.game.sequence.trial.caught();
            this.updateScore(10);
            //itr.add(this.sets[this.currentSequence].addTarget());
            this.sequence.trial = null;
            this.sequence.addTarget();
          }
          //if(experimentId=="one" && c.type=="posture" && timerFlag){
          //  println("TIMER STRT");
          //  timerFlag = false;
          //  this.timer.start();
          //}
          //else if(experimentId=="one" && c.type=="posture" && timer.isFinished()){
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
  void drawBetweenBlockBreak(){
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
  void drawInfo() {
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
    
  void drawTextbox() {
    fill(0, 0, 0);
    //rect(0, height-100, width, 100, 1);
    fill(255, 0, 0);
    textSize(40);
    text(wordBeingTyped+blinkChar(), width/2-50, height-80, 300, 50);
  }

  
  String blinkChar() {
    return (frameCount>>2 & 1) == 0 ? "_" : "";
  }  
  /*
  Draws the current score on the screen
  */
  void drawScore(){
    //String scoreStr = "Score: " + score;
    //textAlign(CENTER, TOP);
    //fill(0);
    //textSize(40);
    //text(scoreStr, width/2.0, 10);
  }
  
  /*
  Draws game over screen
  */
  void drawGameOver(){
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
 void disableScore(){
   showScore = false;
 }
 
 /*
 Enables score being shown.
 */
 void enableScore(){
   showScore = true;
 }
 
 /*
 Returns current score of game
 */
 int getScore(){
   return score;
 }
 
 void toggleInfo(){
   //showInfo = !showInfo;
   //app.showInfo = !app.showInfo;
 }
}
