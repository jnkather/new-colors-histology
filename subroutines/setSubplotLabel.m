% JN Kather 2015, for license see separate file

function setSubplotLabel( FigHandle, Titles)

% this function adds letters (A, B, C, ...) as large titles to all subplots
% in the figure FigHandle

% convert input argument
Titles = fliplr(Titles);

% get all subplots in figure
allAxes = findall(FigHandle,'type','axes'); 

try
    % more than 1 axes
    axPos = cell2mat(get(allAxes,'Position'));
catch
    % just 1 axes
    axPos = get(allAxes,'Position');
end

% sort subplots by position
[~, idx] = sortrows(axPos,1);

    % iterate through all subplots
    for i=idx' %numel(allAxes)
        % make axis current
        set(FigHandle, 'currentaxes', allAxes(i)); 
        % get old title
        oldTitle=get(get(allAxes(i),'Title'),'String');
        % prepare new title
        titleStr = strcat('\fontsize{12} ', char(Titles(i)), 10, ...
            '\fontsize{8} ', char(oldTitle));
        % set new title
        title(titleStr,'interpreter','tex'); 
    end
   
end

