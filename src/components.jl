type URIComponents
    scheme::String
    authority::String
    path::String
    query::String
    fragment::String
    components

    function URIComponents(splited_URI)
        this = new()
        this.scheme = splited_URI["scheme"]
        this.authority = splited_URI["authority"]
        this.path = splited_URI["path"]
        this.query = splited_URI["query"]
        this.fragment = splited_URI["fragment"]
        this.components = (this.scheme, this.authority, this.path, this.query,
                           this.fragment)
    end
end

a = Dict([("scheme", "2"), ("authority", "2"), ("path", "2"), ("query", "2"), ("fragment", "2")])
URIComponents(a)
