function se = customStrel(len, range, sigma, theta_d)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here


if (len >= 1)
    % The line is constructed so that it is always symmetric with respect
    % to the origin. Theta is mod(180) to return consistent angles for
    % inputs that are outside the [0, 180] range.
    
    theta = mod(theta_d, 180) * pi / 180;
    shift = deg2rad(90/(len-1));

    line = zeros(len);
    for deg = theta-range:shift:theta+range
        
        x = ceil((len-1)/2 * cos(deg));
        y = -ceil((len-1)/2 * sin(deg));

        [c,r] = iptui.intline(-x,x,-y,y);

        y_diff = len - (2*max(abs(r)) + 1);
        x_diff = len - (2*max(abs(c)) + 1);
        
        y_ind = r + max(abs(r)) + 1 + round(y_diff/2);
        x_ind = c + max(abs(c)) + 1 + round(x_diff/2);

        idx = sub2ind([len len], y_ind, x_ind);

        line(idx) = line(idx) + 1;
    end
else
    % Do nothing here, which effectively returns the empty strel.
    return
end

% overlay gaussian
se = fspecial('gaussian', len, sigma) .* line;

% Normalize
se = se / sum(se(:));

end

