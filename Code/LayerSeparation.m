function [v_loc,num_loc,depth_info] = LayerSeparation(v_geom,z_radius,depth,v_tot)
%% This code works for shape based reconstruction, get different reconstruction layer 
%  information.
% Input: 
    % v_geom: the coordinators of dual-mesh voxels
    % voxel: the index of dual-mesh voxels
    % z_radius: target size
    % depth: target depth
    % v_tot: the total voxels number need to be considered
% Output:
    % v_loc: just count how many voxels belongs to which layers
    
%% First depends on target size, choose how many layers need to be documented
% Also record the depth needed to be sepcificated.
if z_radius == 0.49
    nLayer = 1;
    depth_info = [depth];
elseif z_radius == 0.7
    nLayer = 2;
    depth_info = [depth-0.25,depth+0.25];
elseif z_radius == 0.99
    nLayer = 3;
    depth_info = [depth-0.5,depth,depth+0.5];
elseif z_radius == 1.24
    nLayer = 4;
    depth_info = [depth-0.75,depth-0.25,depth+0.25,depth+0.75];
elseif z_radius == 1.49
    nLayer = 5;
    depth_info = [depth-1,depth-0.5,depth,depth+0.5,depth+1];
end

%% Got the voxel and 
v_loc = cell(nLayer,1);
num_loc = zeros(nLayer,1);
for lIdx = 1:nLayer
    v_loc{lIdx} = find(abs(v_geom(1:v_tot,3)-depth_info(lIdx))<0.01);
    num_loc(lIdx) = size(v_loc{lIdx},1);
end