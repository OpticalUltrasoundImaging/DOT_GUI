%clear all

source=9
detect=14

% source geometry
s_geom = zeros(source,3);
d_geom = zeros(detect,3);

s_geom(1,1) = -3.000;  s_geom(1,2) = -2.5;   s_geom(1,3) = 0.000;
s_geom(2,1) =  -3.000;  s_geom(2,2) = 2.5;   s_geom(2,3) = 0.000;

s_geom(3,1) = -1.7500;  s_geom(3,2) =-3.000;   s_geom(3,3) = 0.000;
s_geom(4,1) = -1.7500;  s_geom(4,2) = -1.500;   s_geom(4,3) = 0.000;
s_geom(5,1) = -1.7500;  s_geom(5,2) = 0.000;   s_geom(5,3) = 0.000;
s_geom(6,1) =  -1.7500;  s_geom(6,2) = 1.500;   s_geom(6,3) = 0.000;
s_geom(7,1) = -1.7500;  s_geom(7,2) = 3.000;   s_geom(7,3) = 0.000;

s_geom(9,1)= -4.500;  s_geom(9,2) =  0.000;  s_geom(9,3) =  0.000;
s_geom(8,1) = -3.000;  s_geom(8,2) =  0.000;  s_geom(8,3) =  0.000;

%  d_geom(13,1) =  3.000;  d_geom(13,2) =-2.50;   d_geom(13,3) = 0.000;
%  d_geom(14,1) = 3.000;  d_geom(14,2) = 2.50;   d_geom(14,3) = 0.000;

%detector geometry

d_geom(1,1) =  3.000;  d_geom(1,2) =-2.50;   d_geom(1,3) = 0.000;
d_geom(4,1) = 3.000;  d_geom(4,2) = 2.50;   d_geom(4,3) = 0.000;

d_geom(2,1) = 3.500;  d_geom(2,2) = -1.200;  d_geom(2,3) =  0.000;
d_geom(3,1) = 3.500;  d_geom(3,2) =  1.200;  d_geom(3,3) =  0.000;

d_geom(5,1)= 1.77;  d_geom(5,2)=  - 2.500;  d_geom(5,3)=  0.000;
d_geom(6,1) = 1.77;  d_geom(6,2) = -1.500;  d_geom(6,3) =  0.000;
d_geom(7,1) = 1.77;  d_geom(7,2) = -0.500;  d_geom(7,3) =  0.000;
d_geom(8,1) = 1.77;  d_geom(8,2) = 0.500;  d_geom(8,3) =  0.000;
d_geom(9,1) = 1.77;  d_geom(9,2) = 1.500;  d_geom(9,3) =  0.000;
d_geom(10,1)= 1.77;  d_geom(10,2)=  2.500;  d_geom(10,3)=  0.000;
% d_geom(11,1) = 2.470; d_geom(11,2) = -1.000;  d_geom(11,3) =  0.000;
% d_geom(12,1)= 2.470;  d_geom(12,2)=  1.000;  d_geom(12,3)=  0.000;
d_geom(11,1)= 2.470;  d_geom(11,2)=  1.000;  d_geom(11,3)=  0.000;
d_geom(12,1) = 2.470; d_geom(12,2) = -1.000;  d_geom(12,3) =  0.000;

 d_geom(13,1) = 3.000;  d_geom(13,2) =  0.000;  d_geom(13,3) =  0.000;
 d_geom(14,1)= 4.000;  d_geom(14,2) =  0.000;  d_geom(14,3) =  0.000;


%% 9 sources 10 channels
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

%figure;
%axis equal
%circle(5,0,0)
%plot(s_geom(:,1),s_geom(:,2),'o')
%hold on
%plot(d_geom(:,1),d_geom(:,2),'*')
%legend('source','detector')

%Nmeas=source*detect;
Measmnt=[];%zeros(Nmeas,2);
k1=0;
sddist = [];
sddist_matrix = [];
pairs=zeros(source,detect);
for ii=1:source;
   k=(ii-1)*detect;
   
   for jj=1:detect;
      k=k+1;
      k1=k1+1;
      sddist_matrix(ii,jj)=sqrt((s_geom(ii,1)-d_geom(jj,1))^2+(s_geom(ii,2)-d_geom(jj,2))^2);
      sddist(k1)=sddist_matrix(ii,jj);
      sddist_all(k)=sddist_matrix(ii,jj);
      if(sddist(k1)<3.1| sddist(k1)>8)%|(ii==7 & jj==2)|(ii==8 & jj==2)
         k1=k1-1;
         
      else 
         Measmnt(k1,2)=jj;
         Measmnt(k1,1)=ii;
         pairs(ii,jj)=1;
      end
   end
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

