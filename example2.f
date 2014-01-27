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
