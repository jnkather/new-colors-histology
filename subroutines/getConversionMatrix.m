% JN Kather 2015, for license see separate file

function [HDABtoRGB,RGBtoHDAB] = getConversionMatrix(style,varargin)
% style has to be one of the following options:
% 'Fiji', 'scikit', 'orthogonal', 'optimal', 'HE-optimal', 'Pappen-optimal'
% 2nd input parameter can be the image itself (or a subsampled version of
% the image or a cropped part of the image) which will be used to compute
% optimal deconvolution vectors if style = 'optimal'

    if strcmp(style,'Fiji')
        % set of standard values for stain vectors from Fiji
        % http://fiji.sc/Fiji
        He =  [ 0.6500286,   0.704031,    0.2860126 ]; % Hematoxylin
        DAB = [ 0.26814753,  0.57031375,  0.77642715]; % DAB
        Res = [ 0.7110272,   0.42318153,  0.5615672 ]; % Residual

    elseif strcmp(style,'scikit')
        % set of standard values for stain vectors from python scikit
        % http://scikit-image.org
        % essentially the same as 'Fiji'
        He = [0.65, 0.70, 0.29];    % Hematoxylin
        DAB = [0.27, 0.57, 0.78];   % DAB
        Res = [0.07, 0.99, 0.11];   % Eosin channel = residual in H DAB

    elseif strcmp(style,'Ruifrok')
        % set of standard values for stain vectors from Ruifrok et al.
        % (http://www.ncbi.nlm.nih.gov/pubmed/11531144)
        He = [0.18, 0.20, 0.08];    % Hematoxylin
        DAB = [0.10, 0.21, 0.29];   % DAB
        Res = [0.01, 0.13, 0.01];   % Eosin channel = residual in H DAB

    elseif strcmp(style,'Pappenheim')
        % Pappenheim staining for blood smears. To do: change variable
        % names. Source for vectors: Fiji (http://fiji.sc/Fiji)
        He = [0.8351288, 0.5137892, 0.19641943];    % Red
        DAB = [0.09283128, 0.9545457, 0.28324];     % Blue
        Res = [0.50013447, 0.001, 0.8659477];       % Residual

    elseif strcmp(style,'RGB')
        % for testing purposes
        He = [0, 1, 1];    % Red
        DAB = [1, 0, 1];   % Green
        Res = [1, 1, 0];   % Blue

    elseif strcmp(style,'orthogonal')
        % modified set of standard values for stain vectors from Fiji:
        % Residual vector is perpendicular to He and DAB. Yields the
        % same deconvolution result as the native Fiji vector.

        He =  [ 0.6500286,   0.704031,    0.2860126 ]; % Hematoxylin
        DAB = [ 0.26814753,  0.57031375,  0.77642715]; % DAB
        Res = cross(He, DAB); % Residual

    elseif strcmp(style,'Pappen-optimal') || strcmp(style,'optimal') ...
            || strcmp(style,'HE-optimal')
        % calculate optimal vector by projecting Fiji standard vectors on
        % the plane defined by the first two principal components of the
        % pixel data in OD space and the origin.

        imageRGB = varargin{1};

        if strcmp(style,'Pappen-optimal') % for Giemsa staining
        % start with standard values from Fiji
        He = [0.8351288, 0.5137892, 0.19641943];  % Red
        DAB = [0.09283128, 0.9545457, 0.28324];   % Blue

        elseif strcmp(style,'HE-optimal') % for Hematoxylin/Eosin staining
        % start with standard values from Ruifrok
         He = [0.64, 0.72, 0.27];    % He
         DAB = [0.09, 0.95, 0.28];   % Eo
        
        elseif strcmp(style,'optimal') % for Hematoxylin/DAB staining
        % start with standard values from Ruifrok
         He = [0.18, 0.20, 0.08];    % Hematoxylin
         DAB = [0.10, 0.21, 0.29];   % DAB
        end

        % convert RGB image to OD
        imageOD = -log(double(imageRGB)+2);
        imagePixelsOD = reshape(imageOD,[],3);
        imagePixelsOD = normalizeImage(imagePixelsOD,'no-stretch');

        % perform PCA of OD pixels
        coeffOD = pca(imagePixelsOD);
        coeffOD = coeffOD';

        He = projectOnPlane(He,cross(coeffOD(1,:),coeffOD(2,:)),zeros(1,3));
        DAB = projectOnPlane(DAB,cross(coeffOD(1,:),coeffOD(2,:)),zeros(1,3));

        Res = cross(He, DAB); % Residual

    else
        error('no valid style');
    end

    % combine stain vectors to deconvolution and reconvolution matrix
    HDABtoRGB = [He/norm(He); DAB/norm(DAB); Res/norm(Res)];
    RGBtoHDAB = inv(HDABtoRGB);

end
