#= This file is a part of URIValidator. License is MIT:
https://github.com/rafpyprog/URIValidator.jl/blob/master/LICENSE.md =#

using URIValidator
using Base.Test


function test_URISplit_return_URIcomponets()
    URI = "http://julialang.org"
    result = URISplit(URI)
    println(typeof(result))
    @test isa(result, URIComponents)
end


function test_URISplit_RFC()
    #= Each case is a tuple with the url and the expected result. =#
    cases = [
        ("http://julialang.org",
            ("http", "julialang.org", "", "", "" )),
        ("http://example.com:8042/over/there?name=ferret#nose",
            ("http", "example.com:8042", "/over/there", "name=ferret", "nose")),
        ("file:///tmp/junk.txt",
            ("file", "", "/tmp/junk.txt", "", "")),
        ("svn+ssh://svn.zope.org/repos/main/ZConfig/trunk/",
            ("svn+ssh", "svn.zope.org", "/repos/main/ZConfig/trunk/", "", "")),
        ("git+ssh://git@github.com/user/project.git",
            ("git+ssh", "git@github.com","/user/project.git", "", "")),
        ("nfs://server/path/to/file.txt",
            ("nfs", "server", "/path/to/file.txt", "", "")),
        ("https://julialang.org/#abc",
            ("https", "julialang.org", "/", "", "abc")),
        ("https://julialang.org?q=abc",
            ("https", "julialang.org", "", "q=abc", "")),
        ("https://julialang.org/#abc",
            ("https", "julialang.org", "/", "", "abc")),
        ("http://a/b/c/d;p?q#f",
            ("http", "a", "/b/c/d;p", "q", "f")),
        ("urn:example:animal:ferret:nose",
            ("urn", "", "example:animal:ferret:nose", "", "")),
        ]

    for case in cases
        url = case[1]
        expected_result = case[2]
        result = URISplit(url)
        @test isequal(expected_result, result.components)
    end
end


function test_schema_validation()
    # Samples: https://www.iana.org/assignments/uri-schemes/uri-schemes.xhtml
    cases = (
                ("chrome-extension", true),
                ("http", true),
                ("pkcs11", true),
                ("z39.50r", true),
                ("scheme+withplus", true),
                (" http", false),
                ("1http", false),
                (".http", false),
                ("http=", false),
                ("ht tp", false)
            )

    for case in cases
        scheme, expected_result = case
        result = scheme_is_valid(scheme)
        @test result == expected_result
    end
end


function test_Validator_exception_for_invalid_scheme()
    URI = (".https://julialang.org/")
    @test_throws ValidationError Validator(URI)
end


@testset "Module" begin
    @testset "URLValidador Exceptions" begin
        test_Validator_exception_for_invalid_scheme()
    end

    @testset "URL Split" begin
        test_URISplit_return_URIcomponets()
        test_URISplit_RFC()
    end

    @testset "Validators" begin
        test_schema_validation()
    end
end
