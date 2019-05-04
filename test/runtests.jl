function is_ci()
    get(ENV, "TRAVIS", "") == "true" ||
    get(ENV, "APPVEYOR", "") == "true" ||
    get(ENV, "CI", "") == "true"
end

include("testtexture.jl")
include("testbuffer.jl")
include("testvertexarray.jl")
include("testshader.jl")
