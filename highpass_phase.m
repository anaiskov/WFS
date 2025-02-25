% Parameters
fs = 48000; 
N = 256; % Filter order
f_c = 100; % Cut frequency 
f_n = f_c / (fs / 2); % Normalized frequency 

% FIR high-pass filter 
h = fir1(N, f_n, 'high', hamming(N+1));

% Phase advance corresponding to an advance of 1/8th of a period
% For an advance of 1/8th of a period at each frequency:
H = fft(h); 
H = H .* exp(-1j * 2 * pi * (1/8)); % Correct phase advance
h_fir = ifft(H);

% Ensure coefficients are real
h_fir = real(h_fir);

% Parameters for the display (optional)
freq = linspace(0, fs/2, length(H)/2); 
H_dB = 20 * log10(abs(H(1:end/2))); % In dB

% Display of the amplitude response
figure;
subplot(2,1,1);
semilogx(freq, H_dB);
title('Réponse en amplitude du filtre (en dB)');
xlabel('Fréquence (Hz)');
ylabel('Amplitude (dB)');
grid on;

% Display of the phase response
subplot(2,1,2);
semilogx(freq, unwrap(angle(H(1:end/2)))*180/pi);
title('Réponse en phase du filtre');
xlabel('Fréquence (Hz)');
ylabel('Phase (degrés)');
grid on;

% Save coefficients to a text file
fid = fopen('FIR_b_coeffs.txt', 'w');
fprintf(fid, '%.10f,\n', h_fir);
fclose(fid);

