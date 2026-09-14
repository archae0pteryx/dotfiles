#!/bin/bash

find ~/Code -maxdepth 8 ! -path "*/node_modules/*" ! -path "*/.git/*" -name ".DS_Store" -type f -delete
