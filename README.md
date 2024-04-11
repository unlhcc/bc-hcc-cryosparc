# Batch Connect - HCC CryoSPARC

[![pipeline status](https://git.unl.edu/hcc/bc-hcc-cryosparc/badges/master/pipeline.svg)](https://git.unl.edu/hcc/bc-hcc-cryosparc/-/commits/master)
[![GitHub License](https://img.shields.io/badge/license-MIT-green.svg)](https://opensource.org/licenses/MIT)

A Batch Connect app designed for Open OnDemand that launches CryoSPARC within an
SLURM batch job.

Based off of https://github.com/OSC/bc_osc_comsol.

## Prerequisites

This Batch Connect app requires the following software be available on the
**compute nodes** that the batch job is intended to run on (**NOT** the
OnDemand node):

- [CryoSPARC]
- [Apptainer]
- [Lmod]

[CryoSPARC]: https://cryosparc.com/
[Apptainer]: https://apptainer.org
[Xfce Desktop]: https://xfce.org/
[Lmod]: https://www.tacc.utexas.edu/research-development/tacc-projects/lmod

## Build/Install

Gitlab CI will automatically build both CentOS 7 and 8 RPMs.
They can be installed directly via `yum` for testing.
For production, add to the per-cluster common repos and require via puppet.

## Contributing

1. Fork it ( https://git.unl.edu/hcc/bc-hcc-cryosparc/-/forks/new )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## License

* Documentation, website content, and logo is licensed under
  [CC-BY-4.0](https://creativecommons.org/licenses/by/4.0/)
* Code is licensed under MIT (see LICENSE.txt)
