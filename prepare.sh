#!/bin/bash
# re-validate login information
mkdir -p ./.auth
/root/.conda/envs/vwa/bin/python browser_env/auto_login.py