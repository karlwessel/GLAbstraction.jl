import ModernGL.glGetAttribLocation, ModernGL.glGetIntegerv, ModernGL.glGenBuffers, ModernGL.glGenVertexArrays, ModernGL.glGenTextures
#import ModernGL.glTexImage1D, ModernGL.glTexImage2D, ModernGL.glTexImage3D
#function glGetAttribLocation(program::GLuint, name::ASCIIString)
#    location = glGetAttribLocation(program, name)
#    if location == -1 
#        error("Named attribute(:$(name)) variable is not an active attribute in the specified program object or\n
#            the name starts with the reserved prefix gl_\n")
#    elseif location == GL_INVALID_OPERATION
#        error("program is not a value generated by OpenGL or\n
#                program is not a program object or\n
#                program has not been successfully linked")
#    end
#    location
#end

function glGetIntegerv(variable::GLenum)
    result::Ptr{GLint} = int32([-1])
    glGetIntegerv(uint32(variable), result)
    unsafe_load(result)
end
function glGenBuffers()
    result::Ptr{GLuint} = uint32([0])
    glGenBuffers(1, result)
    id = unsafe_load(result)
    if id <= 0 
        error("glGenBuffers returned invalid id. OpenGL Context active?")
    end
    id
end
function glGenVertexArrays()
    result::Ptr{GLuint} = uint32([0])
    glGenVertexArrays(1, result)
    id = unsafe_load(result)
    if id <=0 
        error("glGenVertexArrays returned invalid id. OpenGL Context active?")
    end
    id
end
function glGenTextures()
    result::Ptr{GLuint} = uint32([0])
    glGenTextures(uint64(1), result)
    id = unsafe_load(result)
    if id <= 0 
        error("glGenTextures returned invalid id. OpenGL Context active?")
    end
    id
end

glTexImage(level::Integer, internalFormat::GLenum, w::Integer, h::Integer, d::Integer, border::Integer, format::GLenum, datatype::GLenum, data) = glTexImage3D(GL_TEXTURE_3D, level, internalFormat, w, h, d, border, format, datatype, data) 
glTexImage(level::Integer, internalFormat::GLenum, w::Integer, h::Integer, border::Integer, format::GLenum, datatype::GLenum, data) = glTexImage2D(GL_TEXTURE_2D, level, internalFormat, w, h, border, format, datatype, data) 
glTexImage(level::Integer, internalFormat::GLenum, w::Integer, border::Integer, format::GLenum, datatype::GLenum, data) = glTexImage1D(GL_TEXTURE_1D, level, internalFormat, w, border, format, datatype, data) 
export glTexImage