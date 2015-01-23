#=
This is the place, where I put functions, which are so annoying in OpenGL, that I felt the need to wrap them and make them more "Julian"
Its also to do some more complex error handling, not handled by the debug callback
=#
function Base.symbol(name::Vector{GLchar}, length_written::Integer)
  @assert length(name) >= length_written "bytestring is shorter, than string requested. length requested: $length_written, bytebuffer length: $(length(name))"
  symbol(bytestring(pointer(name), length_written))
end



function ModernGL.glGetAttachedShaders(program::GLuint)
    shader_count   = glGetProgramiv(program, GL_ATTACHED_SHADERS)
    length_written = GLsizei[0]
    shaders        = zeros(GLuint, shader_count)
    glGetAttachedShaders(program, 2, length_written, shaders)
    shaders[1:length_written[1]]
end


get_attribute_location(program::GLuint, name::Symbol) = get_attribute_location(program, ascii(string(name)))
function get_attribute_location(program::GLuint, name::ASCIIString)
   const location::GLint = glGetAttribLocation(program, name)
   if location == -1
       error("Named attribute (:$(name)) is not an active attribute in the specified program object or\n
           the name starts with the reserved prefix gl_\n")
   elseif location == GL_INVALID_OPERATION
       error("program is not a value generated by OpenGL or\n
               program is not a program object or\n
               program has not been successfully linked")
   end
   location
end

get_uniform_location(program::GLuint, name::Symbol) = get_uniform_location(program, ascii(string(name)))
function get_uniform_location(program::GLuint, name::ASCIIString)
   const location::GLint = glGetUniformLocation(program, name)
   if location == -1
       error("Named uniform (:$(name)) is not an active attribute in the specified program object or\nthe name starts with the reserved prefix gl_\n")
   elseif location == GL_INVALID_OPERATION
       error("program is not a value generated by OpenGL or\n
               program is not a program object or\n
               program has not been successfully linked")
   end
   location
end


function ModernGL.glGetActiveUniform(programID::GLuint, index::Integer)
    const actualLength   = GLsizei[1]
    const uniformSize    = GLint[1]
    const typ            = GLenum[1]
    const maxcharsize 	 = glGetProgramiv(programID, GL_ACTIVE_UNIFORM_MAX_LENGTH)
    const name           = Array(GLchar, maxcharsize)

    glGetActiveUniform(programID, index, maxcharsize, actualLength, uniformSize, typ, name)
    if actualLength[1] > 0
    	uname = bytestring(pointer(name), actualLength[1])
    	uname = symbol(replace(uname, r"\[\d*\]", "")) # replace array brackets. This is not really a good solution.
    	(uname, typ[1], uniformSize[1])
    else
    	error("No active uniform at given index. Index: ", index)
    end
end
function ModernGL.glGetActiveAttrib(programID::GLuint, index::Integer)
    const actualLength   = GLsizei[1]
    const attributeSize  = GLint[1]
    const typ            = GLenum[1]
    const maxcharsize    = glGetProgramiv(programID, GL_ACTIVE_ATTRIBUTE_MAX_LENGTH)
    const name           = Array(GLchar, maxcharsize)

    glGetActiveAttrib(programID, index, maxcharsize, actualLength, attributeSize, typ, name)
    if actualLength[1] > 0
      uname = bytestring(pointer(name), actualLength[1])
      uname = symbol(replace(uname, r"\[\d*\]", "")) # replace array brackets. This is not really a good solution.
      (uname, typ[1], attributeSize[1])
    else
      error("No active uniform at given index. Index: ", index)
    end
end

function ModernGL.glGetShaderiv(shaderID::GLuint, variable::GLenum)
  const result = GLint[-1]
  glGetShaderiv(shaderID, variable, result)
  result[1]
end
function ModernGL.glGetProgramiv(programID::GLuint, variable::GLenum)
    const result = GLint[-1]
    glGetProgramiv(programID, variable, result)
    result[1]
end
function ModernGL.glGetActiveUniformsiv(programID::GLuint, indices::Vector{GLuint}, variable::GLenum)
    const result = zeros(GLint, length(indices))
    glGetActiveUniformsiv(programID, length(indices), indices, variable, result)
    result
end
function ModernGL.glGetActiveUniformsiv(programID::GLuint, indices::Integer, variable::GLenum)
    const result = GLint[-1]
    glGetActiveUniformsiv(programID, 1, GLuint[indices], variable, result)
    result[1]
end
function ModernGL.glGetActiveUniformName(programID::GLuint, uniformIndex::GLuint, bufsize=255)
    const name           = zeros(GLchar, bufsize)
    const length_written = GLsizei[0]
    glGetActiveUniformName(programID, uniformIndex, bufsize, length_written, name)
    symbol(name, length_written[1])
end
ModernGL.glGetActiveUniformBlockName(programID::GLuint, uniformIndex::Integer, bufsize=255) = 
  glGetActiveUniformBlockName(programID, convert(GLuint, uniformIndex), bufsize)
function ModernGL.glGetActiveUniformBlockName(programID::GLuint, uniformIndex::GLuint, bufsize=255)
    const name           = zeros(GLchar, bufsize)
    const length_written = GLsizei[0]
    glGetActiveUniformBlockName(programID, uniformIndex, bufsize, length_written, name)
    symbol(name, length_written[1])
end

function ModernGL.glGetActiveUniformBlockiv(programID::GLuint, uniformBlockIndex::Integer, variable::GLenum)
    const result = GLint[-1]
    glGetActiveUniformBlockiv(programID, convert(GLuint, uniformBlockIndex), variable, result)
    result[1]
end
function ModernGL.glGetUniformIndices{T <: String}(programID::GLuint, uniformNames::Vector{T})
    uniformCount = length(uniformNames)
    const result = zeros(GLuint, uniformCount)
    glGetUniformIndices(programID, uniformCount, map(bytestring, uniformNames), result)
    result
end
ModernGL.glGetUniformIndices{T <: String}(programID::GLuint, uniformNames::T) = glGetUniformIndices(programID, [uniformNames])[1]

function ModernGL.glGetIntegeri_v(variable::GLenum, index::Integer)
    const result = GLint[-1]
    glGetIntegeri_v(variable, convert(GLuint, index), result)
    result[1]
end
function ModernGL.glGetIntegerv(variable::GLenum)
    const result = GLint[-1]
    glGetIntegerv(uint32(variable), result)
    result[1]
end

function ModernGL.glGenBuffers()
    const result = GLuint[0]
    glGenBuffers(1, result)
    id = result[1]
    if id <= 0
        error("glGenBuffers returned invalid id. OpenGL Context active?")
    end
    id
end
function ModernGL.glGenVertexArrays()
    const result = GLuint[0]
    glGenVertexArrays(1, result)
    id = result[1]
    if id <=0
        error("glGenVertexArrays returned invalid id. OpenGL Context active?")
    end
    id
end
function ModernGL.glGenTextures()
    const result = GLuint[0]
    glGenTextures(1, result)
    id = result[1]
    if id <= 0
        error("glGenTextures returned invalid id. OpenGL Context active?")
    end
    id
end
function ModernGL.glGenFramebuffers()
    const result = GLuint[0]
    glGenFramebuffers(1, result)
    id = result[1]
    if id <= 0
        error("glGenFramebuffers returned invalid id. OpenGL Context active?")
    end
    id
end

function ModernGL.glGetTexLevelParameteriv(target::GLenum, level, name::GLenum)
  result = GLint[0]
  glGetTexLevelParameteriv(target, level, name, result)
  result[1]
end
function checktexture(target::GLenum)

end
function glTexImage(ttype::GLenum, level::Integer, internalFormat::GLenum, w::Integer, h::Integer, d::Integer, border::Integer, format::GLenum, datatype::GLenum, data)  

  glTexImage3D(GL_PROXY_TEXTURE_3D, level, internalFormat, w, h, d, border, format, datatype, C_NULL)
  for l in  0:level
    result = glGetTexLevelParameteriv(GL_PROXY_TEXTURE_3D, l, GL_TEXTURE_WIDTH)
    if result == 0
      error("glTexImage 3D: width too large. Width: ", w)
    end
    result = glGetTexLevelParameteriv(GL_PROXY_TEXTURE_3D, l,GL_TEXTURE_HEIGHT)
    if result == 0
      error("glTexImage 3D: height too large. height: ", h)
    end
    result = glGetTexLevelParameteriv(GL_PROXY_TEXTURE_3D, l, GL_TEXTURE_DEPTH)
    if result == 0
      error("glTexImage 3D: depth too large. Depth: ", d)
    end
    result = glGetTexLevelParameteriv(GL_PROXY_TEXTURE_3D, l, GL_TEXTURE_INTERNAL_FORMAT)
    if result == 0
      error("glTexImage 3D: internal format not valid. format: ", GLENUM(internalFormat).name)
    end
  end
  glTexImage3D(ttype, level, internalFormat, w, h, d, border, format, datatype, data)
end
function glTexImage(ttype::GLenum, level::Integer, internalFormat::GLenum, w::Integer, h::Integer, border::Integer, format::GLenum, datatype::GLenum, data)
  maxsize = glGetIntegerv(GL_MAX_TEXTURE_SIZE)
  glTexImage2D(GL_PROXY_TEXTURE_2D, level, internalFormat, w, h, border, format, datatype, C_NULL)
  for l in 0:level
    result = glGetTexLevelParameteriv(GL_PROXY_TEXTURE_2D, l, GL_TEXTURE_WIDTH)
    if result == 0
      error("glTexImage 2D: width too large. Width: ", w)
    end
    result = glGetTexLevelParameteriv(GL_PROXY_TEXTURE_2D, l, GL_TEXTURE_HEIGHT)
    if result == 0
      error("glTexImage 2D: height too large. height: ", h)
    end
    result = glGetTexLevelParameteriv(GL_PROXY_TEXTURE_2D, l, GL_TEXTURE_INTERNAL_FORMAT)
    if result == 0
      error("glTexImage 2D: internal format not valid. format: ", GLENUM(internalFormat).name)
    end
  end
  glTexImage2D(ttype, level, internalFormat, w, h, border, format, datatype, data)
end
function glTexImage(ttype::GLenum, level::Integer, internalFormat::GLenum, w::Integer, border::Integer, format::GLenum, datatype::GLenum, data)
  glTexImage1D(GL_PROXY_TEXTURE_1D, level, internalFormat, w, border, format, datatype, C_NULL)
  for l in 0:level
    result = glGetTexLevelParameteriv(GL_PROXY_TEXTURE_1D, l, GL_TEXTURE_WIDTH)
    if result == 0
      error("glTexImage 1D: width too large. Width: ", w)
    end
    result = glGetTexLevelParameteriv(GL_PROXY_TEXTURE_1D, l, GL_TEXTURE_INTERNAL_FORMAT)
    if result == 0
      error("glTexImage 1D: internal format not valid. format: ", GLENUM(internalFormat).name)
    end
  end
  glTexImage1D(ttype, level, internalFormat, w, border, format, datatype, data)
end


ModernGL.glViewport(x::Rectangle) = glViewport(x.x, x.y, x.w, x.h)


function ModernGL.glGenRenderbuffers(format::GLenum, attachment::GLenum, dimensions)
    renderbuffer = GLuint[0]
    glGenRenderbuffers(1, renderbuffer)
    glBindRenderbuffer(GL_RENDERBUFFER, renderbuffer[1])
    glRenderbufferStorage(GL_RENDERBUFFER, format, dimensions...)
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, attachment, GL_RENDERBUFFER, renderbuffer[1])
    renderbuffer[1]
end