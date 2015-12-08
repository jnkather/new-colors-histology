% JN Kather 2015, for license see separate file

function [ imageNEW, colorsFine, colorsFineNew ] = ...
reColorImage( convType,imageRGB,nBinsCoarse,nBinsFine,interpolType, ...
cmap_FG, cmap_BG)

    % prepare and perform color deconvolution
    [~,RGBtoHDAB] = getConversionMatrix(convType,imageRGB);
    % separate stains = perform color deconvolution
    imageHDAB = SeparateStains(imageRGB, RGBtoHDAB);

    % analyze image
    imgSize = size(imageRGB);

    % make all 2D arrays 1D: H D R G B
    Hdata = reshape(imageHDAB(:,:,1),[],1);
    DABdata = reshape(imageHDAB(:,:,2),[],1);
    imageRGB = double(imageRGB)/255;
    origImg = reshape(imageRGB,[],3);

    % calculate histograms from point coordinates and pixel colors
    [~, colorsOriginal] = coords2hist(Hdata,DABdata,origImg,nBinsCoarse);
   
    % prepare for plot and plot results
    [Xcoarse,Ycoarse] = meshgrid(linspace(0,1,nBinsCoarse+1));
    [Xfine,Yfine] = meshgrid(linspace(0,1,nBinsFine));
    
    %% create alternative colormap
    colorsNew = bivariateColormapAB3(cmap_FG,cmap_BG,nBinsCoarse+1,interpolType);
    
    % interpolate original 2D colormap and reconstruct pixel colors
    colorsFine(:,:,1) = interp2(Xcoarse,Ycoarse,colorsOriginal(:,:,1),Xfine,Yfine,'spline');
    colorsFine(:,:,2) = interp2(Xcoarse,Ycoarse,colorsOriginal(:,:,2),Xfine,Yfine,'spline');
    colorsFine(:,:,3) = interp2(Xcoarse,Ycoarse,colorsOriginal(:,:,3),Xfine,Yfine,'spline');

    % interpolate new 2D colormap and reconstruct pixel colors
    colorsFineNew(:,:,1) = interp2(Xcoarse,Ycoarse,colorsNew(:,:,1),Xfine,Yfine,'spline');
    colorsFineNew(:,:,2) = interp2(Xcoarse,Ycoarse,colorsNew(:,:,2),Xfine,Yfine,'spline');
    colorsFineNew(:,:,3) = interp2(Xcoarse,Ycoarse,colorsNew(:,:,3),Xfine,Yfine,'spline');

    %% re-create image by getting color values from the original
    newImg = zeros(size(origImg));

    tic
    cmap = reshape(colorsFineNew,[],3);
    for i=1:numel(Xfine)
        idX = (abs(DABdata-Xfine(i)) < 1/nBinsFine);
        idY = (abs(Hdata-Yfine(i)) < 1/nBinsFine);
        % plot(DABdata(idX & idY),Hdata(idX & idY),'.','Color',cmap(i,:))
        newImg(idX & idY,:) = repmat(cmap(i,:),sum(idX & idY),1);
        % disp(['Progress: ', num2str(i/numel(Xfine)*100), '%']);
    end
    % scatter(DABdata,Hdata,10,reshape(newImg,[],3),'filled');
    toc

    % create new image
    imageNEW = reshape(newImg,imgSize(1),imgSize(2),3);
end

