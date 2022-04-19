function EC =  EC_dataset(dataset_name)
events=[];
%% Dataset
if dataset_name == "shapes_trans"
    % Dataset 3: ETH Zurich: events_shapes_translation
    load('.\Data\events_shapes_translation.mat');
    
elseif dataset_name == "shapes_6dof"
    % Dataset 2: ETH Zurich: events_shapes_6dof
    load('.\Data\events_shapes_6dof.mat');
    
elseif dataset_name == "shapes_rot"
    % Dataset 1: ETH Zurich: Shapes_Rotation
    load('.\Data\events_shapes_rotation.mat');
    
else                                                    % Default: Shapes_Rotation
    % Dataset 1: ETH Zurich: Shapes_Rotation
    load('.\Data\events_shapes_rotation.mat');
    
end
EC.DataT = events(:,"VarName1");
EC.DataX = events(:,"VarName2");
EC.DataY = events(:,"VarName3");
EC.DataP = events(:,"VarName4");
end
