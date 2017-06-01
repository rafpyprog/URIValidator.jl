#!/usr/bin/julia

using Base.Test
using URIValidator

splited = Dict("scheme"=>"http",
               "authority"=>"julialang.org",
               "path"=>"",
               "query"=>"",
               "fragment"=>"")

function test_invalid_argument_exception()
    n = deepcopy(splited)
    pop!(n, "fragment", nothing) #remove one component
    result = URIComponents(n)
end


function test_uri_component_type()
    result = URIComponents(splited)
    return isa(result, URIComponents)
end

function test_components_fields()
    result = URIComponents(splited)
    check_components = (
        isequal(result.scheme, splited["scheme"]),
        isequal(result.authority, splited["authority"]),
        isequal(result.path, splited["path"]),
        isequal(result.query, splited["query"]),
        isequal(result.fragment, splited["fragment"]),
        )
    return all(check_components)
end

function test_components_tuple()
    test_case = URIComponents(splited)
    components = test_case.components
    return isequal(length(components), 5)
end


@testset "URIComponents" begin
    @test test_uri_component_type()
    @test test_components_fields()
    @test test_components_tuple()
    @test_throws ArgumentError test_invalid_argument_exception()
end
