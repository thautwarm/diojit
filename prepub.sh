#!/usr/bin/env bash
 fd -H -E .git ... -0 | xargs -0 dos2unix
