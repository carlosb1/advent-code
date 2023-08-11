import sys
from pathlib import Path


def is_top_carry(top_carries, compare_carry):
    return len(top_carries) < 3 or any([ carry  < compare_carry for carry in top_carries ])

def add_or_update_carry(top_carries, compare_carry):
    top_carries.append(compare_carry)
    sorted(top_carries)
    return sorted(top_carries)[-3:]

def run():
    if len(sys.argv) < 2:
        filepath = Path("default.txt")
    else:
        filepath = Path(sys.argv[1])

    top_carries = []
    sum_carries = []
    with filepath.open() as f:
        for line in f.readlines():
            line = line.strip()
            if not len(line):
                total_carries = sum(sum_carries)
                if is_top_carry(top_carries, total_carries):
                    top_carries = add_or_update_carry(top_carries, total_carries)
                sum_carries.clear()
            else:
                if line.isdigit():
                    sum_carries.append(int(line))
    print(f"top = {sum(top_carries)}")
    print(f"set = {top_carries}")

if __name__ == '__main__':
    run()
