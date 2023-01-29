#!/usr/bin/env python
"""Needleman Wunch algorithm algorithm
author --- Sibbe Bakker
description --- An implementation of the needleman wunch alignment algorithm.
    This algorithm is a global alignment algorithm, it works best for comparing
    sequences of equal length. For simple complexity alignments, such as short
    sequences, or a small amount of sequences, this programme works adiquatly,
    but for a large amount of iterations (<1000×) this script is too slow to be
    practical.
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
    :param letters: iter: A array of characters. These characters will be in
        the random sequence.
    :return: str: A string of length n containing only specified characters.

    dependencies --- random
    """

    random_seq = (choice(letters) for x in range(sequence_length))
    random_string = "".join(random_seq)
    return random_string


def calculate_score_matrix(x: str,
                           y: str,
                           match_score: int,
                           mismatch_score: int,
                           indel_score: int) -> np.array:
    """Calculate the Needleman-Wunch scoring matrix

    :param x: str: The _X_ sequence of characters.
    :param y: str: The _Y_ sequence of characters.
    :param match_score: int: The match score. The value scored when x and y
        are the same character.
    :param mismatch_score: int: The mismatch score. The value scored when x
        and y are not the same character.
    :param indel_score: int: The indel score. This score gets given when the
        there is an x when there is no y, or when there is an y and no x.
    :return: np.array: The Needleman-Wunch scoring matrix.

    dependencies --- numpy as np
    """

    sequence_X = '0%s' % x
    sequence_Y = '0%s' % y

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
    The two loops on the lines below make sure that every base in X and Y are
    compared
    """
    for i in range(1, len(sequence_X)):
        for j in range(1, len(sequence_Y)):
            # Cases for alignment to non gap
            if sequence_X[i] == sequence_Y[j]:
                # In case X_i and Y_j are the same (i.e. alignment)
                score_matrix[i, j] = score_matrix[i-1, j-1] + match_score
            else:
                score_matrix[i, j] = score_matrix[i-1, j-1] + mismatch_score

            # Cases for alignment with gap.
            sc = score_matrix[i-1, j] + indel_score
            if sc > score_matrix[i, j]:
                score_matrix[i, j] = sc
            sc = score_matrix[i, j-1] + indel_score
            if sc > score_matrix[i, j]:
                score_matrix[i, j] = sc
    return score_matrix


def trace_back_to_origin(x: str,
                         y: str,
                         score_matrix: np.array,
                         match_score: int,
                         mismatch_score: int,
                         indel_score: int) -> tuple:
    """Finding the trace back string for a Matrix.

    :param x: str: The _X_ sequence of characters.
    :param y: str: The _Y_ sequence of characters.
    :param score_matrix: np.array: The scoring matrix to be used for the
        traceback calculation.
    :param match_score: int: The match score. The value scored when x and y
        are the same character.
    :param mismatch_score: int: The mismatch score. The value scored when x
        and y are not the same character.
    :param indel_score: int: The indel score. This score gets given when the
        there is an x when there is no y, or when there is an y and no x.
    :return: tuple(str str): The alignment between X and Y, with gaps
        introduced.
    """

    # Add the character '0' to the start of each string.
    sequence_X = '0%s' % x
    sequence_Y = '0%s' % y
    i = len(sequence_X) - 1
    j = len(sequence_Y) - 1

    # Here the empty alignments are initialised.
    ax = ''
    ay = ''
    while i > 1 and j > 1:
        # Case 1: perfect alignment
        sc = score_matrix[i-1, j-1]
        if sequence_X[i] == sequence_Y[j]:
            sc = sc + match_score
        else:
            sc = sc + mismatch_score

        if sc == score_matrix[i, j]:
            ax = sequence_X[i] + ax
            ay = sequence_Y[j] + ay
            i = i-1
            j = j-1
            continue
        # Case 2: best of X was aligned to gap
        if (score_matrix[i-1, j] + indel_score) == score_matrix[i, j]:
            ax = sequence_X[i] + ax
            ay = '-' + ay
            i = i-1
            continue

        # Case 3: best of Y was aligned to gap
        if (score_matrix[i, j-1] + indel_score) == score_matrix[i, j]:
            ay = sequence_Y[j] + ay
            j = j-1
            continue
    # ax and yx are the alignments.
    return ax, ay


def needleman_wunch(x: str,
                    y: str,
                    match_score: int,
                    mismatch_score: int,
                    indel_score: int) -> tuple:
    """
    :param x: str: The X string that must be aligned to string Y.
    :param y: str: The Y string that must be aligned to string X.
    :param match_score: int: The match score. The value scored when x and y
        are the same character.
    :param mismatch_score: int: The mismatch score. The value scored when x
        and y are not the same character.
    :param indel_score: int: The indel score. This score gets given when the
        there is an x when there is no y, or when there is an y and no x.
    :return: tuple (str, str): The alignment between X and Y, with gaps
        introduced.
    """
    score_matrix = calculate_score_matrix(x=x,
                                          y=y,
                                          match_score=match_score,
                                          mismatch_score=mismatch_score,
                                          indel_score=indel_score)
    alignment = trace_back_to_origin(x=x,
                                     y=y,
                                     score_matrix=score_matrix,
                                     match_score=match_score,
                                     mismatch_score=mismatch_score,
                                     indel_score=indel_score)
    return alignment


def main():
    """The main function
    """
    for i in range(100000):
        y_string = generate_sequence(sequence_length=60 - 1)
        x_string = generate_sequence(sequence_length=len(y_string) - 1)
        alignment = needleman_wunch(x=x_string,
                                    y=y_string,
                                    match_score=5,
                                    mismatch_score=-2,
                                    indel_score=-6)


if __name__ == "__main__":

    main()
