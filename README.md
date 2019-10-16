# State Transition
The cellular state transition is a common phenomenon observed during embryogenesis, wound healing, cancer metastasis. The state of a cell can be defined based on either molecular features like gene expression, protein expression, or functional features like change in morphology, migration potential of cells. Various signaling molecules induce cell-state transition. The dynamics of state transition depends on the strength and the duration of the signaling molecules. In this project, we have developed a mathematical model to study cell state transition dynamics.

Cell state transition trajectories can be estimated through continuous monitoring of cells using live-cell imaging for a prolonged time. This experimental setup is costly and time-consuming. On the other hand, collecting cell population data at discrete time-points is much easier and cheaper. Our model estimates the trajectories of cell state transition from discrete-time population aggregate data.

The model estimates the fraction of cells transiting from one state to the other state for each time interval. Our model considers the transition of cells from one state to another state, cell division, and cell death in the estimation of state transition trajectories. The estimation strategy involves two steps. First, we estimate the fractional cell division for each time interval. Using this data, we estimate the fractional state transition for each time interval.

The complete model is developed in MATLAB and is easy to implement. This model is implemented in studying the [Morphological State Transition Dynamics in EGF-Induced Epithelial to Mesenchymal Transition](https://www.mdpi.com/2077-0383/8/7/911/htm). The detailed information about the model and the mathematical equations are available in the [supplementary material](https://www.mdpi.com/2077-0383/8/7/911#supplementary) of the article.

# Input data to the model
The model requires the following data:
    * Fraction of each cell state at the observed time points
    * Fold change in cell population between successive time points

# How to run the model?
1. Estimation of fraction of cell division:
    The MATLAB code to estimate the fraction of cell division for each time interval is available [here](FractionalCellDivisionEstimationCode/main.m). The input parameters to the model are defined in the earlier section of the code. This module requires the following input details:

        * `popFraction` reads the fraction of cell population at the observed time points from the excel sheet `FractionCellType.xlsx`. The excel sheet should not contain any row or column headers. Each column represents the fraction of cells in each state. For successive time points, the data are entered in the same fashion continuouly along the column without changing the order. Each rows represents the experimental replicates.
        * `foldChange` reads the fold change in cell population from the excel sheet `FoldChange.xlsx`. The excel sheet should not contain any row or column headers. Each column represents the fold change in cell population between two successive time points. Each rows represents the experimental replicates.
        * `noOfUnk` reads the number of unknown parameters. It is given by the number of cell states mutiplied by the number of observed time intervals. For example, If there are three cell states observed at five discrete time interval, `noOfUnk`=15.
        * `noCellState` reads the number of cell states
    
    Download the [code](FractionalCellDivisionEstimationCode/main.m) and place the input excel sheets in the same location of the downloaded code. Open the `main.m` file in matlab and the enter the input details. Now, run the `main.m` file. The unknown parameters are estimated by [linear leat square method](https://in.mathworks.com/help/optim/ug/lsqlin.html). The following are exported from the model:
        * The estimated parameters are exported to a tab delimited text file, `fractionalCellDivision.txt`. Each row represents the fractional cell division of each cell type and the columns represents the fractional cell division for each time innterval.
        * The residuals are exported to a tab delimited text file, `residual.txt`. Residuals are the difference between the observed fold change and the simulated fold change. Each column represents the residual for each observed time interval and the row represents the residuals of the experimental replicates.
