clc; clearvars; close all;

 H = [1 0.3 0.6 0.4 0.23];
delta = 0.001;
I_len = 10000;
I = randi([0 1],1,I_len);
I = real(pskmod(I,2,pi));
nTap = 10;
c = zeros(1,nTap);

%%channel coefficients

v = filter(H,1,I);
v_awgn = awgn(v,10,'measured');
err = zeros(1,I_len-nTap+1);
eq_out = zeros(1,I_len-nTap+1);
ind = 1;
mse = zeros(1,I_len);
mse2 = zeros(1,I_len);
for i = nTap:I_len
    e = filter(c,1,v)-I;
    mse(i) = mean(e.^2);
    eq_out(ind) = c*v(i:-1:i-nTap+1)';
    err(ind) = I(i) - eq_out(ind);
    c = c + delta*err(ind)*I(i:-1:i-nTap+1);
    ind = ind + 1;
end
ind = 1;
err = zeros(1,I_len-nTap+1);
eq_out = zeros(1,I_len-nTap+1);
c = zeros(1,nTap);

for i = nTap:I_len
    e = filter(c,1,v_awgn)-I;
    mse2(i) = mean(e.^2);
    eq_out(ind) = c*v_awgn(i:-1:i-nTap+1)';
    err(ind) = I(i) - eq_out(ind);
    c = c + delta*err(ind)*I(i:-1:i-nTap+1);
    ind = ind + 1;
end

figure(1)
plot(mse);
xlabel('Number of Iterations')
ylabel('MSE')
hold on;
plot(mse2);
legend('Channel without AWGN','Channel with AWGN (SNR = 10 dB)');

