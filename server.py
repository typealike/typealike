# Echo server program
import cv2
import json
import socket
import numpy as np
from fastai.vision import *

recordflag = False
cap = cv2.VideoCapture(0)
cap.set(3,800)
cap.set(4,600)
cap.set(cv2.CAP_PROP_FPS, 30)
cap.set(cv2.CAP_PROP_FRAME_WIDTH, 1280);
cap.set(cv2.CAP_PROP_FRAME_HEIGHT, 720);

print(cap.get(cv2.CAP_PROP_FPS))
w = cap.get(cv2.CAP_PROP_FRAME_WIDTH);
h = cap.get(cv2.CAP_PROP_FRAME_HEIGHT); 

learn = load_learner('./models/',"alldata.pkl")

with open('variables.json') as f:
	jsonObj = json.load(f)

HOST = jsonObj["host"]
PORT = jsonObj["port"]
print("listening on "+str(HOST)+":"+str(PORT))

s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s.bind((HOST, PORT))
s.listen(1)
conn, addr = s.accept()
conn.send("hello".encode())
print('Connected by', addr)
# filename = jsonObj["project_root"]+"/videos/"+conn.recv(2048)+".mp4"

# if socketdata[:10]=="Typingtest":
# 	recordflag = True
# Define the codec and create VideoWriter object
# fourcc = cv2.VideoWriter_fourcc(*'mp4v')
# out = cv2.VideoWriter(filename,fourcc, 30.0, (int(w),int(h)))

while(cap.isOpened()):
	ret, frame = cap.read()
	if ret==True:
		# frame = cv2.flip(frame,0)
		# print(data)
		# data = conn.recv(1024)
		smallImg = cv2.resize(frame,(256,256)) # model was trained with images resized to 256x256

		p = cv2.cvtColor(smallImg, cv2.COLOR_BGR2RGB)
		t = pil2tensor(p, dtype=np.float32)/255
		preds = learn.predict(Image(t))
		print(str(preds[0]))
		conn.send(str(preds[0]).encode('utf-8'))
		cv2.imshow('frame',frame)

		if not conn:
			break;

	else:
		break

print("video created at "+filename)
# Release everything if job is finished
conn.close()
cap.release()
out.release()
cv2.destroyAllWindows()