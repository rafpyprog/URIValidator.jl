using URLValidator
using Base.Test


function test_url_split_return_type()
    println("test url split return type")
    URI = "http://julialang.org"
    result = urlsplit(URI)
    println(typeof(result))
    @test isa(result, URIComponents)
end

function test_urlsplit()
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
        r = urlsplit(url)
        println(r)
        @test isa(r, URIComponents)
        @test expected_result == r.components
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


function test_urlvalidator_exception_for_invalid_scheme()
    case = (".https://julialang.org/")
    @test_throws ValidationError Validator(case)
end


@testset "Module" begin
    #@testset "URLValidador Exceptions" begin
    #    test_urlvalidator_exception_for_invalid_scheme()
    #end

    @testset "URL Split" begin
        test_url_split_return_type()
        #test_urlsplit()
    end

    #@testset "Scheme Validation" begin
    #    test_schema_validation()
    #end
end
