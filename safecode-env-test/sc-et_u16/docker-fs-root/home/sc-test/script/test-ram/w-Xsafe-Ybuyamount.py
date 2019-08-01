#!/usr/bin/env python2
#-*- coding: utf8 -*-

import argparse
import subprocess
import time
from utils import *


###########################################################

cmdbuilder = CleosCmdBuiler()
sp = CSubprocess()

###########################################################

def get_wfo(filename):
    if filename == '':
        filename = 'w-Xsafe-Ybuyamount__' + time.strftime("%Y%m%d_%H%M%S", time.localtime()) + '.plot'
    wfo = open(filename, "w")
    return wfo

####################

def get_account_info(account):

    #cleos-sc get account xxxx
    cmd = cmdbuilder.cleos__get_account(account)

    #print cmd
    out_all = sp.check_output(cmd, True)
    #print out
    out_lines = out_all.split('\n')
    
    mem = 0.0
    liquid = 0.0

    for x in out_lines :
        r = x.strip().split()
        if len(r) == 0:
            continue

        if r[0] == 'quota:':
            mem = float(r[1])
        elif r[0] == 'liquid:':
            liquid = float(r[1])
    else :
        print mem, liquid
    
    return (mem, liquid)

####################

def do_buyram(account, buyamount):

    #cleos-sc system buyram xxxx xxxx "yyyy.00000000 SAFE"
    cmd = cmdbuilder.cleos__system_buyram(account, '', buyamount)

    #print cmd
    sp.check_call(cmd, True)

###########################################################

def biz_entry(prog_args):

    wfo = get_wfo(prog_args.file)

    ##########
    (last_mem, last_liquid) = get_account_info(prog_args.account)
    time.sleep(prog_args.interval)

    nr = prog_args.buynr
    for i in range(0, nr):
        do_buyram(prog_args.account, prog_args.buyamount)
        (mem, liquid) = get_account_info(prog_args.account)
        wfo.write(str(i) + ' ' + str(mem - last_mem) + '\n')
        last_mem = mem
        last_liquid = liquid
        time.sleep(prog_args.interval)


###########################################################

def main():
    parser = argparse.ArgumentParser(
            description="write data(x:safe, y:amount of ram `x` safe can buy) to gnuplot format file.",
            formatter_class=argparse.ArgumentDefaultsHelpFormatter)

    parser.add_argument('-a', '--account', nargs='?', type=str, default='testramprice', help='safecode account who buys ram')
    parser.add_argument('-b', '--buyamount', nargs='?', type=int, default=10000, help='')
    parser.add_argument('-i', '--interval', nargs='?', type=float, default=0.5, help='')
    parser.add_argument('-n', '--buynr', nargs='?', type=int, default=10, help='')
    parser.add_argument('-f', '--file', nargs='?', type=str, default='', help='')

    prog_args = parser.parse_args()
    print prog_args

    biz_entry(prog_args)

if __name__ == '__main__' :
    main()