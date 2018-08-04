function [H_SE, H_index] = get_H_SE(Y_L1L2L3, Y_012_Node_ID, x_hat)
%%  get_H_SE - Get the H matrix of SE

%% Preperation

size_Y	= size(Y_L1L2L3,1);	% Get number of grid nodes
G_ij    = real(Y_L1L2L3);	% Get real part (condcutance) of admmittance matrix
B_ij    = imag(Y_L1L2L3);	% Get imaginary part (susceptance) of admmittance matrix

% Set voltage angle difference of evaluation (eva) point of linearization
% Note: This angle is an agle difference because the measurement modell
%       equations of active and reactive power include the
%       cos(delta_i_v - delta_j_w) and sin(delta_i_v - delta_j_w)
%       where i,j are grid node names and v,w are conductor names

H_index = table;
H_index.Node1_ID = ...
    repmat(Y_012_Node_ID,4,1);              % H_index includes all connection between node id and node names

H_index.Phase     = repmat ([1; 2; 3]   , 4 * size_Y / 3, 1);
H_index.Meas_Type = repelem([1; 2; 3; 4],     size_Y    , 1);

%% Initialize meaurement model matrix H
H_SE = zeros(4*size_Y,2*size_Y);   % H includes all possible measurement modell equations

%% Set measurement modell equations for voltage magnitues and angles U_L1L2L3
H_SE(1:2*size_Y,1:2*size_Y) = eye(2*size_Y);

%%  Set measurement modell equations for active and reactive power

for k_i = 1 : size_Y
    for k_j = 1 : size_Y
        delta_phi = x_hat(k_i + size_Y) - x_hat(k_j + size_Y); % TODO: Calculate sin/cos just once
        if k_i ~= k_j 
            H_SE(2 * size_Y + k_i,          k_j) = x_hat(k_i) *              ( cos(delta_phi) * G_ij(k_i, k_j) + sin(delta_phi) * B_ij(k_i, k_j)); % P_i/  U_j
            H_SE(2 * size_Y + k_i, size_Y + k_j) = x_hat(k_i) * x_hat(k_j) * ( sin(delta_phi) * G_ij(k_i, k_j) - cos(delta_phi) * B_ij(k_i, k_j)); % P_i/phi_j
            H_SE(3 * size_Y + k_i,          k_j) = x_hat(k_i) *              ( sin(delta_phi) * G_ij(k_i, k_j) - cos(delta_phi) * B_ij(k_i, k_j)); % Q_i/  U_j
            H_SE(3 * size_Y + k_i, size_Y + k_j) = x_hat(k_i) * x_hat(k_j) * (-cos(delta_phi) * G_ij(k_i, k_j) - sin(delta_phi) * B_ij(k_i, k_j)); % Q_i/phi_j
        else
            H_SE(2 * size_Y + k_i,          k_i) = H_SE(2 * size_Y + k_i,          k_i) +              x_hat(k_j) * ( cos(delta_phi) * G_ij(k_i,k_j) + sin(delta_phi) * B_ij(k_i,k_j)); % P_i/  U_i
            H_SE(2 * size_Y + k_i, size_Y + k_i) = H_SE(2 * size_Y + k_i, size_Y + k_i) - x_hat(k_i) * x_hat(k_j) * ( sin(delta_phi) * G_ij(k_i,k_j) + cos(delta_phi) * B_ij(k_i,k_j)); % P_i/phi_i
            H_SE(3 * size_Y + k_i,          k_i) = H_SE(3 * size_Y + k_i,          k_i) +              x_hat(k_j) * ( sin(delta_phi) * G_ij(k_i,k_j) - cos(delta_phi) * B_ij(k_i,k_j)); % Q_i/  U_i
            H_SE(3 * size_Y + k_i, size_Y + k_i) = H_SE(3 * size_Y + k_i, size_Y + k_i) - x_hat(k_i) * x_hat(k_j) * ( cos(delta_phi) * G_ij(k_i,k_j) + sin(delta_phi) * B_ij(k_i,k_j)); % Q_i/phi_i
        end
        H_SE(2 * size_Y + k_i,          k_i) = H_SE(2 * size_Y + k_i,          k_i) +              x_hat(k_j) * ( cos(delta_phi) * G_ij(k_i,k_j) + sin(delta_phi) * B_ij(k_i,k_j)); % P_i/  U_i    
        H_SE(2 * size_Y + k_i, size_Y + k_i) = H_SE(2 * size_Y + k_i, size_Y + k_i) + x_hat(k_i) * x_hat(k_j) * (-sin(delta_phi) * G_ij(k_i,k_j) + cos(delta_phi) * B_ij(k_i,k_j)); % P_i/phi_i
        H_SE(3 * size_Y + k_i,          k_i) = H_SE(3 * size_Y + k_i,          k_i) +              x_hat(k_j) * ( sin(delta_phi) * G_ij(k_i,k_j) - cos(delta_phi) * B_ij(k_i,k_j)); % Q_i/  U_i  
        H_SE(3 * size_Y + k_i, size_Y + k_i) = H_SE(3 * size_Y + k_i, size_Y + k_i) + x_hat(k_i) * x_hat(k_j) * ( cos(delta_phi) * G_ij(k_i,k_j) + sin(delta_phi) * B_ij(k_i,k_j)); % Q_i/phi_i
    end
end
