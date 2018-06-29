close all;
N0 = 1;
Tb = 1/1000;
Tb_sample = 2000;                    % Time slot in ONE BIT ( by 1/(2*Fc)*Tb )
Fc = 1000000;                        % Frequency of the carrier

BER_sample = [];

for Eb = 0:1:10                        % in dB
    SNR = 10 ^ ((Eb/N0)/10);           % in other unit
    if Eb >= 0 && Eb <= 4
        n_data = 10000;
    elseif Eb >= 5 && Eb <= 8
        n_data = 100000;
    elseif Eb >=9 && Eb <= 10
        n_data = 1000000;
    end
    %n_data = 10000;
    data = randi([0 1], 1, n_data);      % Binary data sequence

    received = data;
    decoded_msg = [];
    y = [];
    demodulated = received;
    for ii = 1 : n_data
        if demodulated(ii) <= 0
            y = [y -sqrt(SNR)];
        else
            y = [y sqrt(SNR)];
        end
    end
    
    %{
    t = Tb/Tb_sample : Tb/Tb_sample : n_data*Tb;
    phi1 = sqrt(2/Tb) * cos(2*pi*Fc*t);
    noise_integrated = [];
    noise = sqrt(0.5) .* randn(1, numel(t));
    noise = noise .* phi1;
    
    for ii = 1 : Tb_sample : size(t,2)
        noise_integrated = [noise_integrated trapz(t(ii:ii+Tb_sample-1),noise(ii:ii+Tb_sample-1))];
    end    

    noise_integrated = noise_integrated * (1/Tb); 
    y = y + noise_integrated;
    %}
    
    noise_integrated = [];
    for ii = 1:n_data
        t = Tb/Tb_sample : Tb/Tb_sample : Tb;
        phi1 = sqrt(2/Tb) * cos(2*pi*Fc*t);

        noise = sqrt(0.5) .* randn(1, numel(t));
        noise = noise .* phi1;

        noise_integrated = [noise_integrated trapz(t(1:1+Tb_sample-1),noise(1:1+Tb_sample-1))];   

    end
    
    noise_integrated = noise_integrated * (1/Tb); 
    y = y + noise_integrated;
    
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
    BER = error_bits / n_data;
    BER_sample = [BER_sample BER];
end
    
Eb = 0:1:10;
SNR_dB = Eb / N0;
SNR_theory = 10.^(SNR_dB/10);
BER_theory = 0.5 * erfc(sqrt(SNR_theory));
semilogy(SNR_dB, BER_theory, 'k');             %Plot theoretical BER
set(gca,'xtick',0:1:10)
hold on
semilogy(SNR_dB,BER_sample,'b*');              %Plot sampled BER

title('BER for Binary Phase-Shift Keying(BPSK)');
xlabel('Eb/N0 (dB)');
ylabel('Bit Error Rate  (BER)');
    