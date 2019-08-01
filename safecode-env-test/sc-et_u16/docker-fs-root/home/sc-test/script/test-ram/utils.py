#!/usr/bin/env python2.7
#-*- coding: utf-8 -*-

import subprocess

class CEosAccount:
    def __init__(self, account):
        self.set(account)
    
    def set(self, account):
        if len(account) != 12:
            raise ValueError("unvalid format of @account")
        self.a = account

    def __str__(self):
        return self.a


class CleosCmdBuiler:
    def __init__(self):
        self.bin_cleos = '/root/eosio/1.8/bin/cleos --url http://127.0.0.1:7770 --wallet-url http://127.0.0.1:5550 '
    
    def cleos__get_account(self, account):
        if isinstance(account, str):
            a = CEosAccount(account)
        elif isinstance(account, CEosAccount):
            a = account
        else :
            raise TypeError("invalid type for @account")
        return '%s get account %s -j' % (self.bin_cleos, a)

    def cleos__system_buyram(self, account, receiver, buyamount):
        if isinstance(account, str):
            a = CEosAccount(account)
        elif isinstance(account, CEosAccount):
            a = account
        else :
            raise TypeError("invalid type for @account")

        if receiver == '' or receiver == None:
            r = a
        else:
            r = receiver

        return '%s system buyram -f %s %s "%d.00000000 SAFE"' % (self.bin_cleos, a, r, buyamount)

class CSubprocess :
    def __init__(self):
        pass
    
    def check_call(self, cmd, shell=False) :
        print('cmd-line: %s' % cmd)
        ret = subprocess.check_call(cmd, shell=shell)
        print('ret-code: %s' % ret)
        return ret

    def check_output(self, cmd, shell=False):
        print('cmd-line: %s' % cmd)
        ret = subprocess.check_output(cmd, shell=shell)
        print('ret-out: %s' % ret)
        return ret

    def popen(self, cmd, shell=False, stdout=subprocess.PIPE) :
        print('cmd-line(popened): %s' % cmd)
        p = subprocess.Popen(cmd,shell=shell,stdout=stdout)
        return p

    def popen_stdout(self, p, cb_return=None):
        ret = ''
        for i in iter(p.stdout.readline, b''):  #until meet the string ''
            ret += i
            if cb_return and cb_return(ret):
                break

        print('ret-out(popened): %s' % ret)
        return ret
