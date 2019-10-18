#include <bits/stdc++.h>

using namespace std;

int main()
{
    stringstream ss;
    string s1, s2;
    getline(cin, s1);
    getline(cin, s2);
    ss << s1;
    map <string,int> msi1;
    map <string,int> msi2;
    while (ss >> s1)
    {
        msi1[s1]++;
    }
    ss.clear();
    ss << s2;
    while (ss >> s2)
    {
        msi2[s2]++;
    }
    for (auto i : msi1)
    {
        if (!msi2[i.first])
            cout << i.first << " " << min(i.second, msi2[i.first]) << endl;
    }

    return 0;
}
