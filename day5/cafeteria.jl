const INPUT_FILE_NAME = "input.txt"
    

function merge_ranges(ranges::Vector{Tuple{Int, Int}})::Vector{Tuple{Int, Int}}
    out = Vector{Tuple{Int, Int}}()
    last_range_index = 1

    for i = 2 : length(ranges)
        j = last_range_index
        if first(ranges[j]) <= first(ranges[i]) <= last(ranges[j])
            ranges[j] = (first(ranges[j]), max(last(ranges[j]), last(ranges[i])))
        else
            push!(out, ranges[j])
            last_range_index = i
        end
    end
    push!(out, ranges[last_range_index])

    return out
end


function cafeteria2(input_file_name::String)::Int
    out = 0
    ranges = Vector{Tuple{Int, Int}}()

    lines = readlines(input_file_name)

    for line in lines
        if isempty(line) break end
        min, max = split(line, "-")
        push!(ranges, (parse(Int, min), parse(Int, max)))
    end

    sort!(ranges, by=first)
    ranges = merge_ranges(ranges)

    for range in ranges
        out += last(range) - first(range) + 1
    end
    
    return out
end


function cafeteria1(input_file_name::String)::Int
    out = 0
    ranges = Vector{Tuple{Int, Int}}()

    lines = readlines(input_file_name)
    divider = findfirst(==(""), lines)

    for line in lines[begin:divider-1]
        min, max = split(line, "-")
        push!(ranges, (parse(Int, min), parse(Int, max)))
    end

    for line in lines[divider+1:end]
        num = parse(Int, line)
        for range in ranges
            if first(range) <= num <= last(range)
                out += 1
                break
            end
        end
    end

    return out
end


function main()
    println(cafeteria1(INPUT_FILE_NAME))
    println(cafeteria2(INPUT_FILE_NAME))
end


if abspath(PROGRAM_FILE) == @__FILE__
    main()
end
