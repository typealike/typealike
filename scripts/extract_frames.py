import av
import os
import sys

pidentifier = sys.argv[1]
projectroot = "/Users/nalinc/Projects/typealike"
directory = projectroot+"/training/"+pidentifier[:-4]
postureclasses = ["typing"]
try:
    if not os.path.exists(directory):
        os.makedirs(directory)
        for posturedir in postureclasses:
            if not os.path.exists(directory+"/"+posturedir):
                os.makedirs(directory+"/"+posturedir)
except OSError:
    print ('Error: Creating directory. ' +  directory)


videofile = projectroot+"/videos/one/"+pidentifier[:-4]+".mp4"
container = av.open(videofile)
for packet in container.demux():
    for frame in packet.decode():
        # frame.to_image().save(base+'/frame-%04d.jpg'%frame.index)
        frame.to_image().save("../training/"+pidentifier[:-4]+"/typing/"+pidentifier[:]+"_frame_"+str(frame.index)+".jpg")
