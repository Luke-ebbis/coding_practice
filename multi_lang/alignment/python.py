'''
Author: Sibbe Bakker
Source: The aligner script written by YGC (2008; guangchuangyu@gmail.com). I refactored 
        it into python code myself.
'''
import numpy as np

# the query X and the reference Y.

X = 'AAABBB'
Y = 'AAAAAB'

#the alignment parameters:
match_score    = 5
mismatch_score = -2
indel_score    = -6

#Add the character '0' to the start of each string.
sequence_X = '0%s' % X
sequence_Y = '0%s' % Y

#initialise an empty matrix
score_matrix = np.zeros(shape=(len(sequence_X), 
                        len(sequence_Y)),
        		        dtype='object')

#mapping the indel score to the matrix  
list_x = np.array([i for i in range(len(sequence_X))]) * indel_score
list_y = np.array([i for i in range(len(sequence_Y))]) * indel_score

score_matrix[:, 0] = list_x
score_matrix[0, :] = list_y

'''
Here I start the Dynamic programming / global alignment recursion.
This step `populates´ the score matrix with values of each comparison.
The two loops on the lines below make sure that every base in X and Y are compared
'''
for i in range(1, len(sequence_X)):
    for j in range(1, len(sequence_Y)):
        #Cases for alignment to non gap   
        if sequence_X[i] == sequence_Y[j]:
           #incase X_i and Y_j are the same (i.e. alignment)
           score_matrix[ i, j] = score_matrix[ i-1, j-1] + match_score
        else:
            score_matrix[ i, j] = score_matrix[ i-1, j-1] + mismatch_score
    
        #Cases for alignment with gap.
        sc = score_matrix[ i-1, j] + indel_score #i do not yet know what SC is supposed to be.
        if sc > score_matrix[ i, j]:
            score_matrix[ i, j] = sc
        sc = score_matrix[ i, j-1] + indel_score
        if sc > score_matrix[ i, j]:
            score_matrix[ i, j] = sc

'''
This step is called `traceback´ by YGC. This step seems to use the score matrix to 
complete the sequence alignment procedure by returning the text of the alignment.
'''

'''
set the indexes to the len of the strings. This is to start out on the 3` prime and 
move the alignment towards the 5` end. This is because for each level of the coming 
while loop, the indeces i and j are decremented.
'''
i = len(sequence_X) - 1
j = len(sequence_Y) - 1

#Here the empty alignments are initialised.
ax = ''
ay = ''
print("starting with i,j of:", i,j)
print(sequence_X, sequence_Y)
while i > 1 and j > 1:
    '''
    Execute the following code for all bases in the sequence, following the possible
    cases of the score_matrix.
    '''    
    print("\n new iteration")
    #Case 1: perfect alignment
    sc = score_matrix[ i-1, j-1]
    print(i, j, sequence_X[i], sequence_Y[j], score_matrix[i,j], sc)
    if sequence_X[i] == sequence_Y[j]:
        print("CASE 0a")
        sc = sc + match_score
    else:
        print("CASE 0b")
        sc = sc + mismatch_score

    if sc == score_matrix[ i, j]:
        print("CASE 1")
        ax = sequence_X[i] + ax
        ay = sequence_Y[j] + ay
        i = i-1
        j = j-1
        continue
    
    #Case 2: best of X was aligned to gap
    if (score_matrix[ i-1, j] + indel_score) == score_matrix[ i, j]:
        print("CASE 2")
        ax = sequence_X[i] + ax
        ay = '-' + ay
        i = i-1
        continue
    
   #Case 3: best of Y was aligned to gap
    if (score_matrix[ i, j-1] + indel_score) == score_matrix[ i, j]:
        print("CASE 3")
        ax = '-' + ax
        ay = sequence_Y[j] + ay
        j = j-1
        continue 


# Output to ST-out via print:
print(ax)
print(ay)

np.set_printoptions(formatter={'float': "\t\t{: 0.0f}\t\t".format}, suppress = True)
print(score_matrix)
