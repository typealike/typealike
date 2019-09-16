from fastai.vision import *
from pynput.keyboard import Key, Controller
import cv2
import time
import threading
# https://www.pdf-flip.com/#Samples

keyboard = Controller()
class Typealike:
    
    def __init__(self):
        self.learn = load_learner('..',"models/alldata.pkl")
        self.font = cv2.FONT_HERSHEY_SIMPLEX
        self.framesprocessedinlastsecond = 0
        self.fps=0
        self.timer = 0
        self.filename = "video.mp4"#+str(time.time())
        self.w = 1280
        self.h = 720
        self.fourcc = cv2.VideoWriter_fourcc(*'mp4v')


    def countFPS(self):
        self.timer = threading.Timer(1.0, self.countFPS).start()
        self.fps = self.framesprocessedinlastsecond
        self.framesprocessedinlastsecond = 0

    def videocap(self):
        # self.countFPS()
        cap = cv2.VideoCapture(0)
        cap.set(cv2.CAP_PROP_FPS, 30)
        out = cv2.VideoWriter(self.filename,self.fourcc, 30.0, (int(self.w),int(self.h)))
        if cap.isOpened():
            cap.set(cv2.CAP_PROP_FRAME_WIDTH, self.w);
            cap.set(cv2.CAP_PROP_FRAME_HEIGHT, self.h);
            framecount = 0
            
            startTime = time.time()
            key_pressed = ""
            while(True):
                currentTime = time.time()
                ret, frame = cap.read()
                # cap.set(cv2.CAP_PROP_FPS, 30);

                smallImg = cv2.resize(frame,(256,256)) # model was trained with images resized to 256x256
                p = cv2.cvtColor(smallImg, cv2.COLOR_BGR2RGB)
                t = pil2tensor(p, dtype=np.float32)/255
                preds = self.learn.predict(Image(t))
                
                # cv2.putText(frame,str(preds[0]),(10,700), self.font, 1,(255,255,255),2,cv2.LINE_AA)

                framecount += 1
                self.framesprocessedinlastsecond +=1
                endTime = time.time()
                # if int(self.endTime - self.startTime) == 1:
                #     self.fps = self.framesprocessedinlastsecond
                #     self.framesprocessedinlastsecond = 0
                #     self.startTime = time.time()
                # units = time.time() % 60
                    
                self.fps = cap.get(cv2.CAP_PROP_FPS)
                # fps = fps if fps > framesprocessedinlastsecond else framesprocessedinlastsecond
                # if units > 59:
                # framecount % 60
                    # fps = framecount % 60
                if str(preds[0]) == "Right_Open_0_On" or str(preds[0]) == "Left_Open_180_On":
                    if key_pressed == Key.left:
                        keyboard.release(key_pressed)
                    if key_pressed != Key.right:
                        key_pressed = Key.right
                        keyboard.press(key_pressed)
                        keyboard.release(key_pressed)
                    # keyboard.press(key_pressed)  
                    # keyboard.release(key_pressed)                  
                elif str(preds[0]) == "Right_Open_180_On" or str(preds[0]) == "Left_Open_0_On":
                    if key_pressed == Key.right:
                        keyboard.release(key_pressed)
                    if key_pressed != Key.left:
                        key_pressed = Key.left
                        keyboard.press(key_pressed)
                        keyboard.release(key_pressed)
                    # keyboard.press(key_pressed)
                    # keyboard.release(key_pressed)
                    # keyboard.release(Key.left)
                # elif str(preds[0]) == "no_posture" or str(preds[0]) == "typing":
                else:
                    if key_pressed:
                        keyboard.release(key_pressed)
                        print("KEY RELEASED = ", key_pressed)
                        key_pressed = ""
                print("Posture = ",str(preds[0])," KEY = ", key_pressed)
                # key_pressed = ""
                # if key_pressed:
                #     keyboard.press(key_pressed)
                #     keyboard.release(key_pressed)
                #     print("KEY PRESSED = ", key_pressed)
                # cv2.putText(frame,"diff: "+str(endTime-currentTime),(1000,400), self.font, 1,(255,255,255),2,cv2.LINE_AA)    
                # cv2.putText(frame,"FPS: "+str(self.fps),(1000,700), self.font, 1,(255,255,255),2,cv2.LINE_AA)
                # cv2.imshow('frame',frame)
                # out.write(frame)

                if cv2.waitKey(1) & 0xFF == ord('q'):
                    # self.timer.stop()
                    end = time.time()
                    print("FINISH TIME=  ", end - startTime)
                    print("NUMBER OF FRAMEs= ", framecount)
                    print("FPS: {}".format(framecount/(end-startTime)))
                    break
        else:
            print("Can't open camera")

        cap.release()
        out.release()
        cv2.destroyAllWindows()

if __name__=='__main__':
    t = Typealike()
    t.videocap()
    # videocap()
