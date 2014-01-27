Diffbot API Client Library for FORTRAN
======================================

Using AI, computer vision, machine learning and natural language processing,
[Diffbot](http://diffbot.com/products/) provides developers numerous tools 
to understand and extract from any web page.

Requirements:
- command line tool [**curl**] (http://curl.haxx.se/)
- FORTRAN 95 JSON Parser [**fson**](https://github.com/josephalevin/fson) (included into the library)
- [**gfortran**](http://gcc.gnu.org/wiki/GFortran) compiler

## Diffbot API Client function ##

The client function diffbot is located in the fdiffbot module and has the 
following signature

    fson_value function diffbot(url, token, api, optargs, version)

where

    url     -- string of URL to process (will be URL-encoded automatically)
    token   -- string of Diffbot API access token
    api     -- string of Diffbot API type (default "article")
    optargs -- array of strings for optional parameters (default empty)
               Example: ["fields=meta,querystring,images(*)", "timeout=5"] 
    version -- integer version of Diffbot API (default 2)

    return value -- fson_value pointer to json parsed response (will be equal to
                    null for unsuccessful request)

The function diffbot does a GET request to the Diffbot server in according to the passed arguments
and parameters and then parses corresponding json response.
The detailed description for the arguments, optional parameters and its 
available values one can find [**there**](http://diffbot.com/products/automatic/).

## Usage in fixed-form FORTRAN 77 code ##

           program example2

           use fson
           use fdiffbot

           implicit none

           character(len=*), parameter :: token = "xxxx"

           type(fson_value), pointer :: response
               
           integer, parameter :: BUFF_LEN = 100
           character(len=BUFF_LEN) api  
           character(len=BUFF_LEN) optargs(3)

           integer version

           real category

           ! add optional parameters, api type and its version
           api = "analyze"
           optargs(1) = "mode=article"
           optargs(2) = "fields=meta,tags"
           optargs(3) = "stats"
           version = 2

           response => diffbot("http://www.google.com", 
         $                     token, api, optargs, version)

           ! print json response to the console
           call fson_print(response)

           ! free memory
           call fson_destroy(response)
            
           end

Building

    gfortran -c modules/fson_string_m.f95
    gfortran -c modules/fson_value_m.f95
    gfortran -c modules/fson_path_m.f95
    gfortran -c modules/fson.f95
    gfortran -c modules/fdiffbot.f90
    gfortran -c example2.f
    gfortran -o example2_f example2.o fson_string_m.o fson_value_m.o fson_path_m.o fson.o fdiffbot.o
    

## Usage in free-form FORTRAN code ##

    include "modules/fson_string_m.f95"
    include "modules/fson_value_m.f95"
    include "modules/fson_path_m.f95"
    include "modules/fson.f95"
    include "modules/fdiffbot.f90"

    program example2

        use fson
        use fdiffbot

        implicit none

        character(len=*), parameter :: token = "xxxx"

        type(fson_value), pointer :: response
        
        integer, parameter :: BUFF_LEN = 100
        character(len=BUFF_LEN) api  
        character(len=BUFF_LEN) optargs(3)

        integer version

        real category

        ! add optional parameters, api type and its version
        api = "analyze"
        optargs(1) = "mode=article"
        optargs(2) = "fields=meta,tags"
        optargs(3) = "stats"
        version = 2

        response => diffbot("http://www.google.com", token, api, optargs, version)

        ! print json response to the console
        call fson_print(response)

        ! free memory
        call fson_destroy(response)
     
    end program example2

Building

    gfortran -o example2 example2.f90

-Initial commit by Maksim Boyko-
