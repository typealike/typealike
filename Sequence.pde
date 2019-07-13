import java.util.ArrayList;

class Sequence{
  ArrayList<Trial> sequence = new ArrayList<Trial>();
  Boolean loadNextSequence;
  int sequenceIndex, blockIndex;
  int targetIndex;
  String[] type_array;// = {"shortcut","shortcut","shortcut","shortcut","shortcut","shortcut","shortcut"};
  Timer t;
  Sequence(int blockIndex, int sequenceIndex){
      this.targetIndex=-1;
      this.sequenceIndex= sequenceIndex;
      this.blockIndex= blockIndex;
      this.loadNextSequence = false;

      this.type_array = taskOrders[this.blockIndex][this.sequenceIndex];
  }
  Trial addTarget(){
    String type="word";
    this.targetIndex+=1;  
    //"#<time>,E,task,{type:start, label:<labelName>, targetType:<targetType>, datetime:<time>, currScore:<currScore>, setNum:<setNum>, blockNum:<blockNum>, num:<targetNum>, speed:<targetSpeed>, startX:<startX>, startY:<startY>, width:<targetWidth>, height:<targetHeight>}",
    if(this.targetIndex == numTrials)
      this.loadNextSequence = true;
    else{
      // if(experimentId=="one" && modeId=="practice"){
      //   String[] typing_task = {"word","equation"};
      //   int index = (int)random(0,typing_task.length);
      //   type= typing_task[index];
      // }
      // else //if(experimentId=="one" && modeId=="two")
      type = type_array[this.targetIndex];
    }

    Trial c = new Trial(type,getLabel(type));
    if(this.targetIndex!=7)
      loghelper.logTargetStart(c.label,c.type,c.x);
    
    wordBeingTyped="";
    return c;
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
    else{
      label="click me";
    }
   
    return label;
  }
}
