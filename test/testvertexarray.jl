module TestVertexArray
using ModernGL
using Test
using GLFW
using GLAbstraction: Context, set_context!, Buffer, VertexArray,
    GEOMETRY_DIVISOR, BufferAttachmentInfo, is_null, bind, unbind, draw,
    bufferinfo
using StaticArrays

# create a GL context for tests
GLFW.WindowHint(GLFW.VISIBLE, false)
window = GLFW.CreateWindow(640, 480, "Test context")
@test window != C_NULL
GLFW.MakeContextCurrent(window)
set_context!(Context(:window))


@testset "Test vertex array" begin
    # test single buffer Triangle VA
    vec = rand(SVector{3, GLfloat}, 8)
    buffer = Buffer(vec)

    attinfo = BufferAttachmentInfo(:testbuffer, GLint(0), buffer, GEOMETRY_DIVISOR)
    vao = VertexArray(BufferAttachmentInfo[attinfo], 3)

    @test !is_null(vao)
    @test bufferinfo(vao, :testbuffer) == attinfo
    @test length(vao) == 8
    @test repr(vao) != ""

    @test glGetError() == 0
    bind(vao)
    @test glGetError() == 0
    unbind(vao)
    @test glGetError() == 0
    draw(vao)
    @test glGetError() == 0

    # test double buffer triangle VA
    vec2 = rand(SVector{2, GLfloat}, 8)
    buffer2 = Buffer(vec2)

    attinfo2 = BufferAttachmentInfo(:testbuffer2, GLint(1), buffer2,
        GEOMETRY_DIVISOR)
    vao2 = VertexArray(BufferAttachmentInfo[attinfo, attinfo2], 3)
    @test vao.id != vao2.id

    @test bufferinfo(vao2, :testbuffer) == attinfo
    @test bufferinfo(vao2, :testbuffer2) == attinfo2
    @test length(vao2) == 8
    @test repr(vao2) != ""

    @test glGetError() == 0
    bind(vao2)
    @test glGetError() == 0
    draw(vao2)
    @test glGetError() == 0
    unbind(vao2)
    @test glGetError() == 0

end

# clean up test context
GLFW.DestroyWindow(window)
end
