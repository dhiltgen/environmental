# Home IoT Environmental Data

This tree contains some wiring to setup a simple home IoT monitoring stack.

There are numerous ways to accomplish environmental monitoring, but I've "standardized" largely
on using the 1-wire sensors and the linux kernel GPIO driver.

Use raspbian on your Raspberry PI, enable 1-wire support in `raspiconfig` then gather the data
using simple scripts (see `./examples` for some ideas)

This data is then aggregated with `prometheus` and dashboards rendered via `grafana`
