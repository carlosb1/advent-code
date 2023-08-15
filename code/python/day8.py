from os import posix_fadvise


board = [[]]
with open('day8.txt', 'r') as f:
    lines = f.readlines()
    board = [[int(char) for char in entry.strip()] for entry in lines]

def is_visible(position, board):
    y = position[0]
    x = position[1]
    range_visible_right = range(x + 1, len(board[0]))
    range_visible_left =  range(0, x)
    range_visible_bottom = range(y + 1, len(board))
    range_visible_top = range(0, y)

    compare_value = board[y][x]

    is_visible_right = all([compare_value > board[y][val] for val in range_visible_right])
    is_visible_left = all([compare_value > board[y][val] for val in range_visible_left])
    is_visible_top = all([compare_value > board[val][x] for val in range_visible_top])
    is_visible_bottom = all([compare_value > board[val][x] for val in range_visible_bottom])
    return is_visible_right or is_visible_left or is_visible_top or is_visible_bottom


def count_score(position, board):
    y = position[0]
    x = position[1]
    score_right = count_visible_cols(position, board, x+1, len(board[0]))
    score_left = count_visible_cols(position, board, 0, x, True)
    score_bottom = count_visible_rows(position, board, y+1, len(board))
    score_top = count_visible_rows(position, board, 0, y, True)
    #print(f"({y},{x} = {board[y][x]})   right {score_right} left {score_left} bottom {score_bottom} top {score_top}")
    return score_right *  score_left * score_bottom * score_top

def count_visible_cols(position, board, start, end, is_reversed = False):
    y = position[0]
    x = position[1]
    compare_value = board[y][x]
    if is_reversed:
        range_visible = reversed(range(start, end))
    else :
        range_visible = range(start, end)

    count = 0
    for val in range_visible:
        count +=1
        if board[y][val] >= compare_value :
            break

    return count

def count_visible_rows(position, board, start, end, is_reversed = False):
    y = position[0]
    x = position[1]
    compare_value = board[y][x]
    range_visible = range(start, end)
    if is_reversed:
        range_visible = reversed(range(start, end))
    else :
        range_visible = range(start, end)
    count = 0
    for val in range_visible:
        count +=1
        if board[val][x] >= compare_value:
            break

    return count


number_cols = len(board[0])
number_rows = len(board)
#print(board)

count = (number_cols *  2 ) + (number_rows * 2 ) - 4
for y in range(1, len(board)-1):
    for x in range(1, len(board[y]) -1):
        elem_to_evaluate = board[y][x]
        pos = (y, x)
        visible = is_visible(pos, board)
        if visible:
            count+=1

print(f"count {count}")

max_score = 0
max_pos = 0
for y in range(1, len(board)-1):
    for x in range(1, len(board[y]) -1):
        elem_to_evaluate = board[y][x]
        pos = (y, x)
        score = count_score(pos, board)
        if score > max_score:
           max_score = score
           max_pos = pos
print(f"max score {max_score} and pos {max_pos}")

