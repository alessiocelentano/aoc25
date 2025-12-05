const INPUT_FILE_NAME = "input.txt"
const ROLL_OF_PAPER = '@'
const EMPTY = '.'


function get_adjacents_roll_of_papers(grid::Vector{Vector{Char}}, x::Int, y::Int)::Int
    out = 0

    for y0 = y-1 : y+1
        if y0 < 1 || y0 > length(grid)
            continue
        end

        for x0 = x-1 : x+1
            if x0 < 1 || x0 > length(grid[y0])
                continue
            end

            if x0 == x && y0 == y
                continue
            end

            if grid[y0][x0] != ROLL_OF_PAPER
                continue
            end

            out += 1
        end
    end

    return out
end
    

function forklift_roll_of_papers(grid::Vector{Vector{Char}}, target::Int)::Vector{Tuple{Int, Int}}
    out = Vector{Tuple{Int, Int}}()

    for (y, row) in enumerate(grid)
        for (x, _) in enumerate(row)
            if grid[y][x] != ROLL_OF_PAPER
                continue
            end
            if get_adjacents_roll_of_papers(grid, x, y) < target
                push!(out, (x, y))
            end
        end
    end

    return out
end


function printing_department2(input_file_name::String)
    grid = [collect(row) for row in readlines(input_file_name)]
    out = 0

    forklifts = forklift_roll_of_papers(grid, 4)
    while length(forklifts) > 0
        out += length(forklifts)
        for (x, y) in forklifts
            grid[y][x] = '.'
        end
        forklifts = forklift_roll_of_papers(grid, 4)
    end

    return out
end


function printing_department1(input_file_name::String)
    grid = [collect(row) for row in readlines(input_file_name)]
    return length(forklift_roll_of_papers(grid, 4))
end


function main()
    println(printing_department1(INPUT_FILE_NAME))
    println(printing_department2(INPUT_FILE_NAME))
end


if abspath(PROGRAM_FILE) == @__FILE__
    main()
end
