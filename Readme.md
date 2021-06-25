# Measurement and Visualization code

## Scripts used for Figures in the paper

- Figure 1: `taurus-island6-cpu-power/Plot.ipynb`
- Figure 2: `taurus-gpu2-power/Plot.ipynb`
- Figure 7: `figure-firestarter2-overlay/Figure.ipynb`
- Figure 8: `unroll-factor/Plot.ipynb`
- Figure 9: `memory-accesses/Plot.ipynb`
- Figure 10: `frequency-optimized/Heatmap_Plot.ipynb`
- Figure 12: `frequency-optimized/Evaluation_Notebook.ipynb`

## Disclaimer

The scripts in `taurus-gpu2-power` and `taurus-island6-cpu-power` are using our locally deployed [MetricQ](https://github.com/metricq) instance, which is not available from extern. However, for `taurus-gpu2-power`, the recorded measurements are attached in the `datafiles` folder.

## Command-line util `elab`

We developed and installed on all our test machines a helper program called `elab`. We use this program to reliably set specific system parameters, like C-states, P-states, SMT. It is also used in some of the scripts part of this repository. The particular setting reference in any call should be easily derivable. For instance:

- `elab ht on|off|enable|disable` respectively enables and disables SMT, which is done by disabling all but the first thread sibling for every core
- `elab frequency nominal` sets the scaling governor to `userspace` and the used P-state to the nominal frequency of the processor
- `elab frequency turbo` is like `elab frequency nominal`, but also enables turbo frequencies
- `elab cstate ...` allows configuring the available C-states
