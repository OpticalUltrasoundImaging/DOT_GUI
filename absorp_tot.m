% compute maximum and average (within FWHM) optical absorption of each wavelength
function [absMax,meanFW,absorp] = absorp_tot(absorp,v_tot,mua)

absorp(1:v_tot) = absorp(1:v_tot) + mua;
absMax = max(absorp(1:v_tot));
FWHM = absMax*0.5;
x1 = absorp(1:v_tot) >= FWHM;
meanFW = mean(absorp(x1));