function [P_oxy,P] = oxy_tot_func(abs74,abs78,abs80,abs83,v_tot,mua074,mua078,mua080,mua083)

W_740_780_808_830 = 2.303*[1.3029 0.4383; 1.1050 0.7360;0.8040 0.9164; 0.7804 1.0507];   %730 nm source in system 2 UCHC 2014
W_square = W_740_780_808_830'*W_740_780_808_830;
KK4 = W_square\W_740_780_808_830';
K4 = sum(KK4);

%%%%%%%%%%%%%%%%%%%%four wavelengths %%%%%%%%%%%%%%%%%%%%%
total_oxygen = 1000*(K4(1)*abs74+K4(2)*abs78+K4(3)*abs80+K4(4)*abs83);
deoxy = 1000*(KK4(1,1)*abs74+KK4(1,2)*abs78+KK4(1,3)*abs80+KK4(1,4)*abs83);
oxy = 1000*(KK4(2,1)*abs74+KK4(2,2)*abs78+KK4(2,3)*abs80+KK4(2,4)*abs83);

FW_oxy = max(total_oxygen(1:v_tot))*0.5;
xx1 = find(total_oxygen(1:v_tot)>=FW_oxy);

FW_oxyHb = max(oxy(1:v_tot))*0.5;
yy1 = find(oxy(1:v_tot)>=FW_oxyHb);

FW_deoxyHb = max(deoxy(1:v_tot))*0.5;
zz1 = find(deoxy(1:v_tot)>=FW_deoxyHb);

P_oxy(1) = max(total_oxygen(1:v_tot));
P_oxy(2) = mean(total_oxygen(xx1));
P_oxy(3) = max(oxy(1:v_tot));
P_oxy(4) = mean(oxy(yy1));
P_oxy(5) = max(deoxy(1:v_tot));
P_oxy(6) = mean(deoxy(zz1));

P(1)= 1000*(K4(1)*mua074+K4(2)*mua078+K4(3)*mua080+K4(4)*mua083);               %total
P(2)= 1000*(KK4(2,1)*mua074+KK4(2,2)*mua078+KK4(2,3)*mua080+KK4(2,4)*mua083);   %oxy
P(3)= 1000*(KK4(1,1)*mua074+KK4(1,2)*mua078+KK4(1,3)*mua080+KK4(1,4)*mua083);   %deoxy

P_oxy