import os 
import time

def main(): 
	i = 0
	folder = "gray"
	for filename in os.listdir(folder): 
		# dst ="Hostel" + str(i) + ".jpg"
		src =folder +"/"+ filename 
		dst = folder +"/"+ str(i%120) + ".jpg"
		print(src, "\t", dst)
		# rename() function will 
		# rename all the files 
		os.rename(src, dst) 
		i += 1

# Driver Code 
if __name__ == '__main__': 
	# Calling main() function 
	main() 