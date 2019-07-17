public class CaptureFrame extends Thread
   {
     //Capture cam;
     VideoExport ve;
     private volatile boolean exit = false;
     CaptureFrame (VideoExport videoExport1 ) {
      //cam = cam1;
      ve = videoExport1;
      ve.startMovie();
      //String filename = String.format("%s_%s_%s", participantId, modeId, startTime);
      ////videoExport = new VideoExport(this, "videos/one/"+filename+".mp4", cam);
      //videoExport.setFrameRate(30); 
      ////videoExport.setQuality(100);
      //videoExport.startMovie();
    }

     public void run()
     {
       //videoExport.startMovie();
       print("Begin Capture");
      //captureImages();
      while(!exit){
        ve.saveFrame();
      }
      
      ve.endMovie();
      println("VIDEO ENDED");
      println("End of Capture");
     }
     
     void complete() {
       exit = true;
     }
   }
