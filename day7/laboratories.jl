import Base: ==, hash
using DataStructures


const INPUT_FILE_NAME = "input.txt"


mutable struct Beam
    x::Int
    y::Int
end


function ==(b1::Beam, b2::Beam)::Bool
    return b1.x == b2.x && b1.y == b2.y
end


function hash(b::Beam, h::UInt)::UInt
    return hash((b.x, b.y), h)
end


function copy(b::Beam)
    return Beam(b.x, b.y)
end


function split(b::Beam)::Tuple{Beam, Beam}
    return (Beam(b.x - 1, b.y), Beam(b.x + 1, b.y))
end


function count_paths(beam::Beam, lines::Vector{String}, memo::Dict{Beam, Int} = Dict{Beam, Int}())::Int
    while beam.y < length(lines) && lines[beam.y + 1][beam.x] == '.'
        beam.y += 1
    end

    if beam.y >= length(lines)
        return 1

    elseif lines[beam.y + 1][beam.x] == '^'
        if haskey(memo, beam)
            return memo[beam]
        end
        if beam.x - 1 > 0
            left = count_paths(Beam(beam.x - 1, beam.y + 1), lines, memo)
        end
        if beam.x + 1 <= length(lines[beam.y])
            right = count_paths(Beam(beam.x + 1, beam.y + 1), lines, memo)
        end
        memo[beam] = left + right
        return left + right
    end
end


function laboratories2(input_file_name::String)::Int
    lines = readlines(input_file_name)
    out = 0

    beams = Deque{Beam}()
    for x in findall('S', lines[begin]) 
        push!(beams, Beam(x, 1))
    end

    for b in beams
        out += count_paths(b, lines)
    end

    return out
end


function laboratories1(input_file_name::String)::Int
    lines = readlines(input_file_name)
    out = 0

    beams = Deque{Beam}()
    for x in findall('S', lines[begin]) 
        push!(beams, Beam(x, 1))
    end

    while !isempty(beams)
        seen = Set{Beam}()

        for _ = 1: length(beams)
            beam = popfirst!(beams)
            beam.y += 1

            if beam.y > length(lines)
                continue

            elseif lines[beam.y][beam.x] == '^'
                out += 1
                for subbeam in split(beam)
                    if !(subbeam in seen) && 0 < subbeam.x <= length(lines[subbeam.y])
                        push!(beams, subbeam)
                        push!(seen, copy(subbeam))
                    end
                end

            elseif lines[beam.y][beam.x] == '.'
                if !(beam in seen) && 0 < beam.x <= length(lines[beam.y])
                    push!(beams, beam)
                    push!(seen, copy(beam))
                end
            end
        end
    end

    return out
end


function main()
    println(laboratories1(INPUT_FILE_NAME))
    println(laboratories2(INPUT_FILE_NAME))
end


if abspath(PROGRAM_FILE) == @__FILE__
    main()
end
