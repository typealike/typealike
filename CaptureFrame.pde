import java.util.Deque;
import java.util.concurrent.ConcurrentLinkedDeque;
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
