pkg load signal;

fs = 100 * 10^6;
fc = 1575.42 / 1000;
bw = 2 / 1000;
f = linspace((fc - 10/1000), (fc + 10/1000), 1000);

H = exp(-((f - fc) / (bw/2)).^6);

plot(f, H, 'b', 'linewidth', 1);
xlabel("Frequency (GHz)");
ylabel("Magnitude");
title("Idealized SAW Filter Response");
grid on;
xlim([fc - 10/1000, fc + 10/1000]);
ylim([0, 1.1]);
