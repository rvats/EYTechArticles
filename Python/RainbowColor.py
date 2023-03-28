import cv2

image = cv2.imread('twi.png', 0)
# Applying Simple Color Gradients
newImage = cv2.applyColorMap(image, cv2.COLORMAP_AUTUMN)

'''
newImage = cv2.applyColorMap(newImage, cv2.COLORMAP_PINK)
newImage = cv2.applyColorMap(newImage, cv2.COLORMAP_BONE)
newImage = cv2.applyColorMap(newImage, cv2.COLORMAP_WINTER)
newImage = cv2.applyColorMap(newImage, cv2.COLORMAP_OCEAN)
newImage = cv2.applyColorMap(newImage, cv2.COLORMAP_SUMMER)
newImage = cv2.applyColorMap(newImage, cv2.COLORMAP_SPRING)
newImage = cv2.applyColorMap(newImage, cv2.COLORMAP_COOL)

# Applying Multi Color Gradients
newImage = cv2.applyColorMap(newImage, cv2.COLORMAP_HOT)
newImage = cv2.applyColorMap(newImage, cv2.COLORMAP_JET)
newImage = cv2.applyColorMap(newImage, cv2.COLORMAP_RAINBOW)
newImage = cv2.applyColorMap(newImage, cv2.COLORMAP_HSV)
'''
cv2.imwrite('twinew1.png',newImage)
print("Image Saved...")
