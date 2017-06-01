#= This file is a part of URIValidator. License is MIT:
https://github.com/rafpyprog/URIValidator.jl/blob/master/LICENSE.md =#

type URIComponents
    scheme
    authority
    path
    query
    fragment
    components

    function URIComponents(splited_URI)
        splited_URI_size = length(splited_URI)
        if splited_URI_size != 5
            message = "Splited URI length($splited_URI_size) is not valid. Should be 5"
            throw(ArgumentError(message))
        end

        this = new()
        this.scheme = splited_URI["scheme"]
        this.authority = splited_URI["authority"]
        this.path = splited_URI["path"]
        this.query = splited_URI["query"]
        this.fragment = splited_URI["fragment"]
        this.components = (this.scheme, this.authority, this.path, this.query,
                           this.fragment)
        return this
    end
end
