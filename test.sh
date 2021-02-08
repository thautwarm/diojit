echo "=====py39====="
pip install diojit
source activate base # py39
python benchmarks/append3.py
python benchmarks/brainfuck.py
python benchmarks/dna_read.py
python benchmarks/fib.py
python benchmarks/hypot.py
python benchmarks/selection_sort.py
python benchmarks/trans.py
pip uninstall diojit

echo "=====py38====="
source activate py38
pip install .
python benchmarks/append3.py
python benchmarks/brainfuck.py
python benchmarks/dna_read.py
python benchmarks/fib.py
python benchmarks/hypot.py
python benchmarks/selection_sort.py
python benchmarks/trans.py
pip uninstall diojit