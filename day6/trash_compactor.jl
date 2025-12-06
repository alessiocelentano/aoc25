const INPUT_FILE_NAME = "input.txt"


function get_op(str_op::AbstractString)::Function
    if str_op == "+"
        return (+)
    elseif str_op == "*"
        return (*)
    end
end


function part2(op::Function, lines::Vector{String}, left::Int, right::Int)::Int
    nums = Vector{Int}()

    for i = left : right
        n = 0
        tenexp = 0
        for row = lines[end - 1 : -1 : begin]
            if row[i] == ' '
                continue
            end
            n += parse(Int, row[i]) * 10^tenexp
            tenexp += 1
        end
        push!(nums, n)
    end

    return op(nums...)
end


function part1(op::Function, lines::Vector{String}, left::Int, right::Int)::Int
    return op([parse(Int, strip(line[left:right])) for line in lines[begin:end-1]]...)
end


function trash_compactor(fn::Function, input_file_name::String)::Int
    out = 0
    lines = readlines(input_file_name)

    left, right = 1, 1

    while right <= length(lines[begin])
        while right + 1 <= length(lines[begin]) && !all(==(' '), [line[right + 1] for line in lines])
            right += 1
        end

        op_row = lines[end][left:right]
        op = get_op(strip(op_row))
        out += fn(op, lines, left, right)

        right += 2
        left = right
    end

    return out
end


function main()
    println(trash_compactor(part1, INPUT_FILE_NAME))
    println(trash_compactor(part2, INPUT_FILE_NAME))
end


if abspath(PROGRAM_FILE) == @__FILE__
    main()
end
