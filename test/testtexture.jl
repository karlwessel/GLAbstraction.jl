module TestTexture
using ModernGL
using Test
using GLAbstraction: Texture, bind
using StaticArrays
using FileIO

include("testutils.jl")

# create a GL context for tests
c = createtestcontext()


@testset "Test Texture" begin
    img = load("rgb_test.png")
    @testnoglerror tex = Texture(img)
    @test tex.id != 0    
    @testnoglerror bind(tex)
    
    img_alpha = load("alpha_test.png")
    @testnoglerror tex_alpha = Texture(img_alpha)
    @test tex_alpha.id != 0
    @test tex_alpha.id != tex.id
    @testnoglerror bind(tex_alpha)
    
    @testnoglerror tex_srgb = Texture(img, internalformat=GL_SRGB)
    @test tex.id != 0    
    @testnoglerror bind(tex)
    
    @testnoglerror tex_alpha = Texture(img_alpha, internalformat=GL_SRGB_ALPHA)
    @test tex_alpha.id != 0
    @test tex_alpha.id != tex.id
    @testnoglerror bind(tex_alpha)
end

# clean up test context
freetestcontext(c)
end

