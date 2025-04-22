pkg load signal
t = 0:0.0002:0.02;
f_gps = 1e3;
f_tcxo = 1.002e3;

clk_gps = square(2 * pi * f_gps * t);
clk_tcxo = square(2 * pi * f_tcxo * t);

figure;
subplot(2,1,1);
stairs(t, clk_gps, 'b', 'LineWidth', 1.5);
title('GPS Reference Clock');
xlabel('Time (s)');
ylabel('Amplitude');
ylim([-1.5 1.5]);
grid on;

subplot(2,1,2);
stairs(t, clk_tcxo, 'r', 'LineWidth', 1.5);
title('TCXO Clock (With Slight Drift)');
xlabel('Time (s)');
ylabel('Amplitude');
ylim([-1.5 1.5]);
grid on;

