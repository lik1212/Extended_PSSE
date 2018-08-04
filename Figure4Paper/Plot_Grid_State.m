clear; close all;

Grid = 'S1a';  % 'S4b'

path_split  = strsplit(cd,'\');

load([strjoin(path_split(1:end-1),'\'),'\Comparison_Data\', Grid,'_de_NodeRes_raw_wo_TR.mat'  ]);
load([strjoin(path_split(1:end-1),'\'),'\Comparison_Data\', Grid,'_de_BranchRes_raw_wo_TR.mat']);

% Order in same way
NodeRes_all = sortrows(NodeRes_all,'Node_ID','ascend');
NodeRes_all = sortrows(NodeRes_all,'ResTime','ascend');

BranchRes_all = sortrows(BranchRes_all,'Terminal2_ID','ascend');
BranchRes_all = sortrows(BranchRes_all,'Terminal1_ID','ascend');
BranchRes_all = sortrows(BranchRes_all,'ResTime','ascend');

time_steps = 1:1440;

min_U1 = min(reshape(NodeRes_all.U1, [], numel(time_steps)))*10^3;
max_U1 = max(reshape(NodeRes_all.U1, [], numel(time_steps)))*10^3;
min_U2 = min(reshape(NodeRes_all.U2, [], numel(time_steps)))*10^3;
max_U2 = max(reshape(NodeRes_all.U2, [], numel(time_steps)))*10^3;
min_U3 = min(reshape(NodeRes_all.U3, [], numel(time_steps)))*10^3;
max_U3 = max(reshape(NodeRes_all.U3, [], numel(time_steps)))*10^3;
min_U = min([min_U1; min_U2; min_U3]);
max_U = max([max_U1; max_U2; max_U3]);
U_plot = plot([time_steps; time_steps], [min_U; max_U], 'Color', [0 0.4470 0.7410]);

U_plot(1).Parent.XLim = [0 1440];
U_plot(1).Parent.XTick = [0:240:1440]; %#ok<*NBRAK>
U_plot(1).Parent.XTickLabel = {'0:00','4:00','8:00','12:00','16:00','18:00','0:00'};
U_plot(1).Parent.Parent.Position(3) = 560*0.5;
U_plot(1).Parent.Parent.Position(4) = 420*0.5;
U_plot(1).Parent.FontName = 'Times New Roman';
U_plot(1).Parent.YLabel.String = 'Voltage in V';
U_plot(1).Parent.XLabel.String = 'Time';
U_plot(1).Parent.YGrid = 'on';
U_plot(1).Parent.XGrid = 'on';

BranchRes_all.I_sum = abs(...
    BranchRes_all.I1.*exp(1i*angle(BranchRes_all.P1 + 1i*BranchRes_all.Q1)) + ...
    BranchRes_all.I2.*exp(1i*angle(BranchRes_all.P2 + 1i*BranchRes_all.Q2)) + ...
    BranchRes_all.I3.*exp(1i*angle(BranchRes_all.P3 + 1i*BranchRes_all.Q3))   ...
    );

max_I = max(reshape(BranchRes_all.I_sum, [], numel(time_steps)))*10^3; 

figure
I_plot = plot(time_steps, max_I, 'Color', [0 0.4470 0.7410]);
I_plot(1).Parent.XLim = [0 1440];
I_plot(1).Parent.XTick = [0:240:1440];
I_plot(1).Parent.XTickLabel = {'0:00','4:00','8:00','12:00','16:00','18:00','0:00'};
I_plot(1).Parent.Parent.Position(3) = 560*0.5;
I_plot(1).Parent.Parent.Position(4) = 420*0.5;
I_plot(1).Parent.FontName = 'Times New Roman';
I_plot(1).Parent.YLabel.String = 'Current in A';
I_plot(1).Parent.XLabel.String = 'Time';
I_plot(1).Parent.YGrid = 'on';
I_plot(1).Parent.XGrid = 'on';

