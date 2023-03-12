function [Nvxls,v_vol_L,v_vol_N,v_geom,voxel,v_tot,vx,vy,vz,vx1,vy1,vz1,nvz,nvy]...
    = born_sphare1_func_yz (xy_x_radius,xy_y_radius,z_radius,xy_grid,n_depth,rtg,probe_x,probe_y,probe_z,z_step_value)

% these four are defined on imager_4wvl
z_step = z_step_value;  % 0.5
lx = probe_x;           % 4.5 cm in x as default
ly = probe_y;           % 4.5 cm in y as default
lz = probe_z;           % 3.0 cm in z as default
x_grid = 1.5;
y_grid = xy_grid;
center = rtg;   % rtg = [xcenter_position ycenter_position depth];

v_vol_L = x_grid*y_grid*0.1; % voxel volume
% vz = n_depth:z_step:lz+n_depth;
vy = -ly:y_grid:ly;
vx = -lx:x_grid:lx;
vz = 0.1:0.1:3.7;

vz1=0.1:0.6:3.7;
% vz1=n_depth:1.0:lz+n_depth;
vy1=-probe_y:1.5:probe_y;
% vx1=vy1;
vx1=0;

nvx = length(vx);	% number of voxels in x
nvy = length(vy);	% number of voxels in y
nvz = length(vz);	% number of voxels in z

i = 0;
aa = 0;

for z = 1:nvz
    for y = 1:nvy
        for x = 1:nvx
            if (abs(vz(z)-center(3))<=z_radius)
                
                x_a=(vx(x)-center(1))/xy_x_radius;
                y_b=(vy(y)-center(2))/xy_y_radius;
                z_c=(vz(z)-center(3))/z_radius;

                if (x_a^2+y_b^2+z_c^2<=1)
                    i=i+1;
                    v_geom(i,1) = vx(x);
                    v_geom(i,2) = vy(y);
                    v_geom(i,3) = vz(z);

                    voxel(i,1) = x;
                    voxel(i,2) = y;
                    voxel(i,3) = z;
                end
            end
        end
    end
    aa(z)=i;
end

v_tot = i;

nvx1=length(vx1);
nvy1=length(vy1);
y_grid_n=1.5;
z_grid_n=0.6;
x_step_n=1.5;

v_vol_N = x_step_n*y_grid_n*z_grid_n;
p=v_tot;
for z = 1:length(vz1)
    for y = 1:length(vy1)
        for x = 1:length(vx1)
            p=p+1;
            v_geom(p,1) = vx1(x);
            v_geom(p,2) = vy1(y);
            v_geom(p,3) = vz1(z);
            voxel(p,1) = x;
            voxel(p,2) = y;
            voxel(p,3) = z;
        end
    end
end

Nvxls = p;