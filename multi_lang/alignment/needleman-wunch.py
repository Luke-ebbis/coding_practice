#!/usr/bin/env python
"""Needleman Wunch algorithm algorithm
author --- Sibbe Bakker
description --- An implementation of the needleman wunch alignment algorithm.
    This algorithm is a global alignment algorithm, it works best for comparing
    sequences of equal length.
usage
    Here I describe the useage:
    sequence_X --
    sequence_Y --
source --- The aligner script written by YGC (2008; guangchuangyu@gmail.com).
    I refactored  into python code myself.
"""

# Dependencies
import numpy as np
from random import choice


def generate_sequence(sequence_length: int = 60,
                      letters: iter = ("A", "T", "C", "G")) -> str:
    """
    Generate a random sequence of characters with length n

    :param sequence_length: int: The length of the sequence to be generated,
        the length n.
    :param letters: iter: A array of characters. These characters will be in the
        random sequence.
    :return: str: A string of length n containing only specified characters.

    dependencies --- random
    """

    random_seq = (choice(letters) for x in range(sequence_length))
    random_string = "".join(random_seq)
    return random_string


def main():
    """The main function
    """
    print(generate_sequence())


if __name__ == "__main__":

    main()

    def backup():
        # Testing section
        # the alignment parameters:
        match_score = 5
        mismatch_score = -2
        indel_score = -6

        # Add the character '0' to the start of each string.
        sequence_X = '0%s' % X
        sequence_Y = '0%s' % Y

        # Initialise an empty matrix
        score_matrix = np.zeros(shape=(len(sequence_X), 
                                len(sequence_Y)),
                                dtype='object')

        # Mapping the indel score to the matrix  
        list_x = np.array([i for i in range(len(sequence_X))]) * indel_score
        list_y = np.array([i for i in range(len(sequence_Y))]) * indel_score

        score_matrix[:, 0] = list_x
        score_matrix[0, :] = list_y

        """
        Here I start the Dynamic programming / global alignment recursion.
        This step `populates the score matrix with values of each comparison.
        The two loops on the lines below make sure that every base in X and Y are compared
        """
        for i in range(1, len(sequence_X)):
            for j in range(1, len(sequence_Y)):
                #Cases for alignment to non gap
                if sequence_X[i] == sequence_Y[j]:
                   #In case X_i and Y_j are the same (i.e. alignment)
                   score_matrix[i, j] = score_matrix[ i-1, j-1] + match_score
                else:
                    score_matrix[ i, j] = score_matrix[ i-1, j-1] + mismatch_score
            
                #Cases for alignment with gap.
                sc = score_matrix[ i-1, j] + indel_score #i do not yet know what SC is supposed to be.
                if sc > score_matrix[ i, j]:
                    score_matrix[ i, j] = sc
                sc = score_matrix[ i, j-1] + indel_score
                if sc > score_matrix[ i, j]:
                    score_matrix[ i, j] = sc

        """
        This step is called `traceback by YGC. This step seems to use the score matrix to 
        complete the sequence alignment procedure by returning the text of the alignment. 
        set the indexes to the len of the strings. This is to start out on the 3` prime and 
        move the alignment towards the 5` end. This is because for each level of the coming 
        while loop, the indeces i and j are decremented.
        """
        i = len(sequence_X) - 1
        j = len(sequence_Y) - 1

        # Here the empty alignments are initialised.
        ax = ''
        ay = ''

        while i > 1 and j > 1:
            """
            Execute the following code for all bases in the sequence, following the possible
            cases of the score_matrix.
            """
            # Case 1: perfect alignment
            sc = score_matrix[ i-1, j-1]
            if sequence_X[i] == sequence_Y[j]:
                sc = sc + match_score
            else:
                sc = sc + mismatch_score

            if sc == score_matrix[ i, j]:
                ax = sequence_X[i] + ax
                ay = sequence_Y[j] + ay
                i = i-1
                j = j-1
                continue
            
            # Case 2: best of X was aligned to gap
            if (score_matrix[ i-1, j] + indel_score) == score_matrix[ i, j]:
                ax = sequence_X[i] + ax
                ay = '-' + ay
                i = i-1
                continue
            
            # Case 3: best of Y was aligned to gap
            if (score_matrix[ i, j-1] + indel_score) == score_matrix[ i, j]:
                ax = '-' + ax
                ay = sequence_Y[j] + ay
                j = j-1
                continue 
        # Output to ST-out via print:
        print(ax)
        print(ay)
        print(score_matrix)
