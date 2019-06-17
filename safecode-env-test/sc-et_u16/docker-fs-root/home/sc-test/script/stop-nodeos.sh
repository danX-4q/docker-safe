#!/bin/bash

PP=$(pidof nodeos)
[[ $PP != "" ]] && kill $PP

