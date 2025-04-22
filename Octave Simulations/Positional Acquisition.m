clear;
clc;
close all;
sat_positions = [15600, 7540, 20140;
                 18760, 2750, 18610;
                 17610, 14630, 13480;
                 19170, 610, 18390;
                 18450, 9200, 20200];

true_position = [17000, 10000, 15000];


c = 3e5;
time_errors = 0.0005 * randn(5,1);
measured_pseudoranges = sqrt(sum((sat_positions - true_position).^2, 2)) + c * time_errors;

estimated_position = mean(sat_positions);


for iter = 1:10
    est_pseudoranges = sqrt(sum((sat_positions - estimated_position).^2, 2));

    H = [(estimated_position(1) - sat_positions(:,1)) ./ est_pseudoranges, ...
         (estimated_position(2) - sat_positions(:,2)) ./ est_pseudoranges, ...
         (estimated_position(3) - sat_positions(:,3)) ./ est_pseudoranges];

    delta_p = measured_pseudoranges - est_pseudoranges;
    correction = (H' * H) \ (H' * delta_p);


    estimated_position = estimated_position + correction';

    % Check for convergence
    if norm(correction) < 1e-3
        break;
    end
end


disp("True Position (km): "), disp(true_position);
disp("Estimated Position (km): "), disp(estimated_position);


figure;
scatter3(sat_positions(:,1), sat_positions(:,2), sat_positions(:,3), 100, 'b', 'filled');
hold on;
scatter3(estimated_position(1), estimated_position(2), estimated_position(3), 150, 'r', 'filled');
scatter3(true_position(1), true_position(2), true_position(3), 150, 'g', 'filled');
legend('Satellites', 'Estimated Position', 'True Position');
xlabel('X (km)'); ylabel('Y (km)'); zlabel('Z (km)');
title('GPS Position Estimation via Newton-Raphson Method');
grid on;
