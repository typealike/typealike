class Timer {

  int savedTime; // When Timer started
  int totalTime; // How long Timer should last
  int[] availableTime = {1000,2000,3000,4000,5000};
  int passedTime;
  Timer(int tempTotalTime) {
    totalTime = tempTotalTime;
    passedTime = 0;
  }

  // Starting the timer
  void start() {
    // When the timer starts it stores the current time in milliseconds.
    passedTime = 0;
    savedTime = millis();
  }
  
  void setTime(int newTotalTIme){
    totalTime = newTotalTIme;
  }

  // The function isFinished() returns true if 5,000 ms have passed. 
  // The work of the timer is farmed out to this method.
  boolean isFinished() { 
    // Check how much time has passed
    passedTime = millis()- savedTime;
    //int randomTime = (int) random(1,4);
    if (passedTime > totalTime /*availableTime[randomTime]*/) {
      return true;
    } else {
      return false;
    }
  }
}
