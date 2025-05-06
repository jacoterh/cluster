#!/bin/bash
# Wrapper script for executing pineko

THEORY=$1
DISTRIBUTION=$2

#pineko theory opcards $THEORY $DISTRIBUTION
pineko theory ekos $THEORY $DISTRIBUTION
pineko theory fks $THEORY $DISTRIBUTION
