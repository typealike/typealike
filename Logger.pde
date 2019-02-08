import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.io.FileWriter;
import java.io.PrintWriter;
import java.util.Calendar;

/*---------- LOGGER -----------*/

String time;
class Logger{
  EventWriter eventWriter = null;
  boolean loggingEnabled = false; // gets turned on on game start
  
  /*
  Input: participantId is an 1 or 2 digit int representing the participant number
  */
  Logger(String participantId, EventWriter eventWriter){
    DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd-HH-mm-ss");
    time = dateFormat.format(Calendar.getInstance().getTime());
    
    // file name
    String filename;
    String dirName = String.format("log/%s", experimentId);
    filename = String.format("log/%s/%s_%s_%s.txt",experimentId, participantId, modeId, time);
    this.eventWriter = eventWriter;
    this.eventWriter.createFile(filename, dirName);
    println("Logging to", filename);
    eventWriter.logSchema();
  }
  
  /*
  Logs an event
  Input: event is the event to log
  */
  void doLog(Event event){
    if(loggingEnabled){
      eventWriter.doLog(System.currentTimeMillis(), event);
    }
  }
  
  /*
  Enable logging
  */
  void enableLogging(){
    loggingEnabled = true;
  }
  
  /*
  Disable logging
  */
  void disableLogging(){
    loggingEnabled = false;
  }
  
  /*
  To query if logger is enabled
  */
  boolean isEnabled(){
    return loggingEnabled;
  }
  
  /*
  Input format: label, value, label, value,...
  Input: Strings in the order of label, value pairs
  Output: valid JSON string
  */
  String buildJSON(String... args){
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
  String buildJSONArr(String... args){
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
  String eventType();
  
  /*
  A comma delineated string containing all the extra parameters specific to the event. 
  One parameter might be a JSON str
  Output: the string
  */
  String details();
  
  /*
  Returns true if the logger should be flushed immediately after this event.
  If this is false, the buffer will not be flushed until it receives a flush event.
  Output: true if should flush, false otherwise
  */
  boolean isFlushEvent();
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
  String eventType(){ return "I"; }
  String details(){
    String result = String.format("%s,%s", subtype, eventSource);
    return result;
  }
  boolean isFlushEvent(){ return false; }
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
  String details(){
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
  String details(){
    String result = super.details();
    result = String.format("%s,%d,%d", result,x,y);
    return result;    
  }
}

/*
Log gesture events
Log format: I,g,gesturename
*/
class GestureEvent extends InputEvent{
  static final String subtype = "gesture";
  GestureEvent(String eventSource){
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
  String eventType(){ return type; }
  String details(){
    return String.format("%s,%s", subtype, JSON);
  }
  boolean isFlushEvent(){ return flushEvent; }
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
  
  void createFile(String filename, String dirName){
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
  
  void doLog(long timestamp, Event event) {
    this.buffer.add(String.format("%d,%s,%s\n", timestamp, event.eventType(), event.details())); 
    if (event.isFlushEvent()) {
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
  void logSchema(){
    this.writer.print("# START LOG\n");
    this.writer.flush();
  }  
}
