#!/bin/bash

PP=$(pidof keosd)
[[ $PP != "" ]] && kill $PP

