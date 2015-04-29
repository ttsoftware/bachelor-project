#ifndef RE2_BENCHMARK_FILEREADER_H
#define RE2_BENCHMARK_FILEREADER_H

#include <iostream>
#include <fstream>
#include <string>

using namespace std;

class FileService {
public:
    string read(string filename);

    string read(string filename, int lines);

    void write(string filename, string contents);
};

#endif //RE2_BENCHMARK_FILEREADER_H
