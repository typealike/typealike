import os
import json
from contextlib import closing
from videosequence import VideoSequence


# https://stackoverflow.com/questions/17060039/split-string-at-nth-occurrence-of-a-given-character
def splitn(string, spliton, n):
    """split 'string' on nth occurence of 'spliton'
    """
    groups = string.split(spliton)
    return spliton.join(groups[:n]), spliton.join(groups[n:])


projectroot = "/Users/nalinc/Projects/typealike"
filepath = "/log/one/"
pidentifier = "nalin007_practice_2019-02-08-02-08-49.txt"

data = open(projectroot+'/training/videoframes_'+pidentifier[:-4]+'.csv', 'w')



firstTimestamp=0
firstFrameVisited=False
flag=False
currentGetsure=""
videoframes={}
count=0
with open(projectroot+filepath+pidentifier) as f:
    content = f.readlines()

for line in content:
    if line[0] == '#':
        continue
    r = line.strip().split(',')
    if r[1] != "M":
        if r[1] == "E" and r[2]=="trial":
            rr = splitn(line, ',', 3)
            ed = json.loads(rr[1])
            if ed["type"]=="start" and ed["targetType"]=="gesture":
                flag=True
                currentGesture=ed["label"]
            elif ed["type"]=="end" and ed["targetType"]=="gesture":
                flag=False
        else:
            continue
    if not firstFrameVisited:
        firstTimestamp = r[0]
        firstFrameVisited = True;
    if flag:
        datarow = (str(int(30*(int(r[0])-int(firstTimestamp))/1000)),currentGesture)
#         print(datarow)
        videoframes[datarow[0]]=datarow[1]
#         videoframes.append(datarow)
        datarow_csv = ",".join(datarow)
        data.write(datarow_csv + '\n')
    count+=1
data.close()


directory = projectroot+"/training/"+pidentifier[:-4]
gestureclasses = ["lefthandlock", "righthandlock", "bothhandlock", "lefthandpinch", "righthandpinch", "bothhandpinch", "bothhandcover", "lefthandfist", "righthandfist", "bothhandfist", "upperlefthandlock", "upperrighthandlock", "upperbothhandlock", "birdhand"];
try:
    if not os.path.exists(directory):
        os.makedirs(directory)
        for gesturedir in gestureclasses:
            if not os.path.exists(directory+"/"+gesturedir):
                os.makedirs(directory+"/"+gesturedir)
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
            frame.save("../training/"+pidentifier[:-4]+"/"+videoframes[str(idx)][:-4]+"/"+pidentifier[:]+"_frame_"+str(idx)+".jpg")
            flag=False
 