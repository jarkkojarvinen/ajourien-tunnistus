from os.path import join
from pathlib import Path
from src.main import run


if __name__ == "__main__":
    data_dir = join(Path(__file__).parents[1], 'data')
    mat_fname = join(data_dir, 'z2.mat')
    
    # data_dir = join(Path(__file__).parents[1], 'test_data')
    # mat_fname = join(data_dir, 'z2.mat')
    run(mat_fname)
