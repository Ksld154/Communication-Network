n_data = 10000;
data = randi([0 1], 1, n_data);      % Binary data sequence

Eb = 2;
Tb = 1/1000;
Tb_sample = 4000;                    % Time slot in ONE BIT ( by 1/(2*Fc)*Tb )
Fc = 1000000;                        % Frequency of the carrier
N0 = 1;

NRZ_out = [];                        % result  of NonReturn to Zero Encoder (1->1, 0->-1)
for ii = 1:n_data                    % process of NonReturn to Zero Encoder (1->1, 0->-1)
    if data(ii) == 1
        NRZ_out = [NRZ_out ones(1,Tb_sample)*1];
    elseif data(ii) == 0
        NRZ_out = [NRZ_out ones(1,Tb_sample)*(-1)];
    end
end

t = Tb/Tb_sample : Tb/Tb_sample : n_data*Tb;
phi1 = sqrt(2/Tb) * cos(2*pi*Fc*t);
SNR = 10 ^ ((Eb/N0)/10);
carrier_basis = sqrt(SNR) * phi1;    % generate the modulated signal by multiplying it with carrier_basis (function phi1 )
modulated = NRZ_out .* carrier_basis;

%received = modulated + noise;
received = modulated;

noise = sqrt(0.5) .* randn(1, numel(t));
noise = noise .* phi1;
noise_integrated = [];

decoded_msg = [];
y = [];
demodulated = received .* phi1;
for ii = 1 : Tb_sample : size(demodulated,2)
    y = [y trapz(t(ii:ii+Tb_sample-1),demodulated(ii:ii+Tb_sample-1))];
    noise_integrated = [noise_integrated trapz(t(ii:ii+Tb_sample-1),noise(ii:ii+Tb_sample-1))];
end

noise_integrated = noise_integrated * (1/Tb) * 2; 
y = y + noise_integrated;

%noise2 = sqrt(0.5) .* randn(1, numel(y));
%y = y + noise2;

jj = 1;
for ii = 1:n_data
    if y(ii) > 0
        decoded_msg(jj) = 1;
    elseif y(ii) <= 0
        decoded_msg(jj) = 0;
    end
    jj = jj+1;
end
error_index = find(decoded_msg ~= data);
error_bits = numel(error_index);
BER = error_bits / n_data