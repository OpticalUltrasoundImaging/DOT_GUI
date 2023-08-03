%clear all

source=27
detect=33

% source geometry
s_geom = zeros(source,3);
d_geom = zeros(detect,3);

for iprobe = 1:n
    x_location = 0;
    y_location = (-iprobe + (n-1)/2+1)*step;
    
    s_geom(1+(iprobe-1)*source,1)= 0+x_location;  s_geom(1+(iprobe-1)*source,2) =  4.012+y_location;  s_geom(1+(iprobe-1)*source,3) =  0.000; %angled

    s_geom(2+(iprobe-1)*source,1) = -1.572+x_location;  s_geom(2+(iprobe-1)*source,2) = 3.345+y_location;   s_geom(2+(iprobe-1)*source,3) = 0.000;
    s_geom(3+(iprobe-1)*source,1) = -0.524+x_location;  s_geom(3+(iprobe-1)*source,2) = 3.345+y_location;   s_geom(3+(iprobe-1)*source,3) = 0.000; %angled
    s_geom(4+(iprobe-1)*source,1) =  0.524+x_location;  s_geom(4+(iprobe-1)*source,2) = 3.345+y_location;   s_geom(4+(iprobe-1)*source,3) = 0.000; %angled
    s_geom(5+(iprobe-1)*source,1) = 1.572+x_location;  s_geom(5+(iprobe-1)*source,2) =  3.345+y_location;  s_geom(5+(iprobe-1)*source,3) =  0.000;

    s_geom(6+(iprobe-1)*source,1) = -2.096+x_location;  s_geom(6+(iprobe-1)*source,2) = 2.678+y_location;   s_geom(6+(iprobe-1)*source,3) = 0.000;
    s_geom(7+(iprobe-1)*source,1) = -1.048+x_location;  s_geom(7+(iprobe-1)*source,2) = 2.678+y_location;   s_geom(7+(iprobe-1)*source,3) = 0.000; %angled
    s_geom(8+(iprobe-1)*source,1) = 0.000+x_location;  s_geom(8+(iprobe-1)*source,2) =  2.678+y_location;  s_geom(8+(iprobe-1)*source,3) =  0.000;
    s_geom(9+(iprobe-1)*source,1) = 1.048+x_location;  s_geom(9+(iprobe-1)*source,2) = 2.678+y_location;   s_geom(9+(iprobe-1)*source,3) = 0.000; %angled
    s_geom(10+(iprobe-1)*source,1) =  2.096+x_location;  s_geom(10+(iprobe-1)*source,2) = 2.678+y_location;   s_geom(10+(iprobe-1)*source,3) = 0.000; %angled

    s_geom(11+(iprobe-1)*source,1) = -2.44475+x_location;  s_geom(11+(iprobe-1)*source,2) =2.043+y_location;   s_geom(11+(iprobe-1)*source,3) = 0.000;%angled 
    s_geom(12+(iprobe-1)*source,1) = -1.74625+x_location;  s_geom(12+(iprobe-1)*source,2) = 2.043+y_location;   s_geom(12+(iprobe-1)*source,3) = 0.000; %angled 
    s_geom(13+(iprobe-1)*source,1) = -1.04775+x_location;  s_geom(13+(iprobe-1)*source,2) = 2.043+y_location;   s_geom(13+(iprobe-1)*source,3) = 0.000; %angled
    s_geom(14+(iprobe-1)*source,1) = -0.34925+x_location;  s_geom(14+(iprobe-1)*source,2) = 2.043+y_location;   s_geom(14+(iprobe-1)*source,3) = 0.000; %angled
    s_geom(15+(iprobe-1)*source,1) = 0.34925+x_location;  s_geom(15+(iprobe-1)*source,2) = 2.043+y_location;   s_geom(15+(iprobe-1)*source,3) = 0.000; %angled
    s_geom(16+(iprobe-1)*source,1) = 1.04775+x_location;  s_geom(16+(iprobe-1)*source,2) = 2.043+y_location;   s_geom(16+(iprobe-1)*source,3) = 0.000; %angled
    s_geom(17+(iprobe-1)*source,1) = 1.74625+x_location;  s_geom(17+(iprobe-1)*source,2) = 2.043+y_location;   s_geom(17+(iprobe-1)*source,3) = 0.000;
    s_geom(18+(iprobe-1)*source,1) = 2.44475+x_location;  s_geom(18+(iprobe-1)*source,2) =2.043+y_location;   s_geom(18+(iprobe-1)*source,3) = 0.000;

    s_geom(19+(iprobe-1)*source,1) = -2.794+x_location;  s_geom(19+(iprobe-1)*source,2) =1.408+y_location;   s_geom(19+(iprobe-1)*source,3) = 0.000;%angled 
    s_geom(20+(iprobe-1)*source,1) = -2.0955+x_location;  s_geom(20+(iprobe-1)*source,2) = 1.408+y_location;   s_geom(20+(iprobe-1)*source,3) = 0.000; %angled
    s_geom(21+(iprobe-1)*source,1) = -1.397+x_location;  s_geom(21+(iprobe-1)*source,2) = 1.408+y_location;   s_geom(21+(iprobe-1)*source,3) = 0.000;
    s_geom(22+(iprobe-1)*source,1) = -0.6985+x_location;  s_geom(22+(iprobe-1)*source,2) = 1.408+y_location;   s_geom(22+(iprobe-1)*source,3) = 0.000; %angled
    s_geom(23+(iprobe-1)*source,1) = 0.00+x_location;  s_geom(23+(iprobe-1)*source,2) = 1.408+y_location;   s_geom(23+(iprobe-1)*source,3) = 0.000;
    s_geom(24+(iprobe-1)*source,1) = 0.6985+x_location;  s_geom(24+(iprobe-1)*source,2) = 1.408+y_location;   s_geom(24+(iprobe-1)*source,3) = 0.000; %angled
    s_geom(25+(iprobe-1)*source,1) =  1.397+x_location;  s_geom(25+(iprobe-1)*source,2) = 1.408+y_location;   s_geom(25+(iprobe-1)*source,3) = 0.000; %angled 
    s_geom(26+(iprobe-1)*source,1) = 2.0955+x_location;  s_geom(26+(iprobe-1)*source,2) = 1.408+y_location;   s_geom(26+(iprobe-1)*source,3) = 0.000; %angled
    s_geom(27+(iprobe-1)*source,1) = 2.794+x_location;  s_geom(27+(iprobe-1)*source,2) = 1.408+y_location;   s_geom(27+(iprobe-1)*source,3) = 0.000; %angled


    %detector geometry
    d_geom(1+(iprobe-1)*detect,1) = 0.000+x_location;  d_geom(1+(iprobe-1)*detect,2) =  -3.581+y_location;  d_geom(1+(iprobe-1)*detect,3) =  0.000;

    d_geom(2+(iprobe-1)*detect,1)= -1.746+x_location;  d_geom(2+(iprobe-1)*detect,2) =  -3.267+y_location;  d_geom(2+(iprobe-1)*detect,3) =  0.000;
    d_geom(3+(iprobe-1)*detect,1)= -1.164+x_location;  d_geom(3+(iprobe-1)*detect,2)=  -3.171+y_location;  d_geom(3+(iprobe-1)*detect,3)=  0.000;
    d_geom(4+(iprobe-1)*detect,1)= -0.582+x_location;  d_geom(4+(iprobe-1)*detect,2)=  -3.171+y_location;  d_geom(4+(iprobe-1)*detect,3)=  0.000;
    d_geom(5+(iprobe-1)*detect,1)= 0+x_location;  d_geom(5+(iprobe-1)*detect,2)=  -3.075+y_location;  d_geom(5+(iprobe-1)*detect,3)=  0.000;
    d_geom(6+(iprobe-1)*detect,1)= 0.582+x_location;  d_geom(6+(iprobe-1)*detect,2)=  -3.171+y_location;  d_geom(6+(iprobe-1)*detect,3)=  0.000;
    d_geom(7+(iprobe-1)*detect,1)= 1.164+x_location;  d_geom(7+(iprobe-1)*detect,2)=  -3.171+y_location;  d_geom(7+(iprobe-1)*detect,3)=  0.000;
    d_geom(8+(iprobe-1)*detect,1)= 1.746+x_location;  d_geom(8+(iprobe-1)*detect,2)=  -3.267+y_location;  d_geom(8+(iprobe-1)*detect,3)=  0.000;

    d_geom(9+(iprobe-1)*detect,1) = -2.667+x_location;  d_geom(9+(iprobe-1)*detect,2) = -2.688+y_location;  d_geom(9+(iprobe-1)*detect,3) =  0.000;
    d_geom(10+(iprobe-1)*detect,1)= -1.8635+x_location;  d_geom(10+(iprobe-1)*detect,2)=  -2.6285+y_location;  d_geom(10+(iprobe-1)*detect,3)=  0.000;
    d_geom(11+(iprobe-1)*detect,1) =  -1.016+x_location;  d_geom(11+(iprobe-1)*detect,2) =-2.569+y_location;   d_geom(11+(iprobe-1)*detect,3) = 0.000;
    d_geom(12+(iprobe-1)*detect,1) = 0+x_location; d_geom(12+(iprobe-1)*detect,2) = -2.569+y_location;  d_geom(12+(iprobe-1)*detect,3) =  0.000;
    d_geom(13+(iprobe-1)*detect,1) = 1.016+x_location;  d_geom(13+(iprobe-1)*detect,2) =  -2.569+y_location;  d_geom(13+(iprobe-1)*detect,3) =  0.000;
    d_geom(14+(iprobe-1)*detect,1)= 1.8635+x_location;  d_geom(14+(iprobe-1)*detect,2)=  -2.6285+y_location;  d_geom(14+(iprobe-1)*detect,3)=  0.000;
    d_geom(15+(iprobe-1)*detect,1) = 2.667+x_location;  d_geom(15+(iprobe-1)*detect,2) = -2.688+y_location;  d_geom(15+(iprobe-1)*detect,3) =  0.000;

    d_geom(16+(iprobe-1)*detect,1)= -2.032+x_location;  d_geom(16+(iprobe-1)*detect,2)=  -2.1245+y_location;  d_geom(16+(iprobe-1)*detect,3)=  0.000;
    d_geom(17+(iprobe-1)*detect,1)= -1.524+x_location;  d_geom(17+(iprobe-1)*detect,2)=  -2.1245+y_location;  d_geom(17+(iprobe-1)*detect,3)=  0.000;
    d_geom(18+(iprobe-1)*detect,1)= -0.508+x_location;  d_geom(18+(iprobe-1)*detect,2)=  -2.1245+y_location;  d_geom(18+(iprobe-1)*detect,3)=  0.000;
    d_geom(19+(iprobe-1)*detect,1)= 0+x_location;  d_geom(19+(iprobe-1)*detect,2)=  -2.1245+y_location;  d_geom(19+(iprobe-1)*detect,3)=  0.000;
    d_geom(20+(iprobe-1)*detect,1)= 0.508+x_location;  d_geom(20+(iprobe-1)*detect,2)=  -2.1245+y_location;  d_geom(20+(iprobe-1)*detect,3)=  0.000;
    d_geom(21+(iprobe-1)*detect,1)= 1.524+x_location;  d_geom(21+(iprobe-1)*detect,2)=  -2.1245+y_location;  d_geom(21+(iprobe-1)*detect,3)=  0.000;
    d_geom(22+(iprobe-1)*detect,1)= 2.032+x_location;  d_geom(22+(iprobe-1)*detect,2)=  -2.1245+y_location;  d_geom(22+(iprobe-1)*detect,3)=  0.000;


    d_geom(23+(iprobe-1)*detect,1) = -2.54+x_location;  d_geom(23+(iprobe-1)*detect,2) = -1.68+y_location;  d_geom(23+(iprobe-1)*detect,3) =  0.000;
    d_geom(24+(iprobe-1)*detect,1) = -2.032+x_location;  d_geom(24+(iprobe-1)*detect,2) = -1.68+y_location;  d_geom(24+(iprobe-1)*detect,3) =  0.000;
    d_geom(25+(iprobe-1)*detect,1)= -1.524+x_location;  d_geom(25+(iprobe-1)*detect,2)=  -1.68+y_location;  d_geom(25+(iprobe-1)*detect,3)=  0.000;
    d_geom(26+(iprobe-1)*detect,1)= -1.016+x_location;  d_geom(26+(iprobe-1)*detect,2)=  -1.68+y_location;  d_geom(26+(iprobe-1)*detect,3)=  0.000;
    d_geom(27+(iprobe-1)*detect,1) = -0.508+x_location;  d_geom(27+(iprobe-1)*detect,2) = -1.68+y_location;  d_geom(27+(iprobe-1)*detect,3) =  0.000;
    d_geom(28+(iprobe-1)*detect,1)= 0+x_location;  d_geom(28+(iprobe-1)*detect,2)=  -1.68+y_location;  d_geom(28+(iprobe-1)*detect,3)=  0.000;
    d_geom(29+(iprobe-1)*detect,1) = 0.508+x_location;  d_geom(29+(iprobe-1)*detect,2) = -1.68+y_location;   d_geom(29+(iprobe-1)*detect,3) = 0.000;
    d_geom(30+(iprobe-1)*detect,1) = 1.016+x_location;  d_geom(30+(iprobe-1)*detect,2) = -1.68+y_location;  d_geom(30+(iprobe-1)*detect,3) =  0.000;
    d_geom(31+(iprobe-1)*detect,1) = 1.524+x_location;  d_geom(31+(iprobe-1)*detect,2) = -1.68+y_location;  d_geom(31+(iprobe-1)*detect,3) =  0.000;
    d_geom(32+(iprobe-1)*detect,1) = 2.032+x_location;  d_geom(32+(iprobe-1)*detect,2) = -1.68+y_location;  d_geom(32+(iprobe-1)*detect,3) =  0.000;
    d_geom(33+(iprobe-1)*detect,1)= 2.54+x_location;  d_geom(33+(iprobe-1)*detect,2)=  -1.68+y_location;  d_geom(33+(iprobe-1)*detect,3)=  0.000;

end

% s_geom(1,1)= 0;  s_geom(1,2) =  4.012;  s_geom(1,3) =  0.000; %angled
% 
% s_geom(2,1) = -1.572;  s_geom(2,2) = 3.345;   s_geom(2,3) = 0.000;
% s_geom(3,1) = -0.524;  s_geom(3,2) = 3.345;   s_geom(3,3) = 0.000; %angled
% s_geom(4,1) =  0.524;  s_geom(4,2) = 3.345;   s_geom(4,3) = 0.000; %angled
% s_geom(5,1) = 1.572;  s_geom(5,2) =  3.345;  s_geom(5,3) =  0.000;
% 
% s_geom(6,1) = -2.096;  s_geom(6,2) = 2.678;   s_geom(6,3) = 0.000;
% s_geom(7,1) = -1.048;  s_geom(7,2) = 2.678;   s_geom(7,3) = 0.000; %angled
% s_geom(8,1) = 0.000;  s_geom(8,2) =  2.678;  s_geom(8,3) =  0.000;
% s_geom(9,1) = 1.048;  s_geom(9,2) = 2.678;   s_geom(9,3) = 0.000; %angled
% s_geom(10,1) =  2.096;  s_geom(10,2) = 2.678;   s_geom(10,3) = 0.000; %angled
% 
% s_geom(11,1) = -2.44475;  s_geom(11,2) =2.043;   s_geom(11,3) = 0.000;%angled 
% s_geom(12,1) = -1.74625;  s_geom(12,2) = 2.043;   s_geom(12,3) = 0.000; %angled 
% s_geom(13,1) = -1.04775;  s_geom(13,2) = 2.043;   s_geom(13,3) = 0.000; %angled
% s_geom(14,1) = -0.34925;  s_geom(14,2) = 2.043;   s_geom(14,3) = 0.000; %angled
% s_geom(15,1) = 0.34925;  s_geom(15,2) = 2.043;   s_geom(15,3) = 0.000; %angled
% s_geom(16,1) = 1.04775;  s_geom(16,2) = 2.043;   s_geom(16,3) = 0.000; %angled
% s_geom(17,1) = 1.74625;  s_geom(17,2) = 2.043;   s_geom(17,3) = 0.000;
% s_geom(18,1) = 2.44475;  s_geom(18,2) =2.043;   s_geom(18,3) = 0.000;
% 
% s_geom(19,1) = -2.794;  s_geom(19,2) =1.408;   s_geom(19,3) = 0.000;%angled 
% s_geom(20,1) = -2.0955;  s_geom(20,2) = 1.408;   s_geom(20,3) = 0.000; %angled
% s_geom(21,1) = -1.397;  s_geom(21,2) = 1.408;   s_geom(21,3) = 0.000;
% s_geom(22,1) = -0.6985;  s_geom(22,2) = 1.408;   s_geom(22,3) = 0.000; %angled
% s_geom(23,1) = 0.00;  s_geom(23,2) = 1.408;   s_geom(23,3) = 0.000;
% s_geom(24,1) = 0.6985;  s_geom(24,2) = 1.408;   s_geom(24,3) = 0.000; %angled
% s_geom(25,1) =  1.397;  s_geom(25,2) = 1.408;   s_geom(25,3) = 0.000; %angled 
% s_geom(26,1) = 2.0955;  s_geom(26,2) = 1.408;   s_geom(26,3) = 0.000; %angled
% s_geom(27,1) = 2.794;  s_geom(27,2) = 1.408;   s_geom(27,3) = 0.000; %angled
% 
% 
% %detector geometry
% d_geom(1,1) = 0.000;  d_geom(1,2) =  -3.581;  d_geom(1,3) =  0.000;
% 
% d_geom(2,1)= -1.746;  d_geom(2,2) =  -3.267;  d_geom(2,3) =  0.000;
% d_geom(3,1)= -1.164;  d_geom(3,2)=  -3.171;  d_geom(3,3)=  0.000;
% d_geom(4,1)= -0.582;  d_geom(4,2)=  -3.171;  d_geom(4,3)=  0.000;
% d_geom(5,1)= 0;  d_geom(5,2)=  -3.075;  d_geom(5,3)=  0.000;
% d_geom(6,1)= 0.582;  d_geom(6,2)=  -3.171;  d_geom(6,3)=  0.000;
% d_geom(7,1)= 1.164;  d_geom(7,2)=  -3.171;  d_geom(7,3)=  0.000;
% d_geom(8,1)= 1.746;  d_geom(8,2)=  -3.267;  d_geom(8,3)=  0.000;
% 
% d_geom(9,1) = -2.667;  d_geom(9,2) = -2.688;  d_geom(9,3) =  0.000;
% d_geom(10,1)= -1.8635;  d_geom(10,2)=  -2.6285;  d_geom(10,3)=  0.000;
% d_geom(11,1) =  -1.016;  d_geom(11,2) =-2.569;   d_geom(11,3) = 0.000;
% d_geom(12,1) = 0; d_geom(12,2) = -2.569;  d_geom(12,3) =  0.000;
% d_geom(13,1)= 1.8635;  d_geom(13,2)=  -2.6285;  d_geom(13,3)=  0.000;
% d_geom(14,1) = 1.016;  d_geom(14,2) =  -2.569;  d_geom(14,3) =  0.000;
% d_geom(15,1) = 2.667;  d_geom(15,2) = -2.688;  d_geom(15,3) =  0.000;
% 
% d_geom(16,1)= -2.032;  d_geom(16,2)=  -2.1245;  d_geom(16,3)=  0.000;
% d_geom(17,1)= -1.524;  d_geom(17,2)=  -2.1245;  d_geom(17,3)=  0.000;
% d_geom(18,1)= -0.508;  d_geom(18,2)=  -2.1245;  d_geom(18,3)=  0.000;
% d_geom(19,1)= 0;  d_geom(19,2)=  -2.1245;  d_geom(19,3)=  0.000;
% d_geom(20,1)= 0.508;  d_geom(20,2)=  -2.1245;  d_geom(20,3)=  0.000;
% d_geom(21,1)= 1.524;  d_geom(21,2)=  -2.1245;  d_geom(21,3)=  0.000;
% d_geom(22,1)= 2.032;  d_geom(22,2)=  -2.1245;  d_geom(22,3)=  0.000;
% 
% 
% d_geom(23,1) = -2.54;  d_geom(23,2) = -1.68;  d_geom(23,3) =  0.000;
% d_geom(24,1) = -2.032;  d_geom(24,2) = -1.68;  d_geom(24,3) =  0.000;
% d_geom(25,1)= -1.524;  d_geom(25,2)=  -1.68;  d_geom(25,3)=  0.000;
% d_geom(26,1)= -1.016;  d_geom(26,2)=  -1.68;  d_geom(26,3)=  0.000;
% d_geom(27,1) = -0.508;  d_geom(27,2) = -1.68;  d_geom(27,3) =  0.000;
% d_geom(28,1)= 0;  d_geom(28,2)=  -1.68;  d_geom(28,3)=  0.000;
% d_geom(29,1) = 0.508;  d_geom(29,2) = -1.68;   d_geom(29,3) = 0.000;
% d_geom(30,1) = 1.016;  d_geom(30,2) = -1.68;  d_geom(30,3) =  0.000;
% d_geom(31,1) = 1.524;  d_geom(31,2) = -1.68;  d_geom(31,3) =  0.000;
% d_geom(32,1) = 2.032;  d_geom(32,2) = -1.68;  d_geom(32,3) =  0.000;
% d_geom(33,1)= 2.54;  d_geom(33,2)=  -1.68;  d_geom(33,3)=  0.000;

% d_geom(11,1) = 2.470; d_geom(11,2) = -1.000;  d_geom(11,3) =  0.000;
% d_geom(12,1)= 2.470;  d_geom(12,2)=  1.000;  d_geom(12,3)=  0.000;
 
% 9 sources 10 channels
% d_geom(1,1)= -4.000;  d_geom(1,2) =  0.000;  d_geom(1,3) =  0.000;
% d_geom(2,1) = -3.000;  d_geom(2,2) = -1.200;  d_geom(2,3) =  0.000;
% % d_geom(3,1) = -3.000;  d_geom(3,2) =  0.000;  d_geom(3,3) =  0.000;
% d_geom(3,1) = -3.000;  d_geom(3,2) =  1.200;  d_geom(3,3) =  0.000;
% d_geom(4,1)= 1.77;  d_geom(4,2)=  - 2.500;  d_geom(4,3)=  0.000;
% d_geom(5,1) = 1.77;  d_geom(5,2) = -1.500;  d_geom(5,3) =  0.000;
% % d_geom(7,1) = 1.77;  d_geom(7,2) = -0.500;  d_geom(7,3) =  0.000;
% % d_geom(8,1) = 1.77;  d_geom(8,2) = 0.500;  d_geom(8,3) =  0.000;
% d_geom(6,1) = 1.77;  d_geom(6,2) = 1.500;  d_geom(6,3) =  0.000;
% d_geom(7,1)= 1.77;  d_geom(7,2)=  2.500;  d_geom(7,3)=  0.000;
% % d_geom(11,1) = 2.470; d_geom(11,2) = -1.000;  d_geom(11,3) =  0.000;
% % d_geom(12,1)= 2.470;  d_geom(12,2)=  1.000;  d_geom(12,3)=  0.000;
% d_geom(8,1)= 2.470;  d_geom(8,2)=  1.000;  d_geom(8,3)=  0.000;
% d_geom(9,1) = 2.470; d_geom(9,2) = -1.000;  d_geom(9,3) =  0.000;
% d_geom(10,1) = 3.000;  d_geom(10,2) =  0.000;  d_geom(10,3) =  0.000;

% figure;
% axis equal
% circle(0,0,5)
% for i=1:9
% hold on
% plot(s_geom(i,1),s_geom(i,2),'o')
% text(s_geom(i,1),s_geom(i,2),num2str(i),'FontWeight', 'bold')
% end
% for j=1:14
% hold on
% plot(d_geom(j,1),d_geom(j,2),'*')
% text(d_geom(j,1),d_geom(j,2),num2str(j),'FontWeight', 'bold');
% end
% legend('source','detector')
%%
% %Nmeas=source*detect;
% Measmnt=[];%zeros(Nmeas,2);
% k1=0;
% sddist = [];
% sddist_matrix = [];
% pairs=zeros(source,detect);
% for ii=1:source;
%    k=(ii-1)*detect;
%    
%    for jj=1:detect;
%       k=k+1;
%       k1=k1+1;
%       sddist_matrix(ii,jj)=sqrt((s_geom(ii,1)-d_geom(jj,1))^2+(s_geom(ii,2)-d_geom(jj,2))^2);
%       sddist(k1)=sddist_matrix(ii,jj);
%       sddist_all(k)=sddist_matrix(ii,jj);
%       if(sddist(k1)<3.0| sddist(k1)>8.5)%|(ii==7 & jj==2)|(ii==8 & jj==2)
%          k1=k1-1;
%          
%       else 
%          Measmnt(k1,2)=jj;
%          Measmnt(k1,1)=ii;
%          pairs(ii,jj)=1;
%       end
%    end
% end    
% Nmeas=size(Measmnt,1);
% Nmeas74=Nmeas;
% Nmeas78=Nmeas;
% Nmeas80=Nmeas;
% Nmeas83=Nmeas;
% sddist = sddist(1:Nmeas);
% sddist_matrix74=sddist_matrix;
% sddist_matrix78=sddist_matrix;
% sddist_matrix80=sddist_matrix;
% sddist_matrix83=sddist_matrix;
% pairs74=pairs;
% pairs78=pairs;
% pairs80=pairs;
% pairs83=pairs;
% Measmnt74=Measmnt;
% Measmnt78=Measmnt;
% Measmnt80=Measmnt;
% Measmnt83=Measmnt;
% sddist74=sddist;
% sddist78=sddist;
% sddist80=sddist;
% sddist83=sddist;

% 
% figure;hist(sddist_matrix);title('s-d distribution')
% us_l=[-1.3 1.3];
% us_w=[-3.3 3.3];
% figure;
% plot(s_geom(:,1),s_geom(:,2),'*')
% hold on
% plot(d_geom(:,1),d_geom(:,2),'o')
% circle(5,0,0)
% legend('source','detector');title('s9d14-new4')
% axis equal;axis([-5 5 -5 5])
% hold on;plot([us_w(1) us_w(1)], us_l)
% hold on;plot([us_w(2) us_w(2)], us_l)
% hold on;plot(us_w, [us_l(1) us_l(1)])
% hold on;plot(us_w, [us_l(2) us_l(2)])
% 
% figure;hist(sddist,300);title('s-d distribution');axis([2 8 0 10])
% figure;hist(sddist_all,300);title('s-d distribution')
% 
% num_3_all=size(sddist,2)
% ratio=size(sddist,2)/(source*detect)
% ratio2=k1/k
%%
Measmnt=[];%zeros(Nmeas,2);
k1=0;
sddist = [];
sddist_matrix = [];
pairs=zeros(source,detect);
for iprobe = 1:n
    for ii=source*(iprobe-1)+1:source*(iprobe-1)+source
        k=(ii-1)*detect;
        
        for jj=detect*(iprobe-1)+1:detect*(iprobe-1)+detect
            k=k+1;
            k1=k1+1;
            sddist_matrix(ii,jj)=sqrt((s_geom(ii,1)-d_geom(jj,1))^2+(s_geom(ii,2)-d_geom(jj,2))^2);
            sddist(k1)=sddist_matrix(ii,jj);
            sddist_all(k)=sddist_matrix(ii,jj);
            if(sddist(k1)<0| sddist(k1)>100)%|(ii==7 & jj==2)|(ii==8 & jj==2)
                k1=k1-1;
                
            else
                Measmnt(k1,2)=jj;
                Measmnt(k1,1)=ii;
                pairs(ii,jj)=1;
            end
        end
    end
    Nmeas=size(Measmnt,1);
    sddist = sddist(1:Nmeas);
end
Nmeas=size(Measmnt,1);
Nmeas74=Nmeas;
Nmeas78=Nmeas;
Nmeas80=Nmeas;
Nmeas83=Nmeas;
sddist = sddist(1:Nmeas);
sddist_matrix74=sddist_matrix;
sddist_matrix78=sddist_matrix;
sddist_matrix80=sddist_matrix;
sddist_matrix83=sddist_matrix;
pairs74=pairs;
pairs78=pairs;
pairs80=pairs;
pairs83=pairs;
Measmnt74=Measmnt;
Measmnt78=Measmnt;
Measmnt80=Measmnt;
Measmnt83=Measmnt;
sddist74=sddist;
sddist78=sddist;
sddist80=sddist;
sddist83=sddist;
figure;
axis equal
us_l=[-1.3 1.3]+5;
us_w=[-3.3 3.3];
hold on;plot([us_w(1) us_w(1)], us_l)
hold on;plot([us_w(2) us_w(2)], us_l)
hold on;plot(us_w, [us_l(1) us_l(1)])
hold on;plot(us_w, [us_l(2) us_l(2)])
% circle(0,0,5)
for i=1:27
    hold on
    plot(s_geom(i,1),s_geom(i,2),'o')
    text(s_geom(i,1),s_geom(i,2),num2str(i),'FontWeight', 'bold')
end
for j=1:detect
    hold on
    plot(d_geom(j,1),d_geom(j,2),'*')
    text(d_geom(j,1),d_geom(j,2),num2str(j),'FontWeight', 'bold');
end
legend('source','detector')