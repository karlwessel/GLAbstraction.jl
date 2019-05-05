module TestTexture
using ModernGL
using Test
using GLAbstraction: Texture, bind, texparameter
using StaticArrays
using FileIO
using Images

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
    
    # test srgb textures
    @testnoglerror tex_srgb = Texture(img, internalformat=GL_SRGB)
    @test tex.id != 0    
    @testnoglerror bind(tex)
    
    @testnoglerror tex_alpha = Texture(img_alpha, internalformat=GL_SRGB_ALPHA)
    @test tex_alpha.id != 0
    @test tex_alpha.id != tex.id
    @testnoglerror bind(tex_alpha)
    
    # test greyvalue rgba using swizzlemask
    @testnoglerror tex_swizzle = Texture(red.(img))
    @test tex_swizzle.id != 0
    @testnoglerror texparameter(tex_swizzle, GL_TEXTURE_SWIZZLE_RGBA, 
            GLenum[GL_RED, GL_RED, GL_RED, GL_RED])
    @testnoglerror bind(tex_swizzle)
    
end

# clean up test context
freetestcontext(c)
end

