const INPUT_FILE_NAME = "input.txt"


function digits_to_int(digits::Vector{Int})::Int
    out = 0
    tenexp = 0
    for digit in reverse(digits)
        out += digit * 10^tenexp
        tenexp += 1
    end
    return out
end


function enough_digits_to_add(digits::Vector{Int}, ndigits::Int,
                                chosen_digit_index::Int, new_digit_index::Int)
    digits_to_replace = ndigits - chosen_digit_index
    digits_left = length(digits) - new_digit_index
    return digits_to_replace <= digits_left
end


function get_worse_digits(chosen_digits::Vector{Int}, digit::Int)::Vector{Int}
    indices = Vector{Int}()

    for (i, n) in enumerate(chosen_digits)
        if digit > n
            push!(indices, i)
        end
    end

    return indices
end


function max_number(digits::Vector{Int}, ndigits::Int)::Int
    if length(digits) <= ndigits
        return digits_to_int(digits)
    end

    chosen_digits = Vector{Int}()

    for (digit_index, digit) in enumerate(digits)
        added = false
        indices = get_worse_digits(chosen_digits, digit)
        for chosen_digit_index in indices
            if enough_digits_to_add(digits, ndigits, chosen_digit_index, digit_index)
                resize!(chosen_digits, chosen_digit_index - 1)
                push!(chosen_digits, digit)
                added = true
                break
            end
        end
        if !added && length(chosen_digits) < ndigits
            push!(chosen_digits, digit)
        end
    end

    return digits_to_int(chosen_digits)
end


function part2(input::String)::Int
    array = Vector{Int}()
    for digit in input
        push!(array, parse(Int, digit))
    end
    return max_number(array, 12)
end


function part1(input::String)::Int
    array = Vector{Int}()
    for digit in input
        push!(array, parse(Int, digit))
    end
    return max_number(array, 2)
end


function lobby(fn::Function, input_file_name::String)::Int
    out = 0
    lines = readlines(input_file_name)

    i = 1
    for line in lines
        out += fn(line)
        i += 1
    end

    return out
end


function main()
    println(lobby(part1, INPUT_FILE_NAME))
    println(lobby(part2, INPUT_FILE_NAME))
end


if abspath(PROGRAM_FILE) == @__FILE__
    main()
end
