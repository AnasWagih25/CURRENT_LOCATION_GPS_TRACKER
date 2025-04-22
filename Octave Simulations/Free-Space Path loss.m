% Constants
c = 3e8; % Speed of light (m/s)
f = 900e6; % Frequency (900 MHz for GSM) in Hz

% Distance range (from 1 meter to 1000 meters)
d = linspace(1, 1000, 100); % 100 values from 1m to 1000m

% Free-space path loss calculation
L_f = 20 * log10((4 * pi * d * f) / c);

% Plotting the results
figure;
plot(d, L_f, 'LineWidth', 2);
xlabel('Distance (m)');
ylabel('Path Loss (dB)');
title('Free-Space Path Loss vs Distance');
grid on;
