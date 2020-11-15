# open ssh connection
ssh -X kevinhuestis@169.254.107.93
password

# take images on raspberry pi
raspistill -v -o ir_image.jpg
raspivid -o vid.h264

# move files across ssh
scp pi@169.254.107.93:/home/pi/ir_image2.jpg /Users/kevinhuestis/Desktop/ir_image2.jpg

## open tcp connection
# on mac
python server.py 169.254.170.3 3333

# on raspberry pi
python client.py 169.254.170.3 3333