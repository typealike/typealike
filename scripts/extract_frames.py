import os
import sys
import json
from contextlib import closing
from videosequence import VideoSequence

if len(sys.argv) != 2:
	print("Usage:\n")
	print("python extract_frames.py <log_file>")
	sys.exit()

# https://stackoverflow.com/questions/17060039/split-string-at-nth-occurrence-of-a-given-character
def splitn(string, spliton, n):
    """split 'string' on nth occurence of 'spliton'
    """
    groups = string.split(spliton)
    return spliton.join(groups[:n]), spliton.join(groups[n:])


projectroot = "/Users/nalinc/Projects/typealike"
filepath = "/log/one/"
pidentifier = sys.argv[1]

data = open(projectroot+'/training/videoframes_'+pidentifier[:-4]+'.csv', 'w')



firstTimestamp=0
firstFrameVisited=False
flag=False
currentGetsure=""
videoframes={}
count=0
frameIndex=0
with open(projectroot+filepath+pidentifier) as f:
    content = f.readlines()

for line in content:
    if line[0] == '#':
        continue
    r = line.strip().split(',')

    if r[1] == "M":
        frameIndex+=1
    else:
        if r[1] == "E" and r[2]=="trial":
            rr = splitn(line, ',', 3)
            ed = json.loads(rr[1])
            if ed["type"]=="start" and ed["targetType"]=="posture":
                flag=True
                currentGesture=ed["label"]
            elif ed["type"]=="end" and ed["targetType"]=="posture":
                flag=False
        else:
            continue
    if not firstFrameVisited:
        firstTimestamp = r[0]
        firstFrameVisited = True;
    if flag:
        # datarow = (str(int(30*(int(r[0])-int(firstTimestamp))/1000)),currentGesture)
        datarow = (str(frameIndex),currentGesture)
#         print(datarow)
        videoframes[datarow[0]]=datarow[1]
#         videoframes.append(datarow)
        datarow_csv = ",".join(datarow)
        data.write(datarow_csv + '\n')
    count+=1
data.close()

directory = projectroot+"/training/"+pidentifier[:-4]
postureclasses = ["Left_Close_0_On","Left_Close_0_Below", "Left_Close_0_Beside", "Left_Close_90_On", "Left_Close_90_Below", "Left_Close_90_Beside", "Left_Close_180_On", "Left_Close_180_Below", "Left_Close_180_Beside",
"Left_Open_0_On","Left_Open_0_Below", "Left_Open_0_Beside", "Left_Open_90_On", "Left_Open_90_Below", "Left_Open_90_Beside", "Left_Open_180_On", "Left_Open_180_Below", "Left_Open_180_Beside",
"Right_Close_0_On","Right_Close_0_Below", "Right_Close_0_Beside", "Right_Close_90_On", "Right_Close_90_Below", "Right_Close_90_Beside", "Right_Close_180_On", "Right_Close_180_Below", "Right_Close_180_Beside",
"Right_Open_0_On","Right_Open_0_Below", "Right_Open_0_Beside", "Right_Open_90_On", "Right_Open_90_Below", "Right_Open_90_Beside", "Right_Open_180_On", "Right_Open_180_Below", "Right_Open_180_Beside"]
try:
    if not os.path.exists(directory):
        os.makedirs(directory)
        for posturedir in postureclasses:
            if not os.path.exists(directory+"/"+posturedir):
                os.makedirs(directory+"/"+posturedir)
except OSError:
    print ('Error: Creating directory. ' +  directory)




videofile = projectroot+"/videos/one/"+pidentifier[:-4]+".mp4"
flag = True
programCounter = 0 # iterator for videoframes
with closing(VideoSequence(videofile)) as frames:
    for idx, frame in enumerate(frames[0:]):
#         if programCounter+1 == len(videoframes):
#             break
#         print(str(idx))
        if str(idx) in videoframes.keys():
            frame.save("../training/"+pidentifier[:-4]+"/"+videoframes[str(idx)]+"/"+pidentifier[:]+"_frame_"+str(idx)+".jpg")
            flag=False
