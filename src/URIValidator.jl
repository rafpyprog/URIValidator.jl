#= This file is a part of URIValidator. License is MIT:
https://github.com/rafpyprog/URIValidator.jl/blob/master/LICENSE.md =#

module URIValidator

# source files
include("validator.jl")

export Validator, URISplit, scheme_is_valid, ValidationError, URIComponents

end  # module
