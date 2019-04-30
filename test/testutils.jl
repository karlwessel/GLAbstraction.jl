using Test
using GLFW
using GLAbstraction: Context, set_context!

function createtestcontext()
    # create a GL context for tests
    GLFW.WindowHint(GLFW.VISIBLE, false)
    window = GLFW.CreateWindow(640, 480, "Test context")
    @test window != C_NULL
    GLFW.MakeContextCurrent(window)
    set_context!(Context(:window))
    return window
end

function freetestcontext(c)
    GLFW.DestroyWindow(c)
end

macro testnoglerror()
    return :(@test GLENUM(glGetError()) == GLENUM(GL_FALSE))
end

macro testnoglerror(v)
    return :($(esc(v)); @testnoglerror)
end
