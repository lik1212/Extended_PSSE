%% Demostration file for general SE with/without the Augmented Matrix app.
%  Brandalik's extension (Bext)
%  As input you need z_all_data, z_all_flag, LineInfo and U_eva, check
%  the input data description for more details. 
%
% Author(s):    R. Brandalik
%
% Contact: brandalikrobert@gmail.com, brandalik@eit.uni-kl.de
%
% Special thanks go to the entire TUK ESEM team.
%
% Parts of the work were the result of the project CheapFlex, sponsored by
% the German Federal Ministry of Economic Affairs and Energy as part of the
% 6th Energy Research Programme of the German Federal Government. 


%% Clear start

path(pathdef); clear; close all; clc

%% User setup

Grid    = 'S1a_de';
SE_Ext  = true;         % Extended formulation (yes/no)
SE_Case = 1;            % Case 1, 2, 3, 4 or 5 (from the paper)

if SE_Case > 2 && SE_Ext == false
    error('Only case 1 and 2 can be performed without the extended formulation.');
end

%% If reduced measurements time steps wanted

% time_steps = 566:566;

%% Path preperation

addpath([pwd,'\Subfunctions'        ]);  % Add subfunction path
addpath([pwd,'\Comparison_Functions']);  % Add comparison subfunction path

%% Load Demo Data

% load([pwd,'\Demo_Data\Demo_Data_', Grid, '.mat']); 
load([pwd,'\Demo_Data\Demo_Data_', Grid, '_noisy.mat']); 

% Just for comparison
load([pwd,'\Comparison_Data\SinInfo_', Grid, '.mat']); 
NodeRes_all_exakt   = load([pwd,'\Comparison_Data\', Grid, '_NodeRes_raw_wo_TR.mat'  ]);
BranchRes_all_exakt = load([pwd,'\Comparison_Data\', Grid, '_BranchRes_raw_wo_TR.mat']);

if exist('time_steps', 'var')
    z_all_data = z_all_data(:,time_steps);
end

%% Inputs for State Estimation (can be extended with Inputs)

Inputs_SE.max_iter = 20         ; % Max num of iteration
Inputs_SE.z_conv   = 1 * 10^-0  ; % Abort criterion (convergence limit)
Inputs_SE.x_conv   = 1 * 10^-1  ; % Abort criterion (convergence limit)
Inputs_SE.U_start  = 400/sqrt(3); % Voltage of iteration start (Flat-Start)
Inputs_SE.F_Bext   = 10^2       ; % Bext factor, accuracy of Bext measur. (Less measurements smaller factor!)

%% Reduce measurements

if SE_Case ~= 1
    Household_IDs = unique(z_all_flag.Node1_ID(...
        z_all_flag.Meas_Type  == 3 & ...
        z_all_flag.Accur_Type == 1 & ...
        z_all_flag.Node1_ID   ~= SinInfo.Infeeder.Node1_ID));      % Slack
 
    % Initial
    U2del = false(size(z_all_flag,1),1);
    Q2del = false(size(z_all_flag,1),1);
    P2del = false(size(z_all_flag,1),1);

    if any(SE_Case == 2:4)
        P2del = z_all_flag.Meas_Type == 3 & ismember(z_all_flag.Node1_ID, Household_IDs(1:1:end)); % P for no household
        if SE_Case == 3
            U2del = z_all_flag.Meas_Type == 1 & ismember(z_all_flag.Node1_ID, Household_IDs(round(1:6:end))); % U only for some household
        end     
    end  
    
    if any(SE_Case == 4:5)
        U2del = z_all_flag.Meas_Type == 1 & ismember(z_all_flag.Node1_ID, Household_IDs(1:1:end)); % U for no household
    end
    
    if SE_Case == 5
        P2del = z_all_flag.Meas_Type == 3 & ismember(z_all_flag.Node1_ID, Household_IDs(1:2:end)); % P for no household
        Q2del = z_all_flag.Meas_Type == 4 & ismember(z_all_flag.Node1_ID, Household_IDs(2:2:end)); % Q for all household
    end
    
    z_all_data(U2del | P2del | Q2del,:) = [];
    z_all_flag(U2del | P2del | Q2del,:) = [];

end

%% With or without virtual measurement. For Bext only without possible.

if SE_Ext
    z_all_flag.Sigma(z_all_flag.Accur_Type == 3 & ismember(z_all_flag.Meas_Type, [3,4])) = 1; % No virtual measurement except slack angle
    z_all_flag.Sigma(z_all_flag.Accur_Type == 1 & ismember(z_all_flag.Meas_Type, [3,4])) = 2; % Real measurement less accurate
    % Flag correction for last 2 code lines
    z_all_flag.Accur_Type(z_all_flag.Accur_Type == 3 & z_all_flag.Meas_Type ~= 2) = 1;
end
    
%% Main estimation

tic
if SE_Ext
    [x_hat, z_hat, z_hat_full, Out_Optional] = GenSE_AMA_Bext(z_all_data, z_all_flag, LineInfo, Inputs_SE); % with    Bext
else
    [x_hat, z_hat, z_hat_full, Out_Optional] = GenSE_AMA(z_all_data, z_all_flag, LineInfo, Inputs_SE);      % without Bext
end
toc

%% For comparison

NodeRes_all_estim   = z_full2NodeRes_all(z_hat_full, SinInfo);
BranchRes_all_estim = NodeRes2BranchRes(NodeRes_all_estim, SinInfo, Out_Optional.Y_L1L2L3);

if isstruct(NodeRes_all_exakt)
    NodeRes_all_exakt   = NodeRes_all_exakt  .NodeRes_all;
end
if isstruct(BranchRes_all_exakt)
    BranchRes_all_exakt = BranchRes_all_exakt.BranchRes_all;
end

if ~exist('time_steps', 'var') % If reduced time steps
    time_steps = unique(NodeRes_all_estim.ResTime)';
end

plot_comparison(NodeRes_all_estim, BranchRes_all_estim, NodeRes_all_exakt, BranchRes_all_exakt, time_steps);
