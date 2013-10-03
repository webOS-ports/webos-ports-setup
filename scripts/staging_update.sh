#!/bin/bash

echo "Updating sources" | tee -a info
date        | tee -a info
make update | tee -a info
