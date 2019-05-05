module TestTexture
using ModernGL
using Test
using GLAbstraction: Texture, bind, texparameter, glasserteltype
using StaticArrays
using FileIO
using Images

include("testutils.jl")

# create a GL context for tests
c = createtestcontext()

function Texture(image::AbstractArray{T, NDim}; kw_args...) where {T, NDim}
    glasserteltype(T)
    Texture(pointer(image), size(image); kw_args...)::Texture{T, NDim}
end

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
    
    # test with more abstract array types
    @testnoglerror tex_black = Texture(colorview(RGBA, zeros(GLfloat, 4, 2, 2)))
    @test tex_black.id != 0
    @testnoglerror bind(tex_black)
end

# clean up test context
freetestcontext(c)
end

