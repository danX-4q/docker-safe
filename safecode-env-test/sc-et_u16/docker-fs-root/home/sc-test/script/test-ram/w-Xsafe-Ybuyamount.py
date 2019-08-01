#!/usr/bin/env python2
#-*- coding: utf8 -*-

import argparse
import subprocess
import time
import json
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

def get_account_ram_quota(account):

    #cleos-sc get account xxxx
    cmd = cmdbuilder.cleos__get_account(account)

    #print cmd
    out_all = sp.check_output(cmd, True)
    oj = json.loads(out_all)
    return (int(oj['ram_quota']))

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
    last_ram = get_account_ram_quota(prog_args.account)
    time.sleep(prog_args.interval)

    nr = prog_args.buynr
    for i in range(0, nr):
        do_buyram(prog_args.account, prog_args.buyamount)
        ram = get_account_ram_quota(prog_args.account)
        wfo.write(str(i) + ' ' + str(ram - last_ram) + '\n')
        last_ram = ram
        time.sleep(prog_args.interval)


###########################################################

def main():
    parser = argparse.ArgumentParser(
            description="write data(x:safe, y:amount of ram `x` safe can buy) to gnuplot format file.",
            formatter_class=argparse.ArgumentDefaultsHelpFormatter)

    parser.add_argument('-a', '--account', nargs='?', type=str, default='testramprice', help='safecode account who buys ram')
    parser.add_argument('-b', '--buyamount', nargs='?', type=int, default=10000, help='buy amount per-time')
    parser.add_argument('-i', '--interval', nargs='?', type=float, default=0.5, help='sleep interval(ms) when cleos push action')
    parser.add_argument('-n', '--buynr', nargs='?', type=int, default=10, help='times of buy ram')
    parser.add_argument('-f', '--file', nargs='?', type=str, default='', help='x-y data file; default w-Xsafe-Ybuyamount__YYYYmmdd_HHMMSS.plot')

    prog_args = parser.parse_args()
    print prog_args

    biz_entry(prog_args)

if __name__ == '__main__' :
    main()