const INPUT_FILE_NAME = "input.txt"
const PAIR_CONNECTIONS = 1000
const TOP_CIRCUITS = 3


struct Point3D
    x::Int
    y::Int
    z::Int
end


struct PointDistance
    points::Tuple{Point3D, Point3D}
    value::Real

    function PointDistance(p1::Point3D, p2::Point3D)
        points = (p1, p2)
        value = sqrt(
            (p1.x - p2.x)^2 +
            (p1.y - p2.y)^2 +
            (p1.z - p2.z)^2
        )
        new(points, value)
    end
end


function part2(distances::Vector{PointDistance}, point_to_set::Dict{Point3D, Ref{Set{Point3D}}})::Int
    local p1::Point3D
    local p2::Point3D

    while length(collect(Set(values(point_to_set)))) > 1
        dist = pop!(distances)
        p1, p2 = dist.points
        for point in point_to_set[p2][]
            push!(point_to_set[p1][], point)
            point_to_set[point] = point_to_set[p1]
        end
    end

    return p1.x * p2.x
end
    

function part1(distances::Vector{PointDistance}, point_to_set::Dict{Point3D, Ref{Set{Point3D}}})::Int
    for _ = 1 : PAIR_CONNECTIONS
        dist = pop!(distances)
        p1, p2 = dist.points
        for point in point_to_set[p2][]
            push!(point_to_set[p1][], point)
            point_to_set[point] = point_to_set[p1]
        end
    end

    sorted_sets = sort(collect(Set(values(point_to_set))), by = x -> length(x[]), rev = true)
    return *(map(x -> length(x[]), sorted_sets[begin:TOP_CIRCUITS])...)
end


function playground(fn::Function, input_file_name::String)::Int
    lines = readlines(input_file_name)
    points = Vector{Point3D}()
    distances = Vector{PointDistance}()

    for line in lines
        x, y, z = map(x -> parse(Int, x), split(line, ","))
        push!(points, Point3D(x, y, z))
    end

    for i = 1 : length(points)
        for j = i + 1 : length(points)
            p1 = points[i]
            p2 = points[j]
            push!(distances, PointDistance(p1, p2))
        end
    end

    sort!(distances, by = x -> x.value, rev = true)

    point_to_set = Dict{Point3D, Ref{Set{Point3D}}}()
    for p in points
        set = Set([p])
        point_to_set[p] = Ref(set)
    end

    return fn(distances, point_to_set)

end


function main()
    println(playground(part1, INPUT_FILE_NAME))
    println(playground(part2, INPUT_FILE_NAME))
end


if abspath(PROGRAM_FILE) == @__FILE__
    main()
end