import sys
from collections import deque

def findsolution(q, s, result, visited, next_moves):
    if (if_sorted(q) and (not s)):
        return "empty"
    visited.add((tuple(q), tuple(s)))
    s.append(q.pop(0))
    result += 'Q'
    visited.add((tuple(q), tuple(s)))
    next_moves.append((q[:], s[:], result))
    next_moves.append((q[:], s[:], result))
    while (1):
        if (not s):
            if(if_sorted(q)):
                return result
        q, s, result = next_moves.popleft()
        if (q):
            s.append(q.pop(0))
            if((tuple(q), tuple(s)) in visited):
                q.insert(0, s.pop())
            else:
                result += 'Q'
                visited.add((tuple(q), tuple(s)))
                next_moves.append((q[:], s[:], result))
                next_moves.append((q[:], s[:], result))
        
        #if (not s):
            #if(if_sorted(q)):
                #return result
        q, s, result = next_moves.popleft()
        if (s):
            q.append(s.pop())
            if((tuple(q), tuple(s)) in visited):
                s.append(q.pop(0))
            else:
                result += 'S'
                visited.add((tuple(q), tuple(s)))
                next_moves.append((q[:], s[:], result))
                next_moves.append((q[:], s[:], result))

def if_sorted(queue):
    flag = 0
    if(all(queue[i] <= queue[i + 1] for i in range(len(queue)-1))):
        flag = 1
        return flag

def main():
    filename = sys.argv[1]
    f = open(filename, "r")
    N = int(f.readline())
    q1 = f.readline().split()
    q = []
    s = []
    visited = set()
    for i in q1:
        q.append(int(i))
    next_moves = deque()
    print(findsolution(q,s,'', visited, next_moves))

if __name__ == "__main__":
    main()
