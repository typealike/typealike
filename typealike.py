from __future__ import print_function, unicode_literals

import tensorflow as tf
import numpy as np
import scipy.misc
import matplotlib.pyplot as plt
import matplotlib.image as mpimg
import os
from mpl_toolkits.mplot3d import Axes3D
import argparse
import cv2
import operator
import pickle

from nets.ColorHandPose3DNetwork import ColorHandPose3DNetwork
from utils.general import detect_keypoints, trafo_coords, plot_hand, plot_hand_2d, plot_hand_3d

if __name__ == '__main__':
	w = 320
	h = 240
	# Get pointer to video frames from primary device
	camera = cv2.VideoCapture(0)
	camera.set(cv2.CAP_PROP_FPS, 10)
	camera.set(cv2.CAP_PROP_FRAME_WIDTH, w)
	camera.set(cv2.CAP_PROP_FRAME_HEIGHT, h)
	# network input
	image_tf = tf.placeholder(tf.float32, shape = (1, 240, 320, 3))
	hand_side_tf = tf.constant([[1.0, 1.0]])
	evaluation = tf.placeholder_with_default(True, shape = ())

	# build network
	net = ColorHandPose3DNetwork()
	hand_scoremap_tf, image_crop_tf, scale_tf, center_tf,\
		keypoints_scoremap_tf, keypoint_coord3d_tf = net.inference(image_tf, hand_side_tf, evaluation)

	# Start TF
	gpu_options = tf.GPUOptions(per_process_gpu_memory_fraction=0.8)
	sess = tf.Session(config=tf.ConfigProto(gpu_options=gpu_options))

	# initialize network
	net.init(sess)
	while True:
		# Capture frame-by-frame
		ret, frame = camera.read()
		rgb_frame = cv2.cvtColor(frame,cv2.COLOR_BGR2RGB)
		# rgb_frame = 
		image_raw = cv2.resize(rgb_frame, (w, h))
		image_v = np.expand_dims((image_raw.astype('float') / 255.0) - 0.5, 0)
		
		print("check-1")
		scale_v, center_v, keypoints_scoremap_v, \
			keypoint_coord3d_v = sess.run([scale_tf, center_tf, keypoints_scoremap_tf,\
										keypoint_coord3d_tf], feed_dict = {image_tf: image_v})
		print("check-2")
		keypoints_scoremap_v = np.squeeze(keypoints_scoremap_v)
		# keypoint_coord3d_v = np.squeeze(keypoint_coord3d_v)
		print("check-3")
		# post processing
		coord_hw_crop = detect_keypoints(np.squeeze(keypoints_scoremap_v))
		print("check-4")
		coord_hw = trafo_coords(coord_hw_crop, center_v, scale_v, 256)
		print("check-5")
		plot_hand_2d(coord_hw, image_raw)
		print("check-6")
		# else:
		# keypoint_coord3d_v = sess.run(keypoint_coord3d_tf, feed_dict = {image_tf: image_v})

		bgr_frame = cv2.cvtColor(image_raw,cv2.COLOR_RGB2BGR)
		cv2.imshow('camera', bgr_frame)
		if cv2.waitKey(5) == 27:
			break
	cv2.destroyAllWindows()
	camera.release()
