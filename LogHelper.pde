import java.time.Instant;
import java.time.Duration;

Logger logger; // global logger object

class LogHelper{

  LogHelper(){
  }
  
  void logExperimentStart(){
    experimentStartTime = Instant.now().toString();
    String JSONStr = logger.buildJSON("\"type\"", "\"start\"", "\"participantid\"", "\"" + participantId+ "\"",
                    "\"study\"", "\"" + experimentId + "\"",
                    "\"datetime\"", "\"" + experimentStartTime + "\"");
    logger.doLog(new JSONEvent("E", "experiment", true, JSONStr));
  }
  void logBlockStart(int currentBlock){
    blockStartTime = Instant.now().toString();
    String JSONStr = logger.buildJSON("\"type\"", "\"start\"", "\"num\"", "\"" + currentBlock+ "\"",
                    "\"numBlocks\"", "\"" + numBlocks + "\"",
                    "\"datetime\"", "\"" + blockStartTime + "\"");
    logger.doLog(new JSONEvent("E", "block", false, JSONStr));
  }
  void logSequenceStart(){
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
  void logTargetStart(String label, String targetType, int startX){
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
                    "\"num\"", "\"" + app.game.sets[app.game.currentSequence].targetIndex + "\"",
                    "\"startX\"", "\"" + startX + "\"",
                    "\"startY\"", "\"" + 0 + "\"",
                    "\"width\"", "\"" + 100 + "\"",
                    "\"height\"", "\"" + 100 + "\"",
                    "\"datetime\"", "\"" + targetStartTime + "\"");
    logger.doLog(new JSONEvent("E", "trial", false, JSONStr));
  }
  
  void logExperimentEnd(){
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
  void logBlockEnd(){
    blockEndTime = Instant.now().toString();
    Duration d = Duration.between(Instant.parse(blockStartTime),Instant.parse(blockEndTime));
    String JSONStr = logger.buildJSON("\"type\"", "\"end\"", "\"num\"", "\"" + app.game.currentBlock + "\"",
                    "\"datetime\"", "\"" + Instant.now().toString() + "\"",
                    "\"duration\"", "\"" + d+ "\"");
    logger.doLog(new JSONEvent("E", "block", true, JSONStr));
  }
  void logSequenceEnd(){
    setEndTime = Instant.now().toString();
    Duration d = Duration.between(Instant.parse(setStartTime),Instant.parse(setEndTime));
    String JSONStr = logger.buildJSON("\"type\"", "\"end\"", "\"num\"", "\"" + app.game.currentSequence + "\"",
                    "\"datetime\"", "\"" + setEndTime + "\"",
                    "\"duration\"", "\"" + d+ "\"");
    logger.doLog(new JSONEvent("E", "sequence", false, JSONStr));
  }
  void logTargetEnd(String label, String targetType, String status){
    println("end");
    println(targetStartTime);
    println(targetEndTime);
    targetEndTime = Instant.now().toString();
    Duration d = Duration.between(Instant.parse(targetStartTime),Instant.parse(targetEndTime));

// "#<time>,E,task,{type:end, label:<labelName>, action:<hit/miss>, targetType:<targetType>, num:<taskNum>, blockNum:<blockNum>, setNum:<setNum>, datetime:<time>, duration:<numSeconds>}",
    String JSONStr = logger.buildJSON("\"type\"", "\"end\"", "\"label\"", "\"" + label+ "\"",
                    "\"action\"", "\"" + status + "\"",
                    "\"currScore\"", "\"" + app.game.score + "\"",                    
                    "\"targetType\"", "\"" + targetType + "\"",
                    "\"num\"", "\"" + app.game.sets[app.game.currentSequence].targetIndex + "\"",
                    "\"sequenceNum\"", "\"" + app.game.currentSequence + "\"",
                    "\"blockNum\"", "\"" + app.game.currentBlock + "\"",
                    "\"datetime\"", "\"" + targetEndTime + "\"",
                    "\"duration\"", "\"" + d+ "\"");
    logger.doLog(new JSONEvent("E", "trial", false, JSONStr));
  }  
  void VideoFrameEvent(){
    String JSONStr = logger.buildJSON("\"datetime\"", "\"" + Instant.now().toString() + "\"");
    logger.doLog(new JSONEvent("M", "video", false, JSONStr));
  }
}
