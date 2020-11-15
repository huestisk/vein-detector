import io
import sys
import cv2
import socket
import struct
import numpy as np
from PIL import Image

sock = socket.socket()
sock.bind((sys.argv[1], int(sys.argv[2])))  
sock.listen(0)
print("Listening")
conn = sock.accept()[0].makefile('rb')

try:
    # img = None
    img_array = []
    capture = True
    while True:
        image_len = struct.unpack('<L', conn.read(struct.calcsize('<L')))[0]
        if not image_len:
            break
        
        image_stream = io.BytesIO()
        image_stream.write(conn.read(image_len))
        image_stream.seek(0)
        image = Image.open(image_stream)
        
        im = cv2.cvtColor(np.array(image), cv2.COLOR_RGB2BGR)
        cv2.imshow('Video',im)
        
        if capture:
            img_array.append(im)

        if cv2.waitKey(1) & 0xFF == ord('q'):
           break
        # elif cv2.waitKey(1) & 0xFF == ord('s'):
        #     capture=True
        #     height, width, layers = im.shape
        #     size = (width, height)

        height, width, layers = im.shape
        size = (width, height)

    cv2.destroyAllWindows()

    if capture:
        out = cv2.VideoWriter('vid.mp4',cv2.VideoWriter_fourcc(*'mp4v'), 5.0, size)
    
        for i in range(len(img_array)):
            out.write(img_array[i])
        out.release()

finally:
    conn.close()
    sock.close()