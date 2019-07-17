public class CaptureFrame extends Thread
   {
     //Capture cam;
     VideoExport videoExport;
     private volatile boolean exit = false;
     CaptureFrame (VideoExport videoExport1 ) {
      //cam = cam1;
      videoExport = videoExport1;
      videoExport.startMovie();
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
      }
      
      videoExport.endMovie();
      println("VIDEO ENDED");
      println("End of Capture");
     }
     
     void complete() {
       exit = true;
     }
   }
