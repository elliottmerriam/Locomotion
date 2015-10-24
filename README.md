This repository holds Matlab functions to import, process and analyze mouse locomotion data, 
in particular to capture and record bouts of immobility referred to as "freezing."
This was primarily a data wrangling effort, owing to experimental data coming from
multiple disparate sources and formats.

1) Script Etho_MA-FC_9-30-13.m imports and preprocesses experimental data, and then calls
the EthoReader3 function

2) EthoReader.m receives raw data containing X,Y coordinates of the mouse's body as input 
from Etho_MA-FC_9-30-13.m, then converts the coordinates into distance and velocity data, 
which are then parsed into sections of experimental significance (such as times when the 
animal received specific cues).  EthoReader calls the FindFreezing2 function and, optionally, 
the FCPlot function.

3) FindFreezing2.m takes velocity input data from EthoReader.m, as well as a threshold velocity
below which the animal is considered immobile.  FindFreezing2 identifies bouts of prolonged
immobility, which are considered "freezing" behavior, and measures how much time the animal
froze during different experimentally significant events (e.g., cue presentations), and 
returns this freezing data to EthoReader.m.

4) FCPlot.m, if called, plots data related to freezing behavior for the experiment.

5) EthoReader.m returns the freezing data returned from FindFreezing2.m, and the velocity data from the 
experiment, and general information about the experiment (which mouse, which day, etc.) to 
Etho_MA-FC_9-30-13.m 

6) Etho_MA-FC_9-30-13.m sets a threshold amount of time to consider "true" freezing, and calls FCAnalysis2.m

7) FCAnalysis2.m takes data related to bouts of immobility for all mice and experiments, and
computes the % of time each animal froze during each relevant part of each experiment.  This
final processed data is returned to Etho_MA-FC_9-30-13.m.

8) Etho_MA-FC_9-30-13.m does some final re-arranging of the data.  This is necessary mostly 
because different experiments contain different sequences of events, and so were handled 
separately in the earlier pre-processing performed by Etho_MA-FC_9-30-13.m.  So now the data
is being "put back together again."
