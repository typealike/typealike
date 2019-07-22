import java.util.ArrayList;

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
  void addTarget(){
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

  String getLabel(String type){
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
