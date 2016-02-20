# ghc_autograder

Usage ./autograder_ghc.sh [tc_folder] [source_folder]

## tc_folder structure

tc/
|_tc/1
|_tc/2
|_tc/3
|_ ...
|_tc/n

Notes : 
* tc number equal to test case question number (so if only question 2 and 5 who will be graded then there only be folder named 2 and 5)
* Question are sequentially ordered (see next section "source_folder")

## source_folder section

Basicly using downloadsource features from http://oddyseus.if.itb.ac.id, then extract compressed size

it will create structer similar to this :

src/
|_src/<student1>
	|_src/<student1>/question_1
	|_src/<student1>/question_2
	|_src/<student1>/question_3
|_src/<student2>
	|_src/<student2>/question_1
	|_src/<student2>/question_2
	|_src/<student2>/question_3
|_ ...
|_src/<studentN>
	|_src/<studentN>/question_1
	|_src/<studentN>/question_2
	|_src/<studentN>/question_3

## Result

There will be a .csv file that has src_folder name containing student's name and grade for each question.		