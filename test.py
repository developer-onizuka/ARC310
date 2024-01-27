import numpy as np
import sys

import tensorflow as tf

# Conv + ReLU activation + Bias
N = 1
num_channel = 3
input_width, input_height = (5, 5)
filter_width, filter_height = (2, 2)

x = np.random.rand(N, input_width, input_height, num_channel).astype(np.float32)
weight = np.random.rand(filter_width, filter_height, num_channel, num_channel).astype(np.float32)
bias = np.random.rand(num_channel).astype(np.float32)

conv = tf.nn.conv2d(x, weight, strides=[1, 1, 1, 1], padding='SAME')
activation = tf.nn.relu(conv)
result = tf.nn.bias_add(activation, bias)

print(result)
print('Finished')
