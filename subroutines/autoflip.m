% JN Kather 2015, for license see separate file

function imgRGB  = autoflip( imgRGB )
% flips 3-channel (RGB) image diagonally
    for i=1:size(imgRGB,3)
        imgRGB(:,:,i) = fliplr(imgRGB(:,:,i)');
    end
end

