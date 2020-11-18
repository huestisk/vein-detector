% Load image
ids = [14, 25, 34];
im = imread(strcat('data/', string(ids(1)), '.png'));

% Convert
im_gray = rgb2gray(im);
im_size = size(im_gray);

% Remove background
threshold = 50;
foreground = im_gray > threshold;
fore_smooth = imclose(foreground, strel('disk', 3));

im_crop = im_gray .* uint8(fore_smooth); % crop

% Canny algorithms
lines = edge(im_crop,'canny',[0.005 0.05]);
overlay = imoverlay(im_gray, lines, 'red');

% dilate - along lines
im_close = lines;
dim = 2;

for i = 1:2*(dim-1)
    
    se = zeros(dim);
    if i <= dim
        se(1, i) = 1;
        se(dim, dim+1-i) = 1;
    else
        se(i+1-dim, dim) = 1;
        se(2*dim-i, 1) = 1;        
    end
    
    im_close = imclose(im_close, se);
end

% imshowpair(lines, im_close, 'montage')

% Select veins
min_len = 65;

veins = false(im_size);
for region = bwconncomp(im_close).PixelIdxList

    if numel(region{1}) < min_len
        continue
    end
    
    [y, x] = ind2sub(im_size, region{1});
    
    for i = 1:size(x,1)
        veins(y(i), x(i)) = 1;
    end
    
%     hold off, imshow(lines), hold on   
%     plot(x, y, 'xr'), pause(0.1)
end

% % Visualize
% fig1 = figure;
% imshow(im_crop), title('Gray, Cropped'), hold on
% imwrite(im_crop, strcat("output/", string(ids(1)), "gray.png"), 'png')
% 
% fig2 = figure;
% imshow(overlay), title('Canny lines'), hold on
% imwrite(overlay, strcat("output/", string(ids(1)), "canny.png"), 'png')

%big cheating here :)

mask = ones(im_size);
mask(1:15,:) = 0;
mask(370:end,:) = 0;
mask(:,1:45) = 0;
mask(:,160:end) = 0;

veins = veins .* mask;
im_veins = imoverlay(im_gray, veins, 'blue');
imshow(im_veins)



fig3 = figure;
imshow(im_veins), title('Vein Detection'), hold on
imwrite(im_veins, strcat("output/", string(ids(1)), "veins.png"), 'png')

% % % Other methods
% lines = [];
% lines(:,:,end+1) = edge(im,'sobel');
% lines(:,:,end+1) = edge(im,'prewitt');
% lines(:,:,end+1) = edge(im,'roberts');
% lines(:,:,end+1) = edge(im,'log');
% lines(:,:,end+1) = edge(im,'zerocross');
% lines(:,:,end+1) = edge(im,'canny'); % best
% lines(:,:,end+1) = edge(im,'approxcanny');

% for i = 1:size(lines,3)
%     
%    figure
%    imshow(lines(:,:,i))
%     
% end

% % % Convert to images
% vid = read('vid.mpa'); % load video
% for i = 1:size(vid, 4)
%     frame = vid(:,:,:,i); 
%     imwrite(frame, strcat(string(i), ".png"), 'png')
% end