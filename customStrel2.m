function se = customStrel2(sz, width, sigma, theta, varargin)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

method = 'standard';

if ~isempty(varargin)
    method = varargin{1};
end

if (sz>width+1)
    if mod(width,2)==1
        se = zeros(sz);
        for sign = [-1,1]
            idx = get_line_idx(sz, width, theta, sign);
            se(idx) = 1;
        end
    else
        sz = sz+2;
        se = zeros(sz);
        width = width+1;
        for sign = [-1,1,0]
            idx = get_line_idx(sz, width, theta, sign);
            
            % Remove middle lines
            if sign==0
                se(idx) = [];
                if (max(idx)-min(idx))>(sz-2)*10
                    se = reshape(se, sz-1, []);
                    se(:,sz) = [];
                else
                    se = reshape(se, [], sz-1);
                    se(sz,:) = [];
                end
            else
                % Set values to 1
                se(idx) = 1;
            end
        end        
    end
    
    % Overlay gaussian
    se = imgaussfilt(se, sigma);

    % Normalize
    switch lower(method)
        case 'standard'
            se = se / sum(se(:));
        case 'center'
            se = (se-mean(se(:))) / sum(se(:));
    end
else
    % Change size
    sz = width + 1;
    se = customStrel2(sz, width, sigma, theta); 
end

end

function idx = get_line_idx(sz, width, theta, sign)

    % Get line
    x = round(sz*cosd(theta));
    y = -round(sz*sind(theta));
    [c,r] = iptui.intline(-x,x,-y,y);
    
    % Compute matrix difference
    y_diff = round((sz-(2*max(abs(r))+1))/2);
    x_diff = round((sz-(2*max(abs(c))+1))/2);

    % Compute shift
    y_shift = sign * ceil((width/2) * cosd(theta));
    x_shift = sign * ceil((width/2) * sind(theta));
    
    % Get indices
    y_ind = r + max(abs(r)) + 1 + y_diff + y_shift;
    x_ind = c + max(abs(c)) + 1 + x_diff + + x_shift;

    % Remove excess indices
    rm_idx = (x_ind<=0 | y_ind<=0 | x_ind>sz | y_ind>sz);
    y_ind(rm_idx) = [];
    x_ind(rm_idx) = [];
    
    % Convert to array indices
    idx = sub2ind([sz sz], y_ind, x_ind);
end





