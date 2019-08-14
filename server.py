# Echo server program
import socket
import json

import numpy as np
import cv2

recordflag = False
cap = cv2.VideoCapture(0)
cap.set(3,800)
cap.set(4,600)
cap.set(cv2.CAP_PROP_FPS, 30)
print(cap.get(cv2.CAP_PROP_FPS))
w = cap.get(cv2.CAP_PROP_FRAME_WIDTH);
h = cap.get(cv2.CAP_PROP_FRAME_HEIGHT); 

with open('variables.json') as f:
	jsonObj = json.load(f)

HOST = jsonObj["host"]
PORT = jsonObj["port"]
print("listening on "+str(HOST)+":"+str(PORT))

s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s.bind((HOST, PORT))
s.listen(1)
conn, addr = s.accept()
conn.send("hello")
print('Connected by', addr)
filename = jsonObj["project_root"]+"/videos/"+conn.recv(2048)+".mp4"

# if socketdata[:10]=="Typingtest":
# 	recordflag = True
# Define the codec and create VideoWriter object
fourcc = cv2.VideoWriter_fourcc(*'mp4v')
out = cv2.VideoWriter(filename,fourcc, 30.0, (int(w),int(h)))

while(cap.isOpened()):
	ret, frame = cap.read()
	if ret==True:
		# frame = cv2.flip(frame,0)
		# print(data)
		data = conn.recv(1024)

		if(data=="start"):
			recordflag=True;

		# write the flipped frame
		if(recordflag):
			out.write(frame)
			cv2.imshow('frame',frame)


		if data=="complete":#cv2.waitKey(1) & 0xFF == ord('q'):
			print("VIDEO RECORDED")
			break
		if not data:
			break;

	else:
		break

print("video created at "+filename)
# Release everything if job is finished
conn.close()
cap.release()
out.release()
cv2.destroyAllWindows()