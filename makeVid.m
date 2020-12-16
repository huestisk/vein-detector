function makeVid(fileName)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

% Parameters
sz = 9;
width = 4;
sigma = 0.5;
shift = (90/(sz-1));

% create the video writer with 1 fps
writerObj = VideoWriter(fileName);
writerObj.FrameRate = 2;

% open the video writer
open(writerObj);

% Make vid
for deg = 0:shift:180-shift
    
    mat = customStrel2(sz, width, sigma, deg, 'center');
    mat = imresize(mat,[512 512]);
    
    Min = min(mat(:));
    Max = max(mat(:));
    mat_norm = round(minus(mat, Min)*255/double(Max-Min));

    im = ind2rgb(mat_norm,colormap);
    
    % convert the image to a frame
    frame = im2frame(im);
    writeVideo(writerObj, frame);
end

% close the writer object
close(writerObj);

end

