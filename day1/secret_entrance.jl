const INPUT_FILE_NAME = "input.txt"
const DIAL_STARTING_POSITION = 50
const MAX_DIAL_NUMBER = 100


function get_op(char::Char)::Function
    if char == 'L'
        return (-)
    elseif char == 'R'
        return (+)
    end
end


function part2!(dial_position::Ref{Int}, rotations::Int)::Int
    already_counted_zero = dial_position[] == 0

    dial_position[] += rotations
    out = abs(trunc(Int, dial_position[] / MAX_DIAL_NUMBER))

    if dial_position[] <= 0
        out += !already_counted_zero
    end

    dial_position[] %= MAX_DIAL_NUMBER

    if dial_position[] < 0
        dial_position[] += MAX_DIAL_NUMBER
    end

    return out
end


function part1!(dial_position::Ref{Int}, rotations::Int)::Int
    dial_position[] = (dial_position[] + rotations) % MAX_DIAL_NUMBER
    if dial_position[] < 0
        dial_position[] += MAX_DIAL_NUMBER
    end
    return dial_position[] == 0
end


function secret_entrance(fn!::Function, input_file_name::String)::Int
    lines = readlines(input_file_name)
    dial_position = Ref(DIAL_STARTING_POSITION)
    out = 0

    for line in lines
        op = get_op(line[1])
        rotations = parse(Int, line[2:end])
        out += fn!(dial_position, op(rotations))
    end

    return out
end

    
function main()
    println(secret_entrance(part1!, INPUT_FILE_NAME))
    println(secret_entrance(part2!, INPUT_FILE_NAME))
end


if abspath(PROGRAM_FILE) == @__FILE__
    main()
end
