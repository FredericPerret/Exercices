import sys
from os.path import dirname, abspath

PROJECTDIR = dirname(dirname(abspath(__file__)))
sys.path.append(PROJECTDIR+"/src")

from reader import reader
from transformer import transformer
from writer import writer

def pipeline():
    reader()
    transformer()
    writer()
