import PIL
from PIL import Image
import math

def resize_img(img, w):
	basewidth = w
	wpercent = (basewidth / float(img.size[0]))
	hsize = int((float(img.size[1]) * float(wpercent)))
	return img.resize((basewidth, hsize), PIL.Image.ANTIALIAS)

if __name__ == '__main__':

	folder_index = ['gray','green']
	nrows = 10
	# target_width = 100 #56
	target_width = 50 #28
	total_width = 1200 
	max_height = 28*nrows

	new_im = Image.new('RGB', (total_width, max_height))
	x_offset = 0
	y_offset = 0
	counter = 0
	for i in range(nrows*int(total_width/target_width)+1):
		if y_offset == 0:
			if i%2 == 0:
				folder = folder_index[1]
			else:
				folder = folder_index[0]
		else:
			folder = folder_index[math.floor((i+counter)%2)]
		# if i%2 ==0:
		# 	folder = folder_index[0]
		# else:
		# 	folder = folder_index[1]
		img = Image.open(folder+'/'+str(i%120)+'.jpg')
		resized_img = resize_img(img, target_width)
		
		new_im.paste(resized_img, (x_offset,y_offset))
		img.close()
		# print(resized_img.size[1])
		x_offset += resized_img.size[0]
		if i != 0 and i%int(total_width/target_width) == 0:
		# if i != 0 and i%12 == 0:
			x_offset = 0
			y_offset += resized_img.size[1]
			counter = 1 if counter == 0 else 0
			print(counter) 

	new_im.save('dataset.png')