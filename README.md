# Cell State Transition
The cellular state transition is a common phenomenon observed during embryogenesis, wound healing, cancer metastasis. The state of a cell can be defined based on either molecular features like gene expression, protein expression, or functional features like change in morphology, migration potential of cells. Various signaling molecules induce cell state transition. The dynamics of state transition depends on the strength and the duration of the signaling molecules. In this project, we have developed a mathematical model to study cell state transition dynamics.

## State Transition Model
Cell state transition trajectories can be estimated through continuous monitoring of cells using live-cell imaging for a prolonged time. This experimental setup is costly and time-consuming. On the other hand, collecting cell population data at discrete time-points is much easier and cheaper. Our model estimates the trajectories of cell state transition from discrete-time population aggregate data.

The model performs piece-wise data fitting. The model estimates the fraction of cells moving from one state to the other state for each time interval (t, t+&#916;t). Our model considers the transition of cells from one state to another state, cell division, and cell death in the estimation of state transition trajectories. The estimation strategy involves two steps. First, we estimate the fractional cell division for each time interval. Using this data, we estimate the fractional state transition for each time interval.

The complete model is developed in MATLAB and is easy to implement. This model is implemented in the study, [Morphological State Transition Dynamics in EGF-Induced Epithelial to Mesenchymal Transition](https://www.mdpi.com/2077-0383/8/7/911/htm). The detailed information about the model and the mathematical equations are available in the [supplementary material](https://www.mdpi.com/2077-0383/8/7/911#supplementary) of the [article](https://www.mdpi.com/2077-0383/8/7/911).

## Input data to the model
The model requires the following data:

### 1. Fraction of each cell state at the observed time points

   If there are _n_ different time points and _m_ different cell types, then the input data should follow the below structure,

|  condition  | CellType-1 | 123 | CellType-m | 123 | CellType-1 | 123 | CellType-m |
|-------------|------------|-----|------------|-----|------------|-----|------------|
| Replicate-1 |        123 | 123 |        123 | 123 |        123 | 123 |        123 |
| 123         |        123 | 123 |        123 | 123 |        123 | 123 |        123 |
| Replicate-p |        123 | 123 |        123 | 123 |        123 | 123 |        123 |

   * Fold change in cell population between successive time points

## Instructions to use the model
### 1. Estimation of the fraction of cell division:
The MATLAB code to estimate the fraction of cell division for each time interval is available [here](FractionalCellDivisionEstimationCode/main.m). The input parameters of the model are defined in the earlier section of the code. This module requires the following input details:

   * `popFraction` reads the fraction of cell population at the observed time points from the excel sheet `FractionCellType.xlsx`. The excel sheet should not contain any row or column headers. Each column represents the fraction of cells in each state. For successive time points, the data are entered in the same fashion continuously along the column without changing the order. Each row represents the experimental replicates.
   * `foldChange` reads the fold change in cell population from the excel sheet `FoldChange.xlsx`. The excel sheet should not contain any row or column headers. Each column represents the fold change in cell population between two successive time points. Each row represents the experimental replicates.
   * `noOfUnk` reads the number of unknown parameters. It is given by the number of cell states multiplied by the number of observed time intervals. For example, If there are three cell states observed at five discrete time intervals, `noOfUnk`=15.
   * `noCellState` reads the number of cell states.

Download the [code](FractionalCellDivisionEstimationCode/main.m) and place the input excel sheets in the same location of the downloaded code. Open the `main.m` file in matlab and enter the input details. Now, run the `main.m` file. The unknown parameters are estimated by [linear least square method](https://in.mathworks.com/help/optim/ug/lsqlin.html). The following are exported from the model:

   * The estimated parameters are exported to a tab-delimited text file, `fractionalCellDivision.txt`. Each row represents the fractional cell division of each cell type, and the columns represent the fractional cell division for each time interval.
   * The residuals are exported to a tab-delimited text file, `residual.txt`. Residuals are the difference between the observed fold change and the simulated fold change. Each column represents the residual for each observed time interval, and the row represents the residuals of the experimental replicates.

### 2. Estimation of the fraction of cell state transition:
The MATLAB code to estimate the fraction of cell state transition for each time interval is available [here](FractionalStateTransitionEstimationCode/). The folder contains multiple matlab files. A short description of each matlab function is provided in the header section of the matlab file. The input parameters of the model are defined in the `main.m` file. This module requires the following input details:

   * `popFract` reads the fraction of cell population at the observed time points from the excel sheet `FractionCellType.xlsx`. The excel sheet should not contain any row or column headers. Each column represents the fraction of cells in each state. For successive time points, the data are entered in the same fashion continuously along the column without changing the order. Each row represents the experimental replicates.
   * `foldChange` reads the fold change in cell population from the excel sheet `FoldChange.xlsx`. The excel sheet should not contain any row or column headers. Each column represents the fold change in cell population between two successive time points. Each row represents the experimental replicates.
   * `cellDiv` reads the fractional cell division estimated from the previous section. The input excel sheet `CellDivisionFraction.xlsx` should not contain any row or column headers. Each row represents the fractional cell division of each cell type, and the columns represent the fractional cell division for each time interval.
   * `numOfUnknown` reads the number of unknown parameters. It is given by the square of the number of cell states multiplied by the number of observed time intervals. For example, If there are three cell states observed at five discrete time intervals, `noOfUnk`=45.
   * `numCellState` reads the number of cell states.
   * `numOptRun` reads the number independent optimisation runs.

Download the all the [.m files](FractionalStateTransitionEstimationCode/). Place the input excel sheets in the same location of the downloaded matlab files. Open the `main.m` file in matlab and the enter the input details. Enter the location of all downloaded matlab files in the header of the `main.m` file using `addpath`. For example, If the matlab files are in the location, `C:\xxx\yyy\` then include `addpath('C:\xxx\yyy\')` in the header of the `main.m` file. This module uses [multiobjective genetic algorithm](https://in.mathworks.com/help/gads/gamultiobj.html) to estimate the unknown parameters. Configurations of the genetic algorithm are defined in `initialise.m`. If required the user can edit the parameters in `initialise.m`. The description about each parameter are available in [mathworks](https://in.mathworks.com/help/gads/gamultiobj.html). 

Now, run the `main.m` file. The optimisation runs in parallel depending on the number of independent optimisations defined by the user. A [pareto front](https://in.mathworks.com/help/gads/examples/performing-a-multiobjective-optimization-using-the-genetic-algorithm.html) will be estimated for each independent optimisation and the best solution for each independent optimisation will be computed using [knee point](https://in.mathworks.com/matlabcentral/fileexchange/35094-knee-point). A subfolder will be created for each independent optimisations in the working directory and the results are exported to the corresponding subfolders. The following are exported from the model:

   * Pareto front of the multiobjective optimisation is exported to a tab-delimited text file, `paretoFront.txt`. First column represents the objective function 1 and the second column represents the objective function 2.
   * Pareto front of the multiobjective optimisation is exported to a jpg file, `paretoFront.jpg`.
   * `convergedFract.txt` is the converged fractions of state transition parameters of each solution in the pareto front. Columns represent the converged state transition parameters, and the rows represent the converged solutions of each data point on pareto front.
   * Best of all solutions in the pareto front is exported to a tab-delimited text file, `bestConvergedFract.txt`.

## Citing the model

Devaraj V., Bose B. Morphological State Transition Dynamics in EGF-induced Epithelial to Mesenchymal Transition. Journal of clinical medicine [doi: 10.3390/jcm8070911](https://www.mdpi.com/2077-0383/8/7/911).

## Authors

   * Vimalathithan Devaraj
   * Biplab Bose

## License

## Downloads

[![Github All Releases](https://img.shields.io/github/downloads/git@github.com:biplabbose/StateTransition.git/total.svg)]()