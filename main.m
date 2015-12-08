% Copyright (c) 2015, Jakob Nikolas Kather. 
% 
% Please cite our publication:
% "New colors for histology: optimized bivariate color maps increase 
% perceptual contrast in histological images", PLOS One, 2015
% 
% Permission is hereby granted, free of charge, to any person obtaining a copy
% of this software and associated documentation files (the "Software"), to deal
% in the Software without restriction, including without limitation the rights
% to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
% copies of the Software, and to permit persons to whom the Software is
% furnished to do so, subject to the following conditions:
% 
% The above copyright notice and this permission notice shall be included in
% all copies or substantial portions of the Software.
% 
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
% IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
% FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
% AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
% LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
% OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
% THE SOFTWARE.
%

% -- initialize program
close all; format compact; clc; 

% -- add toolboxes to current path
addpath([pwd,'/subroutines'],'-end'); % my own subroutines

% -- set constants
imdir = 'input/';        % folder containing the input images
nBinsCoarse = 10;        % between 10 and 50. higher = takes longer
nBinsFine = 10;          % between 10 and 50.  higher = takes longer
interpolType = 'linear'; % default "linear"
convType = 'HE-optimal'; % default for HE images: "HE-optimal"
                         % default for H-DAB images: "optimal"
cmap_FG = 'FFAD00';      % default: FFAD00 alternative: F0000
cmap_BG = '006EFF';      % default: 006EFF alternative: 0093FF
imgResolution = '-r300'; % resolution of resulting images, e.g. "-r300"
saveOutput = true;       % save output? default true
saveDir = 'output/';     % output directory

% iterate through set of sample images and re-stain each of them
for fnames = {'Sample001_1500px.tiff','Sample002_1500px.tiff',...
              'Sample003_1200px.tiff','Sample004_1200px.tiff'} 
             % fnames has to be a cell array containing the filenames
             % caution: depending on which type of staining these images
             % represent, the parameter "convType" has to be changed. For
             % example, for "Tumor_CD31_HiRes.png" (H-DAB image), convType
             % should be "optimal", while for "Sample001_1500px.tiff"
             % (H&E image), convType should be "HE-optimal". For Giemsa
             % stained images, convType should be "Pappen-optimal"
          
% ---
img_fname = char(fnames); % convert current filename to char
imageRGB = imread(strcat(imdir,img_fname)); % read current image

% re-stain image
[ imageNEW, colorsFine, colorsFineNew ] = reColorImage(...
    convType,imageRGB,nBinsCoarse,nBinsFine,interpolType, cmap_FG, cmap_BG);

% -- show results
figure();
subplot(1,2,1);   imshow(imageRGB);  title('Original image');
subplot(1,2,2);   imshow(imageNEW);  title('Re-stained image');

% decorations
set(gcf,'Color','w');  
setSubplotLabel(gcf,{'A','B'});

% save result
if saveOutput
    print(gcf,[saveDir, img_fname,'-IMGS.png'],'-dpng',imgResolution);
end

% -- show color maps
figure(); 
subplot(1,2,1);   image(autoflip(colorsFine)); title('Original color map');
axis off equal tight;
subplot(1,2,2);   image(autoflip(colorsFineNew));  title('New color map');
axis off equal tight;

% decorations
set(gcf,'Color','w');
setSubplotLabel(gcf,{'C','D'});

% save result
if saveOutput
    print(gcf,[saveDir, img_fname ,'-CMAP.png'],'-dpng',imgResolution);
end

end % end iterate through files
