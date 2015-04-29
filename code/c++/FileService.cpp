#include "FileService.h"

string FileService::read(string filename) {

    ifstream inputFileStream(filename);

    string content;
    content.assign(
            istreambuf_iterator<char>(inputFileStream),
            istreambuf_iterator<char>()
    );

    inputFileStream.close();

    return content;
}

string FileService::read(string filename, int lines) {

    ifstream inputFileStream(filename);
    string line;
    string buffer;

    while (lines != 0 && getline(inputFileStream, line)) {
        buffer += line;
        lines--;
    }

    return buffer;
}

void FileService::write(string filename, string content) {

    ofstream outputFileStream(filename, ios_base::app | ios_base::out);
    outputFileStream << content + "\n";
}