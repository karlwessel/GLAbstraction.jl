module TestVertexArray
using ModernGL
using Test
using GLAbstraction: Buffer, VertexArray,
    GEOMETRY_DIVISOR, BufferAttachmentInfo, is_null, bind, unbind, draw,
    bufferinfo
using StaticArrays
include("testutils.jl")

# create a GL context for tests
c = createtestcontext()

@testset "Test vertex array" begin
    # test single buffer Triangle VA
    vec = rand(SVector{3, GLfloat}, 8)
    buffer = Buffer(vec)

    attinfo = BufferAttachmentInfo(:testbuffer, GLint(0), buffer,
        GEOMETRY_DIVISOR)
    @testnoglerror vao = VertexArray(BufferAttachmentInfo[attinfo], 3)
    @test vao.face == GL_TRIANGLES

    @test !is_null(vao)
    @test bufferinfo(vao, :testbuffer) == attinfo
    @test length(vao) == 8
    @test repr(vao) != ""

    @testnoglerror
    @testnoglerror bind(vao)
    @testnoglerror unbind(vao)
    @testnoglerror draw(vao)

    # test double buffer triangle VA
    vec2 = rand(SVector{2, GLfloat}, 8)
    buffer2 = Buffer(vec2)

    attinfo2 = BufferAttachmentInfo(:testbuffer2, GLint(1), buffer2,
        GEOMETRY_DIVISOR)
    @testnoglerror
    @testnoglerror vao2 = VertexArray(BufferAttachmentInfo[attinfo, attinfo2],
        GL_LINE_STRIP)
    @test vao.id != vao2.id
    @test vao2.face == GL_LINE_STRIP

    @test bufferinfo(vao2, :testbuffer) == attinfo
    @test bufferinfo(vao2, :testbuffer2) == attinfo2
    @test length(vao2) == 8
    @test repr(vao2) != ""

    @testnoglerror
    @testnoglerror bind(vao2)
    @testnoglerror draw(vao2)
    @testnoglerror unbind(vao2)

end

# clean up test context
freetestcontext(c)
end
