import string
import sys
from pathlib import Path
from typing import List

alphabet_score = list(string.ascii_lowercase) + list(string.ascii_uppercase)
print(list(enumerate(alphabet_score)))

def find_repeats(first_compl: str, second_compl: str):
    return list(set([ charc for charc in first_compl if charc in second_compl]))

def calculate_score(repeats: List):
    partial_score = [ alphabet_score.index(rep) +1 for rep in repeats if rep in alphabet_score]
    return sum(partial_score)

def run():
    if len(sys.argv) < 2:
        filepath = Path("day3.txt")
    else:
        filepath = Path(sys.argv[1])


    total_score = 0
    with filepath.open() as f:
        for line in f.readlines():
            rucksack = line.strip()
            half_size = int (len(rucksack) / 2)
            first_compl = rucksack[:half_size]
            second_compl = rucksack[half_size:]
            repeats = find_repeats(first_compl, second_compl)
            print(f"before={repeats}")
            score = calculate_score(repeats)
            print(f"repeats = {score}")
            total_score += score

        print(f"total score {total_score}")

if __name__ == '__main__':
    run()
