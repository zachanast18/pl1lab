#include <iostream>
#include <vector>
#include <set>
#include <tuple>
#include <chrono>
//using namespace std;
//using namespace std::chrono;

auto start = std::chrono::high_resolution_clock::now(); //start the timer

bool isGood(int w, int y, int N, int M){
    if(w < 0) return true;
    if(w > N-1) return true;
    if(y < 0) return true;
    if(y > M-1) return true;
    return false;
}


int main(int argc, char **argv) {
    int N = 0; // number of rows
    int M = 0; // number of collumns
    
    const char *h = argv[1]; //pointer to the text file given
    FILE *f;
    f = fopen(h, "r");
    
    //reading the file and storing the data
    char buff[10000];
    char a;
    
    for (int i = 0; i < 2; ++i){
        if (fscanf(f, "%s", buff) < 0) return 1;
        if(i == 0) N = atoi(buff);
        else M = atoi(buff);
    }
    
    std::vector<std::vector<char>> v (N, std::vector<char> (M)); // in v we store the maze navigation data from the input file 
    std::vector<std::vector<int>> b (N, std::vector<int> (M)); // in b we save the bad rooms (2) and the good rooms (1)
    
    
    int i = 0;
    int j = 0;
    while(fscanf(f, "%c", &a) != EOF){
        if (a == ' ' or a == '\n') continue;
        v[i][j] = a;
        j++;
        if(j == M){
            i++;
            j = 0;
        }
    }
    
    fclose(f);
        
    
    /*
    //printing the data		
    for (int i = 0; i < N; ++i){
        for (int j = 0; j < M; ++j){
        cout << v[i][j];
        if (j == M-1) 
            cout << '\n';
        }
    }
    */
    
    std::set<std::tuple<int, int>> s;
    int sum = 0; // the number of bad rooms
    
    for (int i = 0; i < N; ++i)
        for (int j = 0; j < M; ++j){
            int w = i;
            int y = j;
            while(true){
                //checking if we are in a good room, seen for the first time
                if(isGood(w, y, N, M)) {
                    for (auto it = s.begin(); it != s.end(); it++)
                        b[std::get<0>(*it)][std::get<1>(*it)] = 1;
                    s.clear(); 
                    break;
                }
                
                //checking if we are in a good room, we have seen again
                if(b[w][y] == 1){
                    for (auto it = s.begin(); it != s.end(); it++)
                        b[std::get<0>(*it)][std::get<1>(*it)] = 1;
                    s.clear();
                    break;
                }
                    
                //checking if we are in a bad room, we have seen again
                if(b[w][y] == 2){
                    for (auto it = s.begin(); it != s.end(); it++){
                        b[std::get<0>(*it)][std::get<1>(*it)] = 2;
                        sum++;
                    }
                    s.clear();
                    break;
                }
                    
                
                //checking if we are in a bad room, seen for the first time
                if(s.find(std::make_tuple(w, y)) != s.end()){
                    for (auto it = s.begin(); it != s.end(); it++){
                        b[std::get<0>(*it)][std::get<1>(*it)] = 2;
                        sum++;
                    }
                    s.clear();
                    break;
                }
                
                s.insert(std::make_tuple(w, y));
                
                //going to the next room
                if(v[w][y] == 'U') w--;
                else if(v[w][y] == 'D') w++;
                else if(v[w][y] == 'L') y--;
                else if(v[w][y] == 'R') y++;
            }
                                    
        }
std::cout << sum << '\n';
auto stop = std::chrono::high_resolution_clock::now(); //stop the timer
auto duration = std::chrono::duration_cast<std::chrono::milliseconds>(stop - start); //calculate elapsed time
//std::cout << "duration = " << duration.count() << " milliseconds\n"; //print elapsed time
return 0;
}
