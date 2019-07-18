# Echo server program
import socket


import numpy as np
import cv2

cap = cv2.VideoCapture(0)

cap.set(3,800)
cap.set(4,600)
cap.set(cv2.CAP_PROP_FPS, 30)
print(cap.get(cv2.CAP_PROP_FPS))
w = cap.get(cv2.CAP_PROP_FRAME_WIDTH);
h = cap.get(cv2.CAP_PROP_FRAME_HEIGHT); 
HOST = '127.0.0.1'                 # Symbolic name meaning all available interfaces
PORT = 25000              # Arbitrary non-privileged port
# Define the codec and create VideoWriter object
fourcc = cv2.VideoWriter_fourcc(*'mp4v')
out = cv2.VideoWriter('output.mp4',fourcc, 30.0, (int(w),int(h)))

print("listening on "+str(HOST)+":"+str(PORT))
s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s.bind((HOST, PORT))
s.listen(1)
conn, addr = s.accept()
print('Connected by', addr)
flag = False
while(cap.isOpened()):
	ret, frame = cap.read()
	if ret==True:
		# frame = cv2.flip(frame,0)
		data = conn.recv(1024)

		if(data=="start"):
			flag=True;
		# print(data)
		# write the flipped frame
		if(flag):
			out.write(frame)
			cv2.imshow('frame',frame)

		if data=="complete":#cv2.waitKey(1) & 0xFF == ord('q'):
			print("VIDEO RECORDED")
			break
		if not data:
			break;

	else:
		break

# Release everything if job is finished
conn.close()
cap.release()
out.release()
cv2.destroyAllWindows()
# while(True):
	
# 	if not data: break

# 	# print(data)
# 	if(data == 'frame'):
# 		readFrame()




# HOST = '127.0.0.1'                 # Symbolic name meaning all available interfaces
# PORT = 25000              # Arbitrary non-privileged port
# print("listening on "+str(HOST)+":"+str(PORT))
# s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
# s.bind((HOST, PORT))
# s.listen(1)
# conn, addr = s.accept()
# print('Connected by', addr)
# while True:
#     data = conn.recv(1024)
#     if not data: break
#     print(data) # Paging Python!
#     # do whatever you need to do with the data
# conn.close()
# # optionally put a loop here so that you start 
# # listening again after the connection closes