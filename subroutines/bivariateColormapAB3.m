% JN Kather 2015, for license see separate file

function colorsNew = bivariateColormapAB3(colorFG,colorBG,nBins,method)

	% expects the following inputs:
    % colorFG = Hex code for foreground color, i.e. corner 1
    % colorBG = Hex code for background color, i.e. corner 3
    % corner 2 and 4 are black and white
    % nBins = x and y dimension of the resulting color map
    % varargin = if colors should be mixed in LAB rather than RGB space, an
    % argument 'lab' can be provided optionally
    
    % set up colors for corners of color map
    % convert input colors from Hex to RGB to CIELAB
    
    colW = (hex2rgb('FFFFFF')); 
    colBG = (hex2rgb(char(colorBG)));   
    colFG = (hex2rgb(char(colorFG)));
    colK = (hex2rgb('000000'));
    
    % prepare defined colors
    [X,Y] = meshgrid(0:1);
    V = zeros(2,2,3);
    
    for i=1:3
        V(:,:,i) = [colK(i),  colBG(i);                  
                    colFG(i),   colW(i)];
    end
     
    % prepare grid
    [Xq,Yq] = meshgrid(linspace(0,1,nBins));

    % rgb to lab
    V = rgb2lab(V);
  
    % preallocate color map
    colorsNew = zeros(nBins,nBins,3);
           
    % iterate through the three channels
    for i=1:3 % for L,a,b separately
        colorsNew(:,:,i) = interp2(X,Y,V(:,:,i),Xq,Yq,method);
    end
    
    % return color map as an RGB image
    colorsNew = lab2rgb(colorsNew);    

end