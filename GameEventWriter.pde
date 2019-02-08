class GameEventWriter extends EventWriter {
  GameEventWriter() {
    super();
  }

  void logSchema() {
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
      "# schema,{type:I, subtype:gesture, data:[name], type:[str], description:[<gesture name>] }"
    };
    for (String schemaStr : schemaArr) {
      this.writer.print(schemaStr+"\n");
    }
    super.logSchema();
  }
}
