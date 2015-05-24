#include <sys/timeb.h>
#include <re2/re2.h>
#include "FileService.h"

using namespace std;
using namespace re2;

bool endsWith(const std::string &str, const std::string &suffix) {
    return str.size() >= suffix.size()
           && str.compare(str.size() - suffix.size(), suffix.size(), suffix) == 0;
}

int getMilliCount() {
    timeb tb;
    ftime(&tb);
    int nCount = tb.millitm + (tb.time & 0xfffff) * 1000;
    return nCount;
}

int getMilliSpan(int nTimeStart) {
    int nSpan = getMilliCount() - nTimeStart;
    if (nSpan < 0)
        nSpan += 0x100000 * 1000;
    return nSpan;
}

int main(int argc, char **argv) {

    if (argc < 3) {
        cout << "Too few arguments." << endl;
        return 1;
    }

    string regexpFile = argv[1];
    string fastaFile = argv[2];

    if (!endsWith(regexpFile, ".re")) {
        cout << "Argument 1 must be a file of type .re." << endl;
        return 1;
    }

    if (!endsWith(fastaFile, ".fa")) {
        cout << "Argument 2 must be a file of type .fa" << endl;
        return 1;
    }

    FileService fr;
    string regexp = fr.read(argv[1]);
    string fasta = fr.read(argv[2]);

    int compileStart = getMilliCount();

    RE2 pattern(regexp);

    int compileTime = getMilliSpan(compileStart);

    cout << compileTime << endl;

    StringPiece input(fasta);
    string value;

    cout << "-" << endl;

    int matches = 0;
    int matchStart = getMilliCount();

    while (RE2::FindAndConsume(&input, pattern, &value)) {
        cout << getMilliSpan(matchStart) << ": Found: " << value << endl;
        matches++;
    }

    int matchTime = getMilliSpan(matchStart);

    cout << "_" << endl;

    //int match = RE2::PartialMatch(fasta, pattern);

    cout << matchTime << endl;

    cout << "#" << endl;

    cout << compileTime + matchTime << endl;

    cout << "&" << endl;

    cout << matches << endl;

    return 0;
}
