include("components.jl")


function splitnetloc(url, start=0)
    component_delims = "/?#"
    delim = length(url) # position of end of domain part of url, default is end
    has_delimiter = false
    for c in component_delims  # look for delimiters; the order is NOT important
        wdelim = searchindex(url, c, start)  # find first of this delim
        if wdelim > 0  # if found
            delim = min(delim, wdelim) # use earliest delim position
            has_delimiter = true
        end
    end

    if (has_delimiter == true) & (delim == length(url))
        rest = url[end]
        domain = url[start:end-1]
    elseif has_delimiter == true
        rest = url[delim:end]
        domain = url[start:delim-1]
    else
        domain = url[start:end]
        rest = ""
    end
    return domain, rest
end


function has_delimiter(url, delimiter)
    if isa(url, AbstractString)
        check = contains(url, delimiter)
    elseif isa(url, Char)
        check = delimiter in url
    else
        println("Invalid url type.")
        throw(DomainError())
    end
    return check
end


function urlsplit(url, allow_fragments=true)
    #= Parse a URL into 5 components:
    <scheme>://<netloc>/<path>?<query>#<fragment> =#
    netloc = query = fragment = ""

    i = searchindex(url, ":")
    if i > 0
        if url[1:i-1] == "http" # optimize the common case
            scheme = lowercase(url[1:i-1])
            url = url[i+1:end]
            if url[1:2] == "//"
                netloc, url = splitnetloc(url, 3)
                if ((contains(netloc, "[")  & (!contains(netloc, "]"))) | (contains(netloc, "]")  & (!contains(netloc, "["))))
                    println("Invalid IPv6 URL")
                    throw(DomainError())
                end
            end

            if allow_fragments & has_delimiter(url, "#")
                url, fragment = split(url, "#", limit=2)
            end

            if has_delimiter(url, "?")
                url, query = split(url, "?", limit=2)
            end
            splited_URI = Dict("scheme"=>scheme, "authority"=>netloc, "path"=>url, "query"=>query, "fragment"=>fragment)
            components = URIComponents(splited_URI)
            return components
        else
            #= # make sure "url" is not actually a port number (in which case
            # "scheme" is really part of the path) =#
            rest = url[i + 1:end]
            if !isdefined(:rest) | any(!(c in "0123456789") for c in rest)
                # not a port number
                scheme, url = lowercase(url[1:i-1]), rest
            end
        end
    end

    if url[1:2] == "//"
        netloc, url = splitnetloc(url, 3)
        if ((contains(netloc, "[")  & (!contains(netloc, "]"))) | (contains(netloc, "]")  & (!contains(netloc, "["))))
            println("Invalid IPv6 URL")
            throw(DomainError())
        end
    end

    if allow_fragments & has_delimiter(url, "#")
        url, fragment = split(url, "#", limit=2)
    end

    if has_delimiter(url, "?")
        url, query = split(url, "?", limit=2)
    end
    splited_URI = Dict("scheme"=>scheme, "authority"=>netloc, "path"=>url, "query"=>query, "fragment"=>fragment)
    components = URIComponents(splited_URI)
    return components
end
