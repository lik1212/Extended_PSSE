function plot_comparison(NodeRes_all_estim, BranchRes_all_estim, NodeRes_all_exakt, BranchRes_all_exakt, time_steps)
%PLOT_COMPARISON A changing function for comparing data, for this reason,
%no detailt explanation.

% Author(s): R. Brandalik 

%% Main


NodeRes_all_exakt  (~ismember(NodeRes_all_exakt  .ResTime, time_steps),:) = [];
BranchRes_all_exakt(~ismember(BranchRes_all_exakt.ResTime, time_steps),:) = [];

% Order in same way
NodeRes_all_estim = sortrows(NodeRes_all_estim,'Node_ID','ascend');
NodeRes_all_estim = sortrows(NodeRes_all_estim,'ResTime','ascend');

NodeRes_all_exakt = sortrows(NodeRes_all_exakt,'Node_ID','ascend');
NodeRes_all_exakt = sortrows(NodeRes_all_exakt,'ResTime','ascend');

BranchRes_all_estim = sortrows(BranchRes_all_estim,'Terminal2_ID','ascend');
BranchRes_all_estim = sortrows(BranchRes_all_estim,'Terminal1_ID','ascend');
BranchRes_all_estim = sortrows(BranchRes_all_estim,'ResTime','ascend');

BranchRes_all_exakt = sortrows(BranchRes_all_exakt,'Terminal2_ID','ascend');
BranchRes_all_exakt = sortrows(BranchRes_all_exakt,'Terminal1_ID','ascend');
BranchRes_all_exakt = sortrows(BranchRes_all_exakt,'ResTime','ascend');

% For plots preperation

min_diff_U1 = min(reshape(NodeRes_all_estim.U1, [], numel(time_steps)) - reshape(NodeRes_all_exakt.U1, [], numel(time_steps)))*10^3;
max_diff_U1 = max(reshape(NodeRes_all_estim.U1, [], numel(time_steps)) - reshape(NodeRes_all_exakt.U1, [], numel(time_steps)))*10^3;

min_diff_U2 = min(reshape(NodeRes_all_estim.U2, [], numel(time_steps)) - reshape(NodeRes_all_exakt.U2, [], numel(time_steps)))*10^3;
max_diff_U2 = max(reshape(NodeRes_all_estim.U2, [], numel(time_steps)) - reshape(NodeRes_all_exakt.U2, [], numel(time_steps)))*10^3;

min_diff_U3 = min(reshape(NodeRes_all_estim.U3, [], numel(time_steps)) - reshape(NodeRes_all_exakt.U3, [], numel(time_steps)))*10^3;
max_diff_U3 = max(reshape(NodeRes_all_estim.U3, [], numel(time_steps)) - reshape(NodeRes_all_exakt.U3, [], numel(time_steps)))*10^3;

min_diff_U = min([min_diff_U1; min_diff_U2; min_diff_U3]);
max_diff_U = max([max_diff_U1; max_diff_U2; max_diff_U3]);

min_diff_I1 = min(reshape(BranchRes_all_estim.I1, [], numel(time_steps)) - reshape(BranchRes_all_exakt.I1, [], numel(time_steps)))*10^3;
max_diff_I1 = max(reshape(BranchRes_all_estim.I1, [], numel(time_steps)) - reshape(BranchRes_all_exakt.I1, [], numel(time_steps)))*10^3;

min_diff_I2 = min(reshape(BranchRes_all_estim.I2, [], numel(time_steps)) - reshape(BranchRes_all_exakt.I2, [], numel(time_steps)))*10^3;
max_diff_I2 = max(reshape(BranchRes_all_estim.I2, [], numel(time_steps)) - reshape(BranchRes_all_exakt.I2, [], numel(time_steps)))*10^3;

min_diff_I3 = min(reshape(BranchRes_all_estim.I3, [], numel(time_steps)) - reshape(BranchRes_all_exakt.I3, [], numel(time_steps)))*10^3;
max_diff_I3 = max(reshape(BranchRes_all_estim.I3, [], numel(time_steps)) - reshape(BranchRes_all_exakt.I3, [], numel(time_steps)))*10^3;

min_diff_I = min([min_diff_I1; min_diff_I2; min_diff_I3]);
max_diff_I = max([max_diff_I1; max_diff_I2; max_diff_I3]);

figure; % Over all phases
subplot(2,1,1);
plot([time_steps; time_steps], [min_diff_U; max_diff_U], 'Color', [0 0.4470 0.7410]);
ylabel('Error in V');
subplot(2,1,2);
plot([time_steps; time_steps], [min_diff_I; max_diff_I], 'Color', [0 0.4470 0.7410]);
ylabel('Error in A');

figure; % For each phase seperate
subplot(2,1,1); hold all;
h1 = plot([time_steps; time_steps], [min_diff_U1; max_diff_U1], 'Color', [0      0.4470 0.7410]);
h2 = plot([time_steps; time_steps], [min_diff_U2; max_diff_U2], 'Color', [0.8500 0.3250 0.0980]);
h3 = plot([time_steps; time_steps], [min_diff_U3; max_diff_U3], 'Color', [0.9290 0.6940 0.1250]);
legend([h1(1) h2(1) h3(1)],{'L1','L2','L3'});
ylabel('Error in V');
subplot(2,1,2); hold all;
h1 = plot([time_steps; time_steps], [min_diff_I1; max_diff_I1], 'Color', [0      0.4470 0.7410]);
h2 = plot([time_steps; time_steps], [min_diff_I2; max_diff_I2], 'Color', [0.8500 0.3250 0.0980]);
h3 = plot([time_steps; time_steps], [min_diff_I3; max_diff_I3], 'Color', [0.9290 0.6940 0.1250]);
legend([h1(1) h2(1) h3(1)],{'L1','L2','L3'});
ylabel('Error in A');