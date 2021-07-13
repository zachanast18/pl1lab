import sys
from array import *


def isGood(i, j, N, M):
    return (i < 0) or (i > N-1) or (j < 0) or (j > M-1)


def reader(filename):
    f  =  open(filename, "r")
    temp = f.readline().split()
    N = int(temp[0]) #might need alteration
    M = int(temp[1])
    maze = [[f.read(1) if j != M-1 else f.read(2)[0] for j in range(M)] for i in range(N)]
    f.close()
    return N,M,maze


def loop_rooms():
    filename = sys.argv[1]
    N, M, maze = reader(filename)

    record = [[0 for j in range(M)] for i in range(N)] # 0->never seen, 1->good room, 2->bad room
    path = set()
    result = 0

    for w in range(N):
        for y in range(M):
            i = w
            j = y
            while(True):
                # checking if it is a good room we are seeing for the first time
                if isGood(i, j, N, M):
                    # all rooms in path are good
                    for (u,v) in path:
                        record[u][v] = 1
                    path.clear()
                    break

                #checking if we are in a good room, we have seen again
                if record[i][j] == 1:
                    # all rooms in path are good
                    for (u,v) in path:
                        record[u][v] = 1
                    path.clear()
                    break

                #checking if we are in a bad room, we have seen again
                if record[i][j] == 2:
                    #all rooms in path are bad
                    for (u,v) in path:
                        record[u][v] = 2
                        result +=  1
                    path.clear()
                    break

                #checking if we are in a bad room, seen for the first time
                if (i,j) in path:
                    for (u,v) in path:
                        record[u][v] = 2
                        result +=  1
                    path.clear()
                    break

                #add current room to the path
                path.add((i,j))
                #going to the next room
                if maze[i][j] == 'U':
                    i -= 1
                elif maze[i][j] == 'D':
                    i += 1
                elif maze[i][j] == 'L':
                    j -= 1
                elif maze[i][j] == 'R':
                    j += 1

    print(result)

loop_rooms()
