import cv2
import numpy as np
import matplotlib.pyplot as plt

lenna = cv2.imread('lenna.jpg',cv2.IMREAD_GRAYSCALE)

percent = range(5,51,5)

thr_lenna = []

for p in percent:

    thr = np.percentile(lenna,p)
    _,thresholded = cv2.threshold(lenna,thr,255,cv2.THRESH_BINARY)
    thr_lenna.append(thresholded)

plt.figure(figsize=(12,6))

for i,thresholded in enumerate(thr_lenna):
    plt.subplot(2,5,i+1)
    plt.imshow(thresholded,cmap='gray')
    plt.title("{}% of coeffs kept".format(float(percent[i])))
    plt.axis('off')

plt.tight_layout()
plt.show()