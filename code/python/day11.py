from re import I
from typing import List
from dataclasses import dataclass

import lucidity

example = '''Monkey 0:
  Starting items: 71, 86
  Operation: new = old * 13
  Test: divisible by 19
    If true: throw to monkey 6
    If false: throw to monkey 7'''

parse_format = '''Monkey {name_monkey}:
  Starting items: {starting_items}
__Operation:_new_=_{operation}
  Test: divisible by {divisible_number}
    If true: throw to monkey {true_throw_monkey}
    If false: throw to monkey {false_throw_monkey}'''

template = lucidity.Template('model', parse_format.split('\n')[0])
template2 = lucidity.Template('model', parse_format.split('\n')[1])
template3 = lucidity.Template('model', parse_format.split('\n')[2])
template4 = lucidity.Template('model', parse_format.split('\n')[3])
template5 = lucidity.Template('model', parse_format.split('\n')[4])
template6 = lucidity.Template('model', parse_format.split('\n')[5])




@dataclass
class MonkeyOperation:
    name_monkey: int
    list_items: List[int]
    operation: str
    divisible: int
    monkey_true: int
    monkey_false: int
    inspected_items: int

    @classmethod
    def new(cls, inpt: str):
        name_monkey = int(template.parse(inpt.split('\n')[0])['name_monkey'])
        list_items = [int(elem) for elem in  inpt.split('\n')[1].split(":")[1].strip().replace(' ','').split(',')]
        operation = inpt.split('\n')[2].split("=")[1].strip()
        divisible = int(template4.parse(inpt.split('\n')[3])['divisible_number'])
        monkey_true = int(template5.parse(inpt.split('\n')[4])['true_throw_monkey'])
        monkey_false = int(template6.parse(inpt.split('\n')[5])['false_throw_monkey'])
        return MonkeyOperation(name_monkey=name_monkey, list_items=list_items, operation=operation, divisible=divisible, monkey_true = monkey_true, monkey_false= monkey_false, inspected_items=0)


def apply_operation(old, str_oper):
            splitted = str_oper.split(' ')
            oper1 = splitted[0]
            oper1 = old
            try:
                oper2 = int(splitted[2])
            except ValueError:
                oper2 = int(old)
            if splitted[1] == "+" :
                operation = lambda a, b: a + b
            else:
                operation = lambda a, b: a * b
            return operation(oper1, oper2)

def main():
    new_list = []
    with open('day11.txt', 'r') as f:
        lines = f.readlines()
        input_str = ''
        for index, line in enumerate(lines):
            if index % 7 == 0 and index!=0:
                new_list.append(input_str)
                input_str = ''
            input_str+=line

    new_list.append(input_str)
    monkey_opers = [MonkeyOperation.new(monkey_info) for monkey_info in new_list]
    
    #Part 2 calculate common multiple
    divisibles = [oper.divisible for oper in monkey_opers]
    common_multiple= 1
    for x in divisibles:
        common_multiple *= x


    #modify from 20 to 10000 for part 2
    for round_ in range(0,10000):
        size_monkey_opers = len(monkey_opers)
        index = 0
        print(f'----round = {round_}')
        while index < size_monkey_opers:
            monkey = monkey_opers[index]
            monkey.inspected_items += len(monkey.list_items)
            for old in monkey.list_items:
                #increase worry
                new  = apply_operation(old, monkey.operation)
                #monkey get bored, decrease
                #TODO  remove this for second part
                #bored_worried  = int(new / 3.)
                bored_worried = new % common_multiple

                index_to_send =  monkey.monkey_true if (bored_worried % monkey.divisible == 0) else monkey.monkey_false
                monkey_opers[index_to_send].list_items.append(bored_worried)
            # clean items, we iterated across all the elems
            monkey.list_items = []
            index +=1


    def fun_sort(e):
        return e.inspected_items

    monkey_opers.sort(key=fun_sort)
    print("End after 20 rounds")
    for monkey in monkey_opers:
        print(f'{monkey.name_monkey} {monkey.list_items} {monkey.inspected_items}')
    total = monkey_opers[-1].inspected_items * monkey_opers[-2].inspected_items
    print("result=" + str(total))

main()
