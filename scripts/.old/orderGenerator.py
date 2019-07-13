import random
from collections import Iterable
from random import shuffle


def flatten(items):
    """Yield items from any nested iterable; see Reference."""
    for x in items:
        if isinstance(x, Iterable) and not isinstance(x, (str, bytes)):
            for sub_x in flatten(x):
                yield sub_x
        else:
            yield x

postureModeSwitchCount = [0,0,0]
shortcutModeSwitchCount = [0,0,0]
actionCount = [0,0,0]
postureModeSwitchDict={0:("word","posture"),1:("click","posture"),2:("equation","posture")}

shortcutModeSwitchDict={0:("word","shortcut"),1:("click","shortcut"),2:("equation","shortcut")}

actionsDict={0:"word",1:"click",2:"equation"}

nBlocks = 3
nSequences = 14

blocks=[]




for i in range(nBlocks):
	
	sequenceSet=[]
	for j in range(nSequences):
		sequences=[]
		index_a = random.randint(0,2)
		# if(postureModeSwitchCount[index_a]+1!=15):
		# 	postureModeSwitchCount[index_a]+=1
		if(postureModeSwitchCount[index_a]+1==15):
			if(index_a==0):
				if(postureModeSwitchCount[1]+1!=15):
					index_a = 1
				elif(postureModeSwitchCount[2]+1!=15):
					index_a = 2
			elif (index_a==1):
				if(postureModeSwitchCount[2]+1!=15):
					index_a = 2
				elif(postureModeSwitchCount[0]+1!=15):
					index_a = 0
			elif (index_a==2):
				if(postureModeSwitchCount[0]+1!=15):
					index_a = 0
				elif(postureModeSwitchCount[1]+1!=15):
					index_a = 1
		
		postureModeSwitchCount[index_a]+=1
		sequences.append(postureModeSwitchDict[index_a])

		index_b = random.randint(0,2)
		if(shortcutModeSwitchCount[index_b]+1==15):
			if(index_b==0):
				if(shortcutModeSwitchCount[1]+1!=15):
					index_b = 1
				elif(shortcutModeSwitchCount[2]+1!=15):
					index_b = 2
			elif (index_b==1):
				if(shortcutModeSwitchCount[2]+1!=15):
					index_b = 2
				elif(shortcutModeSwitchCount[0]+1!=15):
					index_b = 0
			elif (index_b==2):
				if(shortcutModeSwitchCount[0]+1!=15):
					index_b = 0
				elif(shortcutModeSwitchCount[1]+1!=15):
					index_b = 1

		shortcutModeSwitchCount[index_b]+=1
		sequences.append(shortcutModeSwitchDict[index_b])

		index_c = random.randint(0,2)
		if(actionCount[index_c]+1==15):
			if(index_c==0):
				if(actionCount[1]+1!=15):
					index_c = 1
				elif(actionCount[2]+1!=15):
					index_c = 2
			elif (index_c==1):
				if(actionCount[2]+1!=15):
					index_c = 2
				elif(actionCount[0]+1!=15):
					index_c = 0
			elif (index_c==2):
				if(actionCount[0]+1!=15):
					index_c = 0
				elif(actionCount[1]+1!=15):
					index_c = 1

		print("iteration: "+str(j) +"\t"+str(actionCount))
		actionCount[index_c]+=1
		sequences.append(actionsDict[index_c])
		# s = sequences
		print(sequences)
		shuffle(sequences) # shuffle the sequence
		a = list(flatten(sequences)) # flatten the list
		sequenceSet.append(a)
	blocks.append(sequenceSet)


print(blocks)