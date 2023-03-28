import numpy as np
from PIL import Image

# Load image, make into Numpy array and average RGB channels
im = Image.open('twi.png').convert('RGB')
na = np.array(im)
grey = np.mean(na, axis=2).astype(np.uint8)
Image.fromarray(grey).save('twi01.png')   # DEBUG only

# Load colourmap
cmap = Image.open('twi02.png').convert('RGB')

# Make output image, same height and width as grey image, but 3-channel RGB
result = np.zeros((*grey.shape,3), dtype=np.uint8)

# Take entries from RGB colourmap according to greyscale values in image
np.take(cmap.getdata(), grey, axis=0, out=result)

# Save result
Image.fromarray(result).save('result.png')