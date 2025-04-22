% LNA Simulation - Anoos
clear;
clc;
close all;

f = linspace(1.5e9, 1.6e9, 1000);
gain_dB = 20;
noise_figure_dB = 1;
input_power_dBm = -130;
thermal_noise_dBm = -174 + 10*log10(1e6);
gain_linear = 10^(gain_dB/10);
noise_figure_linear = 10^(noise_figure_dB/10);

output_power_dBm = input_power_dBm + gain_dB;
noise_power_dBm = thermal_noise_dBm + noise_figure_dB;

snr_in_dB = input_power_dBm - thermal_noise_dBm;
snr_out_dB = output_power_dBm - noise_power_dBm;

figure;
subplot(3,1,1);
plot(f/1e9, ones(size(f)) * output_power_dBm, 'b', 'LineWidth', 2);
xlabel('Frequency (GHz)');
ylabel('Output Power (dBm)');
title('LNA Output Power vs. Frequency');
grid on;
subplot(3,1,2);
plot(f/1e9, ones(size(f)) * noise_power_dBm, 'r', 'LineWidth', 2);
xlabel('Frequency (GHz)');
ylabel('Noise Power (dBm)');
title('LNA Noise Power vs. Frequency');
grid on;
subplot(3,1,3);
bar([snr_in_dB, snr_out_dB]);
set(gca, 'XTickLabel', {'Input SNR', 'Output SNR'});
ylabel('SNR (dB)');
title('Signal-to-Noise Ratio Improvement by LNA');
grid on;
