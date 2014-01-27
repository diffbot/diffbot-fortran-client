! Copyright (c) 2014 Maksim Boyko
!
! Permission is hereby granted, free of charge, to any person obtaining a copy of
! this software and associated documentation files (the "Software"), to deal in
! the Software without restriction, including without limitation the rights to
! use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
! the Software, and to permit persons to whom the Software is furnished to do so,
! subject to the following conditions:
!
! The above copyright notice and this permission notice shall be included in all
! copies or substantial portions of the Software.
!
! THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
! IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
! FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
! COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
! IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
! CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

!     
! File:   fdiffbot.f90
! Author: Maksim Boyko
!
! Created on January 13, 2014, 9:30 PM
!

module fdiffbot

    use fson

    implicit none

contains

    !
    ! Diffbot API Client function
    !
    !     url     -- URL to process (will be URL-encoded automatically)
    !     token   -- Diffbot API access token
    !     api     -- type of Diffbot API (default article)
    !     optargs -- array of optional parameters (default empty)
    !                Example: ["fields=meta,querystring,images(*)", "timeout=5"] 
    !     version -- version of Diffbot API (default 2)
    !
    !     return value -- pointer to json parsed response (will be equal to
    !                     null for unsuccessful request)
    !
    function diffbot(url, token, api, optargs, version) result(fson_p)

        implicit none

        character(len=*), intent(in) :: url
        character(len=*), intent(in) :: token
        character(len=*), optional, intent(in) :: api
        character(len=*), optional, intent(in) :: optargs (:)
        integer,          optional, intent(in) :: version
        type(fson_value), pointer :: fson_p

        character(len=100) endpoint
        character(len=100) response

        character(len=:), allocatable :: api_loc
        character(len=:), allocatable :: optargs_loc
        character(len=:), allocatable :: curl_cmd

        integer version_loc
        integer exit_code
        integer i


        if (present(api)) then
            api_loc = api
        else
            api_loc = "article"
        end if
        if (present(version)) then
            version_loc = version
        else
            version_loc = 2
        end if

        write(endpoint, "('http://api.diffbot.com/v',i0,'/',a)") version_loc, trim(api_loc)
        write(response, "('diffbot.',i0'.json')") getpid()
        
        curl_cmd = "curl -s -G -o " // trim(response)

        optargs_loc = "--data-urlencode 'url=" // trim(url) // "' -d 'token=" // trim(token) // "'"
        if (present(optargs)) then
            do i = 1, ubound(optargs, 1)
                optargs_loc = optargs_loc // " -d '" // trim(optargs(i)) // "'"
            end do
        end if

        curl_cmd = trim(curl_cmd) // " " // trim(optargs_loc) // " " // trim(endpoint)

        !write(*, *) trim(curl_cmd)

        call system(curl_cmd, exit_code)

        if (exit_code == 0) then
            fson_p => fson_parse(response)
        else
            fson_p => null()
        end if

        call system("rm -f " // trim(response), exit_code)

    end function diffbot

end module fdiffbot
