# Event Camera Based Multiple Target Tracking
This is a research project for ROB 590 Independent Study for Winter 2022 at the University of Michigan. The goal of this project is to perform Multiple Target Tracking for Event Camera Data. The work has been evaluated on 3 indoor datasets collected by the research group at the University of Zurich, for target tracking using event streams. 
## Installations
Clone the repository
```
git clone git@github.com:rastri-dey/Event_Camera_MTT.git
mkdir Data
```
Download the dataset from https://rpg.ifi.uzh.ch/davis_data.html.
The dataset are available in zip format of text files. Convert the .txt files in MATLAB table format and save as .mat files indicated below:
```
Save "shapes_rotation.txt" as "events_shapes_rotation.mat"
Save "shapes_translation.txt" as "events_shapes_translation.mat"
Save "shapes_6dof.txt" as "events_shapes_6dof.mat"
```
Run the main file.
```
Event_Camera_Multiple_Target_Tracking.m
```

## Result
### Target Trajectory for Shapes_rotation sequence
![](images/Cluster_Track_ValGate.jpg)
![](images/GT_Traj_X_shapes_Rot.jpg)
![](images/Evaluation_Error_Table.jpg)

## Acknowledgement
Professor Katie Skinner for ROB 590 in Winter 2022.
