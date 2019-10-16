# State Transition
The cellular state transition is a common phenomenon observed during embryogenesis, wound healing, cancer metastasis. The state of a cell can be defined based on either molecular features like gene expression, protein expression, or functional features like change in morphology, migration potential of cells. Various signaling molecules induce cell-state transition. The dynamics of state transition depends on the strength and the duration of the signaling molecules. In this project, we have developed a mathematical model to study cell state transition dynamics.

Cell state transition trajectories can be estimated through continuous monitoring of cells using live-cell imaging for a prolonged time. This experimental setup is costly and time-consuming. On the other hand, collecting cell population data at discrete time-points is much easier and cheaper. Our model estimates the trajectories of cell state transition from discrete-time population aggregate data.

The model estimates the fraction of cells transiting from one state to the other state for each time interval. Our model considers the transition of cells from one state to another state, cell division, and cell death in the estimation of state transition trajectories. The estimation strategy involves two steps. First, we estimate the fractional cell division for each time interval. Using this data, we estimate the fractional state transition for each time interval.

The complete model is developed in MATLAB and is easy to implement. The detailed information about the model is available in the research article, FLAG.

# Input data to the model