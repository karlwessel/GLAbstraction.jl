module TestBuffer
using ModernGL
using Test
using GLAbstraction: Buffer, bind, unbind
using StaticArrays

include("testutils.jl")

# create a GL context for tests
c = createtestcontext()


@testset "Test buffers" begin
    vec = rand(8)
    @testnoglerror buffer = Buffer(vec)

    @test size(buffer) == size(vec)
    @test buffer == vec

    @testnoglerror bind(buffer)
    @testnoglerror unbind(buffer)

    vec32 = rand(GLfloat, 8)
    @testnoglerror buffer32 = Buffer(vec32)

    @test buffer32 == vec32

    points = rand(SVector{3, GLfloat}, 4)
    @testnoglerror buffer_arr = Buffer(points)

    @test size(buffer_arr) == size(points)
    @test buffer_arr == points
end

# clean up test context
freetestcontext(c)
end
