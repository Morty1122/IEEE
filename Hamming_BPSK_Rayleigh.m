%利用汉明码的编码方式，在BPSK调制后经过Rayleigh信道的过程
%函数功能：计算利用汉明码的编码方式，在BPSK调制后经过Rayleigh信道误码率与信噪比的关系
%函数参数说明：data 信息流
function [BER_theor_Rayleigh,H_BER_Rayleigh] = Hamming_BPSK_Rayleigh(data)
%% 汉明码信道编码
n = 7;                
k = 4;                         
% data = randi([0 1],1e5,k);                            % 调用函数时可将该行注释掉，利用主函数的data完成编码译码过程
len_data = length(data);
len_data_sum = k*length(data);                          % 定义大量比特流及其长度
H_encData = encode(data,n,k,'hamming/binary');          % 调用encode函数，对大量比特流进行（7,4）汉明码信道编码
len_H_encData = n*length(data);                         % 定义编码后长度
%% BPSK调制
H_modData = 2*H_encData-1;                              % 对编码后信号进行BPSK调制
%% Rayleigh信道和解调译码过程
EbN0dB=0:0.5:6;                                         % EbN0分贝形式，以0.5dB为步进，取值范围0-6
EbN0=10.^(EbN0dB/10);
len_EbN0=length(EbN0);                                  % 计算不同信噪比的种类数量
for j=1:len_EbN0                                        % 根据不同信噪比加入噪声
    h_0=1/sqrt(2).*(randn(1,len_H_encData)+1i.*randn(1,len_H_encData));             % 瑞利衰弱信道建模
    h = reshape(h_0, len_data, n);
    sigma(j)=sqrt(1/(2*EbN0(j)));
    noise_0 = sigma(j)*(randn(1,len_H_encData)+1i*randn(1,len_H_encData));
    noise = reshape(noise_0, len_data, n);
    H_reData=h.*H_modData+noise;

    H_reData2=H_reData./h;                                                          % 接收端信号完成能量归一化
    H_demod =real(H_reData2)>0;                                                     % 完成BPSK解调过程

    H_decData=decode(H_demod,n,k,'hamming/binary');                                 % 调用decode函数，完成译码过程

    H_BER_Rayleigh(j)=sum(abs(H_decData-data),'all')/(len_data_sum);                % 利用译码后比特流和输入的比特流求差再求和的方式完成误码率的计算
end
%% 作图
BER_theor_Rayleigh=0.5*(1-sqrt(EbN0./(1+EbN0)));                                    % 求得在未编码时通过瑞利信道的误码率
% semilogy(EbN0dB,BER_theor_Rayleigh,EbN0dB,H_BER_Rayleigh,'bp-','Linewidth',2);
% axis([0 6 10^-5 1]);
% xlabel('EbN0(dB)');
% ylabel('BER');
% legend('未编码过Rayleigh','Hamming过Rayleigh');                                                 % 作图
% title('BPSK调制，过Rayleigh信道的BER');
    








