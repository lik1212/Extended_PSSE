clear; close all;

Grid = 'S4b';
Case = '4';

path_split  = strsplit(cd,'\');

fig_numel = 1;
if ismember(Case, {'1', '2'})
    uiopen([strjoin(path_split(1:end),'\'),'\', Grid, '\', Grid, '_Case', Case, '_1Phase_standard_with_virtual.fig'],1)
    fig_numel = 2;
end
uiopen([strjoin(path_split(1:end),'\'),'\', Grid, '\', Grid, '_Case', Case, '_1Phase_Bext.fig'],1)

%%

for k = 1 : fig_numel
    fig(k) = figure(k);    
    fig(k).Children(1).FontName = 'Times New Roman'; %#ok<*SAGROW>
    fig(k).Children(2).FontName = 'Times New Roman';
    fig(k).Children(1).XLim = [0 1440];
    fig(k).Children(1).XTick = [0:240:1440];
    fig(k).Children(1).XTickLabel = {'','4:00','8:00','12:00','16:00','18:00','0:00'};
    fig(k).Children(1).YLabel.String = '{\it{I}} in A';
    fig(k).Children(2).YLabel.String = '{\it{U}} in V';
    fig(k).Children(2).XLim = [0 1440];
    fig(k).Children(2).XTick = [0:240:1440]; %#ok<*NBRAK>
    fig(k).Children(2).XTickLabel = {''};
    fig(k).Children(1).XLabel.String = 'Time';
    fig(k).Children(2).Parent.Position(3) = 560*0.5;
    fig(k).Children(2).Parent.Position(4) = 420*0.5;
    fig(k).Children(1).Position(2) = 0.16;
    fig(k).Children(1).XGrid = 'on';
    fig(k).Children(2).XGrid = 'on';
    fig(k).Children(1).YLabel.Position(1) = -130;   
    fig(k).Children(2).YLabel.Position(1) = -130;   
    for k_Line = 1 : numel(fig(k).Children(1).Children)
        fig(k).Children(1).Children(k_Line).Color = [0.8500 0.3250 0.0980];
    end
    if fig_numel == 1
        fig(k).Children(1).YLabel.Position(2) = mean(fig(k).Children(1).YLim);
        fig(k).Children(2).YLabel.Position(2) = mean(fig(k).Children(2).YLim);
    end
end

if fig_numel == 2
    for k = 1 : 2
        min_one = min([fig(1).Children(k).YLim(1); fig(2).Children(k).YLim(1)]);
        max_one = max([fig(1).Children(k).YLim(2); fig(2).Children(k).YLim(2)]);
        fig(1).Children(k).YLim = [min_one max_one];
        fig(2).Children(k).YLim = [min_one max_one];
        fig(1).Children(k).YLabel.Position(2) = mean([min_one max_one]);
        fig(2).Children(k).YLabel.Position(2) = mean([min_one max_one]);
%         fig(1).Children(k).YTick = fig(1).Children(k).YLim;
%         fig(2).Children(k).YTick = fig(2).Children(k).YLim;
    end
end
