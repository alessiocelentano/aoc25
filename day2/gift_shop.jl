import Base: <, <=, ==


const INPUT_FILE_NAME = "input.txt"


mutable struct NumberPartition{T <: Integer}
    segments::Vector{T}
    size::Int
    segment_size::Int

    function NumberPartition(n::T, size::Int, segment_size::Int) where {T <: Integer}
        if segment_size * size != ndigits(n)
            throw(ArgumentError("n must be divisible into segments with equal size"))
        end

        segments = Vector{T}()

        for tenexp = ndigits(n) - segment_size : -segment_size : 0
            segment = div(n, (10^tenexp))
            append!(segments, segment)
            n -= segment * 10^tenexp
        end

        new{T}(segments, size, segment_size)
    end
end


NumberPartition(n::T, size::Int) where {T <: Integer} = NumberPartition(n, size, div(ndigits(n), size))


function number_partition_compare(partition1::NumberPartition, partition2::NumberPartition)::Int
    if partition1.size != partition2.size
        return (partition1.size < partition2.size) ? -1 : 1
    end

    for (segment1, segment2) in zip(partition1.segments, partition2.segments)
        if segment1 < segment2
            return -1
        elseif segment1 > segment2
            return 1
        end
    end

    return 0
end


function <(partition1::NumberPartition, partition2::NumberPartition)::Bool
    return number_partition_compare(partition1, partition2) == -1
end

function <=(partition1::NumberPartition, partition2::NumberPartition)::Bool
    npc = number_partition_compare(partition1, partition2)
    return npc == -1 || npc == 0
end


function ==(partition1::NumberPartition, partition2::NumberPartition)::Bool
    return number_partition_compare(partition1, partition2) == 0
end


function add_to_each_segment(partition::NumberPartition, n::Int)
    partition.segments .+= n
    if all(==(1), partition.segments ./ (10^partition.segment_size) .< 1)
        return
    elseif all(==(ndigits(partition.segments[1])), ndigits.(partition.segments))
        partition.segment_size = ndigits(partition.segments[1])
    else
        partition = NumberPartition(join(partition), partition.size)
    end
end


function join(partition::NumberPartition)::BigInt
    out = 0
    tenexp = 0
    for segment in reverse(partition.segments)
        out += segment * 10^tenexp
        tenexp += ndigits(segment)
    end
    return out
end


function get_equal_segment_partitions(first::Int, last::Int, size::Int)::Set{BigInt}
    out = Set{BigInt}()

    while ndigits(first) % size != 0 && first <= last
        first = 10^ndigits(first)
    end

    while ndigits(last) % size != 0 && last > 0
        last = 10^(ndigits(last) - 1) - 1
    end

    if first > last
        return out
    end

    first_partition = NumberPartition(first, size)
    last_partition = NumberPartition(last, size)
    partition = NumberPartition(first, size)
    partition.segments .= partition.segments[1]

    while partition < first_partition
        add_to_each_segment(partition, 1)
    end

    while partition <= last_partition
        push!(out, join(partition))
        add_to_each_segment(partition, 1)
    end

    return out
end


function part2(first::Int, last::Int)::Set{BigInt}
    out = Set{BigInt}()
    for size = 2 : ndigits(last)
        union!(out, get_equal_segment_partitions(first, last, size))
    end
    return out
end


function part1(first::Int, last::Int)::Set{BigInt}
    return get_equal_segment_partitions(first, last, 2)
end


function gift_shop(fn::Function, input_file_name::String)::BigInt
    ranges = split(read(input_file_name, String), ",")
    out::BigInt = 0

    for range in ranges
        first, last = map(x -> parse(Int, x), split(range, "-"))
        out += sum(fn(first, last))
    end

    return out
end


function main()
    println(gift_shop(part1, INPUT_FILE_NAME))
    println(gift_shop(part2, INPUT_FILE_NAME))
end


if abspath(PROGRAM_FILE) == @__FILE__
    main()
end
