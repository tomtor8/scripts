#!/bin/bash
# This script acts as a wrapper that uses the nvim_kick configuration for $EDITOR environment variable.

# Set the NVIM_APPNAME environment variable for this specific invocation
NVIM_APPNAME=nvim_astro /usr/bin/nvim "$@"
