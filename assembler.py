# -*- coding: utf-8 -*-
"""
Created on Thu Aug 25 00:17:07 2022

@author: annlu
"""
import re

assembly = open(r'C:\Users\annlu\OneDrive\Documents\School\Summer 2022\CSE141L\sample prog 3', 'r')
machine = r'C:\Users\annlu\OneDrive\Documents\School\Summer 2022\CSE141L\starter_code\simulation\modelsim\machine_code.txt'
instAddr = 0
labels = ['prepend', 'message_start', 'encrypt', 'done', 
          'check_seed', 'check_feedback', 'check_space', 
          'next_seed', 'next_pattern', 'decrypt', 'doneB',
          'decrypt_message', 'append_spaces', 'doneC']
opfunct = { "add" : ['000', '00'],
            "sub" : ['000', '01'],
            "and" : ['000', '10'],
            "or"  : ['000', '11'],
            "xor" : ['001', '10'],
            "not" : ['001', '11'],
            "mov" : ['001', '00'],
            "set" : ['001', '01'],
            "lsl" : ['011', '00'],
            "lsr" : ['011', '01'],
            "stri": ['010'],
            "ld"  : ['110', '00'],
            "str" : ['110', '01'],
            "beq" : ['100', '00'],
            "bne" : ['100', '01'],
            "ble" : ['100', '10'],
            "blt" : ['100', '11'],
            "b"   : ['101', '00'],
            "cmp" : ['101', '01'],
            "rxr" : ['011', '10']}

lut = {}
instNum = 1

with open(machine, 'w',  newline='', encoding='UTF8') as f:
    aCode = assembly.readlines()
    for code in aCode:
        lab = re.search(r'([\w+_]*\w+:)',code)
        if (lab != None):
            labNam = re.search(r'([\w+_]*\w+)', code).group()
            lut[labNam] = [bin(labels.index(labNam))[2:].zfill(4), hex(instAddr)]
        assRegex = re.compile(r'((add|sub|and|or|xor|not|mov|set|lsl|lsr|ld|str|cmp|rxr) R\d+)|(stri #\d+)|((beq|bne|ble|blt|b) ([\w+_]*\w+))')
        assCode = assRegex.search(code.strip())
        if (assCode != None):
            instNum += 1
            instType = assCode.group()
            inst = instType.split()
            instName = inst[0]
            instDic = opfunct[instName]
            opcode = instDic[0]
            if ((instName == "beq") or (instName == "bne") or (instName == "ble") or (instName == "blt") or (instName == "b")):
                funct = instDic[1]
                label = inst[1]
                lookup = bin(labels.index(label))[2:].zfill(4)
                mac = opcode + lookup + funct
            elif (instName == "stri"):
                imm = inst[1]
                immNoR = int(re.search(r'\d+', imm).group())
                immBin = bin(immNoR)[2:].zfill(6)
                mac = opcode + immBin
            else:
                reg = inst[1]
                regNum = int(re.search(r'\d+', reg).group())
                regBin = bin(regNum)[2:].zfill(4)
                funct = instDic[1]
                mac = opcode + regBin + funct
            print(str(hex(instAddr).zfill(2)) + ':\t' + mac + '\t\t\t' + code.strip())
            #print(mac)
            f.write(mac + '\n')
            instAddr += 1
        # else :
        #     print(code)
    f.write('000000000')
print(lut)