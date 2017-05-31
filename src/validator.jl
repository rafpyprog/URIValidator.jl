__precompile__()

include("urlsplit.jl")


type ValidationError <: Exception
    var::String
end


function scheme_is_valid(scheme)
    #= Validates the Scheme component (RFC3986 item 3.1)

    Scheme names consist of a sequence of characters beginning with a letter
    and  followed  by any combination of letters, digits, plus ("+"), period
    ("."), or hyphen ("-")
    =#
    scheme = lowercase(scheme) # the canonical form is lowercase
    starts_with_letter = ismatch(r"^[a-z]", scheme)
    combination_letters_digits_plus_period_hyphen = ismatch(r"^[a-z0-9+\.-]+$",
                                                            scheme)

    if starts_with_letter & combination_letters_digits_plus_period_hyphen
        is_valid = true
    else
        is_valid = false
    end
   return is_valid
end


function authority_is_valid(authority)
    #= Validates the Scheme component (RFC3986 item 3.2)

    The authority component is preceded by a double slash ("//") and is
   terminated by the next slash ("/"), question mark ("?"), or number
   sign ("#") character, or by the end of the URI.

   authority   = [ userinfo "@" ] host [ ":" port ]
    =#
    pass
end

function path_is_valid(path)
    #= If a URI contains an authority component, then the path component
   must either be empty or begin with a slash ("/") character.  =#
end


type Validator
    url
    scheme

    function Validator(URI)
        this = new()
        this.URI = URI
        URI_components = urlsplit(this.URI)

        # scheme validation
        this.scheme = URI_components.scheme
        if !scheme_is_valid(this.scheme)
            throw(ValidationError("Scheme '" * this.scheme * "' is invalid."))
        else

        #authority validation'
        this.authority = URI_components.authority
            println("ok")
        end
    end
end
