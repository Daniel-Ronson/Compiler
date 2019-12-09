#include<iostream>
#include<string>
#include<cstring>
#include<ctype.h>
#include<vector>
#include<ctype.h>
#include<fstream>
#include<sstream>
#include<regex>
#include<iomanip>
using namespace std;

class Whitespace {
private:
	vector<string> tokens;
	string single_token;
	string fileName = "myfile.txt";
	string outputFile = "output.txt";
	bool comment_section = false;
	const char* char_arr = 0;
public:

	Whitespace() {
		ifstream ins;
		ins.open(fileName);
		string line;

		while (ins) {	//populate arrays from text file
			if (getline(ins, line)) {  //get one line
				parseLine(line);//parse one line
			}
			else
				break;
		}
		//for (int i = 0; i < tokens.size(); ++i) {
		//	cout << tokens[i] << endl;
		//}
			ofstream out;
			out.open(outputFile);
		for (int i = 0; i < tokens.size(); ++i) { //print tokens to screen, note - could be printed to excel file or anywhere
			
			if (tokens[i] ==";") {
				cout << tokens[i] << "\n";
				string str = tokens[i];
				//str.append("\n");
				out << str << '\n';
		}
			else if (tokens[i] == "PROGRAM") {
				cout << tokens[i] << " ";
				string str = tokens[i];
				out << str << '\n';
			}
			else if (check_if_VAR_BEGIN(tokens[i])) {
				cout << tokens[i] << endl;
				string str = tokens[i];
				out << str << '\n';
			}
			else{
				cout << tokens[i] << " "; //gather tokens into vector
				string str = tokens[i];
				out << str << " ";
			}
			
		}
		
	}

	void parseLine(string line) {
		string parse;
		stringstream ss(line);
		bool ends_with_comma_or_semicolon = false;
		bool equal_sign = false;
		//ss >> std::ws;
		while (getline(ss, parse,' ')) { 

		//	cout << line << " ";
			if (is_comment_begin(parse)) {
				comment_section = true;
			}
			else if (is_comment_end(parse)) {
				comment_section = false;
			}

			else if(!check_comma_or_semicolon(parse) && comment_section == false && parse!="")
				tokens.push_back(parse);
		}
		
	}
	bool check_if_VAR_BEGIN(string line) {
		regex var("(.*)(VAR)");
		if (regex_match(line, var)) {
			return true;
		}
		regex begin("(.*)(BEGIN)");
		if (regex_match(line, begin)) {
			return true;
		}
		return false;
	}
	bool is_comment_begin(string line) {
		string str = R"(\(\*)"; //escape ( and escape *
		regex e(str); //set regex
		if (regex_search(line, e)) {
			return true;
		}
		return false;
	}
	bool is_comment_end(string line) {
		string str = R"(\*\))";//escape * and escape )
		regex e(str); //set regex
		if (regex_search(line, e)) {
			return true;
		}
		return false;
	}

	bool check_comma_or_semicolon(string line) {
		regex comma("(.*)(,)");
		regex semi("(.*)(;)");

		string parse;
		stringstream ss(line);

		if (regex_match(line, comma)) {
			while (getline(ss, parse, ',')) {
				tokens.push_back(parse);
				tokens.push_back(",");
			}
			return true;
		}
		else if (regex_match(line, semi)) {
			while (getline(ss, parse, ';')) {
				tokens.push_back(parse);
				tokens.push_back(";");
			}
			return true;
		}
		return false;

	}
	bool check_equal_operator(string line) {
		regex equal("(.*)(=)(.*)");
		string parse;
		stringstream ss(line);
		regex equal_right("(=)(.*)");

		/*if (regex_match(line, equal_right)) {
			while (getline(ss, parse, '=')) {

				//	if (check_comma_or_semicolon(parse) == false) //taxyear=2013;
				tokens.push_back("=");
				tokens.push_back(parse);

			}
			return true;
		}
		*/
		 if (regex_match(line, equal)) {
			while (getline(ss, parse, '=')) {

			//	if (check_comma_or_semicolon(parse) == false) //taxyear=2013;
					tokens.push_back("=");
					tokens.push_back(parse);

			}
			return true;
		}

		return false;
	}
};
