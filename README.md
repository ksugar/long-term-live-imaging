# Long-term Live Imaging, Cell Identification, and Cell Tracking in Regenerating Crustacean Legs

This repository contains tools, scripts, and configurations for analyzing long-term live imaging data, focusing on cell detection and tracking in regenerating crustacean legs. It integrates evaluation methodologies from [the Cell Tracking Challenge](https://celltrackingchallenge.net/) and provides a structured workflow for evaluating detection and tracking results.

## Repository Structure

- **configs/**  
  Contains configuration files (e.g. `elephant_main_settings.yaml`), which define the settings for the analysis by [Elephant](https://elephant-track.github.io).

- **CTC_evals/**  
  Includes ground-truth data and evaluation results in [the Cell Tracking Challeng format](https://public.celltrackingchallenge.net/documents/Naming%20and%20file%20content%20conventions.pdf).

- **EvaluationSoftware/Linux/**  
  Downloads [the Cell Tracking Challenge evaluation command-line software for Linux](http://public.celltrackingchallenge.net/software/EvaluationSoftware.zip) and place here.

- **outputs/**  
  Stores the output results of the evaluation, organized by dataset and processing method.

- **scripts/**  
  Includes utility scripts for analyzing tasks: summarizing detection errors (`summarize_det_errors.sh`), tracking errors (`summarize_tra_errors.sh`), and both (`evaluate_det_tra.sh`) after running the CellTrackingChallenge evaluation. The directory also contains scripts for locating errors along the Z-axis (`locate_errors.sh`).

- **src/**  
  Contains the Python code for the evaluation pipeline and related utilities.

- requirements.txt  
  Lists the required Python packages for the analysis. Install them using `pip install -r requirements.txt`.

- README.md
  Provides an overview of the repository, its structure, and instructions for use.

- LICENSE
  Contains the license information for the repository.

## Prerequisites

- **Operating System**: Linux  
- **CellTrackingChallenge Evaluation Software**  
  - [Documentation](https://celltrackingchallenge.net/evaluation-methodology/)  
  - [Download EvaluationSoftware.zip](http://public.celltrackingchallenge.net/software/EvaluationSoftware.zip)
- **Python**: Version 3.12 or higher
  - `pip install -r requirements.txt` to install required Python packages.  

## Usage

1. **Set Up the Environment**  
   Ensure all prerequisites are installed, including Python and the Cell Tracking Challenge evaluation software.

2. **Run Scripts**  
   Use the scripts in the `scripts/` directory to process your data. For example:
   - `evaluate_det_tra.sh`: Run the CellTrackingChallenge Evaluation (`DET`, `SEG`, `TRA`), and summarize both detection and tracking errors.
   - `summarize_det_errors.sh`: Summarize detection errors in the dataset.
   - `summarize_tra_errors.sh`: Summarize tracking errors in the dataset.
   - `locate_errors.sh`: Locate errors along the Z-axis.

3. **Analyze Results**  
   Check the `outputs/` directory for processed results and evaluation metrics.

## Contributing

Contributions are welcome! Please submit a pull request or open an issue if you have suggestions or improvements.

## License

This repository is licensed under [BSD 2-Clause "Simplified" License](./LICENSE).

## Acknowledgments
- The Cell Tracking Challenge for providing the evaluation framework and datasets.
  - Maška, M., Ulman, V., Delgado-Rodriguez, P. et al. The Cell Tracking Challenge: 10 years of objective benchmarking. Nat Methods 20, 1010–1020 (2023). https://doi.org/10.1038/s41592-023-01879-y
  - Ulman, V., Maška, M., Magnusson, K. et al. An objective comparison of cell-tracking algorithms. Nat Methods 14, 1141–1152 (2017). https://doi.org/10.1038/nmeth.4473
  - Matula, P, Maška, M, Sorokin, DV, Matula, P, Ortiz-de-Solórzano C, et al. Cell Tracking Accuracy Measurement Based on Comparison of Acyclic Oriented Graphs. PLOS ONE 10(12): e0144959 (2015). https://doi.org/10.1371/journal.pone.0144959