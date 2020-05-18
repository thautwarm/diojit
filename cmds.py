# easy-to-use cross-platform build helper commands
import os
import re
import sys
import wisepy2
import glob
from pathlib import Path
from functools import reduce

def find(directory: str, regex: str, *, neg:bool=False, action: str = "print(_)"):
    match = re.compile(regex).match
    if neg:
        match = lambda x, match=match: not match(x)
    
    act = eval("lambda ISDIR, _: {}".format(action), globals())
    for dirname, dirs, files in os.walk(directory):
        if match(dirname):
            act(True, dirname)
        for each in files:
            each = os.path.join(dirname, each)
            if match(each):
                act(False, each)

def movefiles(pathpat: str, dir: str):
    p = Path(dir)
    for each in glob.glob(pathpat):
        each_target = str(p / Path(each).name)
        os.rename(each, each_target)

def rmfile(filename: str):
    os.remove(filename)
    
def objext(_):
    """object file extension"""
    ext = 'obj' if os.name == 'nt' else 'o'
    print(ext)

def switch(cmd: str):
    wisepy2.wise(globals()[cmd])(sys.argv[2:])

if __name__ == '__main__':
    wisepy2.wise(switch)([sys.argv[1]])
