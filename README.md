# Cell State Transition

The cellular state transition is a common phenomenon observed during embryogenesis, wound healing, cancer metastasis. The state of a cell can be defined based on either molecular features like gene expression, protein expression, or functional features like change in morphology, migration potential of cells. Various signaling molecules induce cell state transition. The dynamics of state transition depends on the strength and the duration of the signaling molecules. In this project, we have developed a mathematical model to study cell state transition dynamics.

## State Transition Model

Cell state transition trajectories can be estimated through continuous monitoring of cells using live-cell imaging for a prolonged time. This experimental setup is costly and time-consuming. On the other hand, collecting cell population data at discrete time-points is much easier and cheaper. Our model estimates the trajectories of cell state transition from discrete-time population aggregate data.

The model performs piece-wise data fitting. The model estimates the fraction of cells moving from one state to the other state for each time interval (t, t+&#916;t). Our model considers the transition of cells from one state to another state, cell division, and cell death in the estimation of state transition trajectories. Cell death is considered as a separate cell state and the transition from dead cell state to other states are considered zero. Cell division is estimated from the model. 

The estimation strategy involves two steps. First, we estimate the fractional cell division for each time interval. Using this data, we estimate the fractional state transition for each time interval. 

The complete model is developed in MATLAB and is easy to implement. This model is implemented in the study, [Morphological State Transition Dynamics in EGF-Induced Epithelial to Mesenchymal Transition](https://www.mdpi.com/2077-0383/8/7/911/htm). The detailed information about the model and the mathematical equations are available in the [supplementary material](https://www.mdpi.com/2077-0383/8/7/911#supplementary) of the [article](https://www.mdpi.com/2077-0383/8/7/911).

## Input data to the model

#### 1. Fraction of each cell state at the observed time points

If there are _n_ different time points and _m_ different cell states and _p_ replicates of the experiment, then the input data should follow the below structure,

|    conditions   |    time_1    | time_1 |    time_1    | ... |    time_n    | time_n |    time_n    |
| --------------- | ------------ | ------ | ------------ | --- | ------------ | ------ | ------------ |
| __replicate_1__ | cell_fract_1 | ...    | cell_fract_m-1 | ... | cell_fract_1 | ...    | cell_fract_m-1 |
| __...__         | ...          | ...    | ...          | ... | ...          | ...    | ...          |
| __replicate_p__ | ...          | ...    | ...          | ... | ...          | ...    | ...          |

The data in each column are the fractions of different cell states. There __should not be any headers__ in the actual input excel sheet. The data should follow the same structure as shown in the above table. __Here, _m-1_ denotes the number of cell states excluding dead cell state__. The summation of cell fractions of all cell state at a given time point is one. Fraction of dead cell state can be estimated from the other cell states and the dead cell state do not add any extra information to the model fitting. Therefore, the fraction of dead cell state will not be used in the model. Detailed information about the model structure and the undrlying assumptions are available in the [supplementary material](https://www.mdpi.com/2077-0383/8/7/911#supplementary) of the [article](https://www.mdpi.com/2077-0383/8/7/911).

#### 2. Fold change in cell population between successive time points

Fold change in total cell population (live+dead) is calculated for every successive time interval. If there are _n_ different observed time points, there would be _n-1_ time intervals. The input data should follow the below structure,

|  conditions |    time_1   | ... |   time_n-1  |
| ----------- | ----------- | --- | ----------- |
| __replicate_1__ | fold_change | ... | fold_change |
| __...__         | ...         | ... | ...         |
| __replicate_p__ | ...         | ... | ...         |

The data in each column are the fold change in total cell population. There __should not be any headers__ in the actual input excel sheet. The data should follow the same structure as shown in the above table.

#### 3. Fractional cell division of each cell state for each time interval

The model estimates fractional cell division from the above two input data. This data serves as th einput for the second part of the model, where fractional state transition parameters are estimated. Fractional cell division of each cell state is estimated for every successive time interval. If th ere are _n_ different observed time points and _m_ different cell states, there would be _n-1_ time intervals. The input data should follow the below structure,

|  conditions |     time_1     | ... |    time_n-1    |
| ----------- | -------------- | --- | -------------- |
| __cell_state_1__ | fract_cell_div | ... | fract_cell_div |
| __...__         | ...            | ... | ...            |
| __cell_state_m__ | ...            | ... | ...            |

The data in each column are the fractions of cell division of different cell states. There __should not be any headers__ in the actual input excel sheet. The data should follow the same structure as shown in the above table.

## Instructions to use the model

#### 1. Estimation of the fraction of cell division:

The MATLAB code to estimate the fraction of cell division for each time interval is available [here](FractionalCellDivisionEstimationCode/main.m). The input parameters of the model are defined in the earlier section of the `main.m` file. This module requires the following input details:

   * `popFraction` reads the fraction of cell population at the observed time points from the excel sheet `FractionCellType.xlsx`. __The excel sheet should not contain any row or column headers.__
   * `foldChange` reads the fold change in cell population from the excel sheet `FoldChange.xlsx`. __The excel sheet should not contain any row or column headers.__
   * `noOfUnk` reads the number of unknown parameters. It is the product of the number of cell states and the number of observed time intervals. For example, If there are three cell states observed at five discrete time intervals, `noOfUnk`=15.
   * `noCellState` reads the number of cell states.

Download the [code](FractionalCellDivisionEstimationCode/main.m) and place the input excel sheets in the same location of the downloaded code. Open the `main.m` file in matlab and enter the input details. 

Now, run the `main.m` file. The unknown parameters are estimated by [linear least square method](https://in.mathworks.com/help/optim/ug/lsqlin.html). The following are exported from the model:

   * The estimated parameters are exported to a tab-delimited text file, `fractionalCellDivision.txt`. Each row represents the fractional cell division of each cell state, and the columns represent the fractional cell division for each time interval.
   * The residuals are exported to a tab-delimited text file, `residual.txt`. Residuals are the difference between the observed fold change and the simulated fold change. Each column represents the residual for each observed time interval, and the row represents the residuals of the experimental replicates.

#### 2. Estimation of the fraction of cell state transition:

The MATLAB code to estimate the fraction of cell state transition for each time interval is available [here](FractionalStateTransitionEstimationCode/). The folder contains multiple matlab files. A short description of each matlab function is provided in the header section of the respective matlab file. The input parameters of the model are defined in the `main.m` file. This module requires the following input details:

   * `popFract` reads the fraction of cell population at the observed time points from the excel sheet `FractionCellType.xlsx`. __The excel sheet should not contain any row or column headers.__
   * `foldChange` reads the fold change in cell population from the excel sheet `FoldChange.xlsx`. __The excel sheet should not contain any row or column headers.__
   * `cellDiv` reads the fractional cell division from the excel sheet `CellDivisionFraction.xlsx` . __The excel sheet should not contain any row or column headers.__
   * `numOfUnknown` reads the number of unknown parameters. It is the product of the square of the number of cell states and the number of observed time intervals. For example, If there are three cell states observed at five discrete time intervals, `noOfUnk`=45.
   * `numCellState` reads the number of cell states.
   * `numOptRun` reads the number independent optimisation runs.

Download all the [.m files](FractionalStateTransitionEstimationCode/). Place the input excel sheets in the same location of the downloaded matlab files. Open the `main.m` file in matlab and the enter the input details. Enter the location of all downloaded matlab files in the header of the `main.m` file using `addpath`. For example, If the matlab files are in the location, `C:\xxx\yyy\` then include `addpath('C:\xxx\yyy\')` in the header of the `main.m` file. 

This module uses [multiobjective genetic algorithm](https://in.mathworks.com/help/gads/gamultiobj.html) to estimate the unknown parameters. Configurations of the genetic algorithm are defined in `initialise.m`. If required the user can edit the parameters in `initialise.m`. The description about each parameter are available in [mathworks](https://in.mathworks.com/help/gads/gamultiobj.html). 

Now, run the `main.m` file. The optimisation runs in parallel depending on the number of independent optimisations defined by the user. A [pareto front](https://in.mathworks.com/help/gads/examples/performing-a-multiobjective-optimization-using-the-genetic-algorithm.html) will be estimated for each independent optimisation and the best solution for each independent optimisation will be computed using [knee point](https://in.mathworks.com/matlabcentral/fileexchange/35094-knee-point). A subfolder will be created for each independent optimisations in the working directory and the results are exported to the corresponding subfolders.

The following are exported to subfolders of each optimisation runs:

   * Pareto front of the multiobjective optimisation is exported to a tab-delimited text file, `paretoFront.txt`. First column represents the objective function 1 and the second column represents the objective function 2.
   * Pareto front of the multiobjective optimisation is exported to a jpg file, `paretoFront.jpg`.
   * `bestObjFun.txt` is the best of all solutions in the pareto front. First column represents objective function 1 and the second column represents objective function 2.
   * Best of all solutions in the pareto front is exported to a tab-delimited text file, `bestConvergedFract.txt`. The data are exported without row/column headers in a single 2D matrix with the following structure,

|       time_1       | cell_state_1 | ... | cell_state_m-1 |
|--------------------|--------------|-----|----------------|
| __cell_state_1__   | ...          | ... | ...            |
| __...__            | ...          | ... | ...            |
| __cell_state_m-1__ | ...          | ... | ...            |

|      time_n-1      | cell_state_1 | ... | cell_state_m-1 |
|--------------------|--------------|-----|----------------|
| __cell_state_1__   | ...          | ... | ...            |
| __...__            | ...          | ... | ...            |
| __cell_state_m-1__ | ...          | ... | ...            |

Once all the independent optimisations are completed, the data extraction process begins. The best solution from each optimisation run will be extracted and exported to a tab delimited text file, `bestOfEachRun.txt` in the working directory. The solution with minimum objective function 1 is the most optimal solution of all runs and the corresponding converged state transition fractions are the optimal state transition parameters. The index of the optimal run and the details of the objective function are exported to a tab delimited text file, `summary.txt` in the working directory. 

## Citing the model

Devaraj V., Bose B. Morphological State Transition Dynamics in EGF-induced Epithelial to Mesenchymal Transition. Journal of clinical medicine [doi: 10.3390/jcm8070911](https://www.mdpi.com/2077-0383/8/7/911).

## Authors

   * Vimalathithan Devaraj
   * Biplab Bose

## License

Usage and redistribution of this matlab package with or without modification is permitted.

The matlab function `knee_pt.m` used in this model was developed by Kaplan, Dmitry (2012). [Knee Point, MATLAB Central File Exchange](https://in.mathworks.com/matlabcentral/fileexchange/35094-knee-point).

Copyright (c) 2012, Dmitry Kaplan
All rights reserved.

Disclaimer: THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
POSSIBILITY OF SUCH DAMAGE.
