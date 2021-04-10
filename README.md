# Vein Detector

### open ssh connection
ssh -X pi@<raspberry's ip>
password

### take images on raspberry pi
raspistill -r -o ir_image.jpg
raspivid -o vid.h264

### move files across ssh
scp pi@<raspberry's ip>:/home/pi/ir_image2.jpg /Users/kevinhuestis/Desktop/ir_image2.jpg

## open tcp connection
### on mac
python server.py <computer-ip> 3333

### on raspberry pi
python client.py <computer-ip> 3333

wlan0: static ip: 192.168.1.123
