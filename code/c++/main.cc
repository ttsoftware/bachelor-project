#include <iostream>
#include <re2/re2.h>

using namespace std;
using namespace re2;

int main (int argc, char **argv)
{
    cout << "hello world" << endl;

    int matchResult;

    matchResult = RE2::FullMatch("hello", "h.*o");
    cout << "matchResult = " << matchResult << endl;

    return 0;
}