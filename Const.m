classdef Const
    properties (Constant = true)
        pi = 3.14159265358979;			%pi
        vel_c = 2.99792458e+10;			%speed of light in vacum in cm
        semi_inf = 1;					%semi_infinite weights
        n_ref = 1.3333;					%refractive index in medium
        vel = Const.vel_c/Const.n_ref;
        omega = 2.0*Const.pi*140*1000000; 	%2pi freq = 140
		turnpoint = 0;
    end
end

