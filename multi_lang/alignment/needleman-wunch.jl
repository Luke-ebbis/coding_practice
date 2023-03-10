#!/usr/bin/env julia
#= Needleman-wunch algorithm
author --- Sibbe Bakker
description --- An implementation of the Needleman-wunch algorithm in Julia.
    This implementation is supposed to be quicker than the python version
    because it is 'more close to the metal'.
todo --- Refactor the script to use as few global variables as possible. This
    is because global variables are slow in Julia. Also try to make the script
    work with arguments.
extra sources --- See https://bioboot.github.io/bimm143_W20/class-material/nw/
    for an interactive app on the Needleman-wunch algorithm.
=#

# For generating random sequences
using Random
# For making a array with a set size
using StaticArrays

function generate_sequence(;
    sequence_length::Int,
    letters = ["A" "T" "C" "G"])
    #=Generate a random sequence of characters with length n

    :param sequence_length: Int: The length of the sequence to be generated, 
        the length n.
    :param letters: A array of characters. These characters will be in the
        random sequence.
    :return: String: A string of length n containing only specified characters.

    dependencies --- Random
    =#
    return randstring(join(letters), sequence_length)
end


function calculate_score_matrix(;
        x::String,
        y::String,
        match_score::Int, 
        mismatch_score::Int,
        indel_score::Int)
    #=Calculate the Needleman-Wunch scoring matrix

    :param x: String: The _X_ sequence of characters.
    :param y: String: The _Y_ sequence of characters.
    :param match_score: Int64: The match score. The value scored when x and y
        are the same character.
    :param mismatch_score: Int64: The mismatch score. The value scored when x
        and y are not the same character.
    :param indel_score: Int64: The indel score. This score gets given when the
        there is an x when there is no y, or when there is an y and no x.
    :return: Matrix: The Needleman-Wunch scoring matrix.
    =#

    # initialise the matrix ---
    # add the character '0' to the start of each string.
    sequence_x = "0" * x
    sequence_y = "0" * y

    # initialising the null matrix
    score_matrix = Array{Int,2}(undef,
                                length(sequence_x), 
                                length(sequence_y))
    # mapping the indel_score to the lr edges of the matrix, starting with 0
    score_matrix[:, 1] = collect(0:length(sequence_x) - 1) * indel_score 
    score_matrix[1, :] = collect(0:length(sequence_y) - 1) * indel_score


    # filling the matrix with scores ---
    for i = 2:length(sequence_x)
        for j = 2:length(sequence_y)
            # cases for alignment to non-gap
            if sequence_x[i] == sequence_y[j]
                # in case X_i and Y-j are the same: full alignment
                score_matrix[i, j] = score_matrix[i-1, j-1] + match_score
            else
                score_matrix[i, j] = score_matrix[i-1, j-1] + mismatch_score
            end
            
            # gapped alignment cases
            #TODO determine what sc is supposed to be.
            sc = score_matrix[ i-1, j] + indel_score 
            
            if sc > score_matrix[i, j]
                score_matrix[i, j] = sc
            end

            sc = score_matrix[i, j-1] + indel_score
            if sc > score_matrix[i, j]
                score_matrix[i, j] = sc
            end
        end
    end
    return score_matrix
end


function trace_back_to_origin(;
        x::String,
        y::String,
        score_matrix::Array,
        match_score::Int, 
        mismatch_score::Int,
        indel_score::Int)
    #=Find the trace back string to the origin of the matrix.

    :param x: String: The _X_ sequence of characters.
    :param y: String: The _Y_ sequence of characters.
    :param score_matrix: Array: The scoring matrix to be used for the traceback
        calculation.
    :param match_score: Int64: The match score. The value scored when x and y
        are the same character.
    :param mismatch_score: Int64: The mismatch score. The value scored when x
        and y are not the same character.
    :param indel_score: Int64: The indel score. This score gets given when the
        there is an x when there is no y, or when there is an y and no x.
    :return: tuple(String String): The alignment between X and Y, with gaps
        introduced.
    =#

    #TODO the vector you have created seems to not have two dimensions.
    #TODO determine why the continue statements are needed
    #TODO maybe this function can use a static matrix to speed up the code even
    # more.
    # add the character '0' to the start of each string.

    sequence_x = "0" * x
    sequence_y = "0" * y
    global i = length(sequence_x)
    global j = length(sequence_y)

    #Here the empty alignments are initialised.
    ax = "" 
    ay = "" 
    
    while i > 1 && j > 1
        sc = score_matrix[i-1, j-1]
        sm = score_matrix[i,j]

        # perfect alignment
        if sequence_x[i] == sequence_y[j]
            sc = sc + match_score
        else
            sc = sc + mismatch_score
        end
        
        if sc == score_matrix[i, j]
            ax = sequence_x[i] * ax
            ay = sequence_y[i] * ay
            global i = i - 1
            global j = j - 1
            continue
        end
        
        # best if sequence x was aligned to gap (-) in y
        if score_matrix[i-1, j] + indel_score == score_matrix[i, j]
            ax = sequence_x[i] * ax
            ay = "-" * ay
            global i = i - 1
            continue
        end
        
        # best if sequence y was aligned to gap (-) in x
        if score_matrix[i, j-1] + indel_score == score_matrix[i, j]
            ax = "-" * ax
            ay = sequence_y[j] * ay
            global j = j-1
            continue
        end
    end
    return ax, ay
end


function needleman_wunch(;
        x::String,
        y::String,
        match_score::Int, 
        mismatch_score::Int,
        indel_score::Int)
    #=Needleman Wunch alignment of string X and Y

    :param x: String: The X string that must be aligned to string Y.
    :param y: String: The Y string that must be aligned to string X.
    :param match_score: Int64: The match score. The value scored when x and y
        are the same character.
    :param mismatch_score: Int64: The mismatch score. The value scored when x
        and y are not the same character.
    :param indel_score: Int64: The indel score. This score gets given when the
        there is an x when there is no y, or when there is an y and no x.
    :return: tuple (String String): The alignment between X and Y, with gaps
        introduced.
    =#
    
    score_matrix = calculate_score_matrix(x = x,
                                          y = y,
                                          match_score = match_score,
                                          mismatch_score = mismatch_score,
                                          indel_score = indel_score)
    alignment =  trace_back_to_origin(x = x,
                                      y = y,
                                      match_score = match_score,
                                      mismatch_score = mismatch_score,
                                      indel_score = indel_score,
                                      score_matrix = score_matrix)
    return alignment
end


function write_alignment(;
        filename::String,
        name::String,
        comment::String,
        alignment::Tuple)
    #=Writing the alignments to a file using a fasta like format
    
    :param filename: String: The name of the output file.
    :param name: String: The name of the alignment. Linebreaks will be removed.
        May not contain any spaces.
    :param comment: String: The comment field of the alignment. Line breaks
        will be removed.
    :param alignment: Tuple{String, String}: The alignment as a Tuple of two
        equal length strings.
    :return: None: 
    =#

    # check if the alignment is equal length
    equal_length = length(alignment[1]) == length(alignment[2])
    @assert equal_length == true "The length of alignment strings is not " * 
    "equal between string x (length = $(length(alignment[1]))) and string " *
    "y (length = $(length(alignment[2])))"

    alignment_string = ">$name $comment \n $(alignment[1])\n$(alignment[2])\n"

    if .!isfile(filename)
        # if the file does not exist, make it
        open(filename, "w") do file
            write(file, "")
        end
    end
    open(filename, "a") do file
        write(file, alignment_string)
    end
end


function main()
    #MAIN FUNCTION HERE
end

if abspath(PROGRAM_FILE) == @__FILE__
#     main()

    #= The test function 
    =#
    outfile = "alignmentfile.txt"
    number = BigInt(100000)
    length_seq = 79
    print("writing $number random alignments to $outfile, each sequence " *
          "having a length of $length_seq")
    for i=1:number
        y = generate_sequence(sequence_length = length_seq - 1)
        random_sequence = generate_sequence(sequence_length = length(y) - 1)
        #print("\n iteration ", i, "\n", random_sequence)
        alignment = needleman_wunch(x = random_sequence,
                                    y = y,
                                    match_score = 5,
                                    mismatch_score = -2,
                                    indel_score = -6)
        write_alignment(filename = outfile,
                        name = string(i),
                        comment = "alignment of random sequences",
                        alignment = alignment)
        global outnum = i
    end
    print("\n final iteration ($outnum) reached\n")
end
