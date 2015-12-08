% JN Kather 2015, for license see separate file

% this is an implementation of Ruifrok's color deconvolution
% see http://www.ncbi.nlm.nih.gov/pubmed/11531144

function imageOut = SeparateStains(imageRGB, Matrix, varargin)

    % convert input image to double precision float
    imageRGB = double(imageRGB);

    % avoid log artifacts
    imageRGB = imageRGB + 2; % this is how scikit does it
    % imageRGB(imageRGB == 0) = 0.001; % this is how Fiji does it

    % perform color deconvolution: convert to OD then matrix multiplication
    imageOut = reshape(-log(imageRGB),[],3) * Matrix;
    imageOut = reshape(imageOut, size(imageRGB));     % reconstruct image

    % post-processing
    if nargin>2
        normalizeArgument = varargin{1};
    else
        normalizeArgument = 'stretch'; % default is 'stretch'
    end

    imageOut = normalizeImage(imageOut,normalizeArgument);    % normalize histogram
    imageOut = 1 - imageOut; % invert image
end
