pkg load signal;

fs = 1e6;
t = 0:1/fs:20e-3;
f0 = 10e3;
clk_ideal = cos(2 * pi * f0 * t);

temp_noise = 0.5 * sin(2 * pi * 1 * t) + 0.3 * randn(size(t));
clk_noisy = cos(2 * pi * f0 * t + temp_noise);

compensated_phase = temp_noise;
clk_compensated = cos(2 * pi * f0 * t - compensated_phase);

figure;
subplot(3,1,1);
plot(t(1:2000), clk_ideal(1:2000), 'b', 'linewidth', 1.5);
title('Ideal Clock Signal'); xlabel('Time (s)'); ylabel('Amplitude'); grid on;

subplot(3,1,2);
plot(t(1:2000), clk_noisy(1:2000), 'r', 'linewidth', 1.5);
title('Clock Signal with Temperature-Induced Phase Noise'); xlabel('Time (s)'); ylabel('Amplitude'); grid on;

subplot(3,1,3);
plot(t(1:2000), clk_compensated(1:2000), 'g', 'linewidth', 1.5);
title('Compensated Clock Signal'); xlabel('Time (s)'); ylabel('Amplitude'); grid on;
