       program example1

       use fson_value_m
       use fson
       use fdiffbot

       implicit none

       character(len=*), parameter :: token = "xxxx"

       type(fson_value), pointer :: response
       type(fson_value), pointer :: media
           
       integer, parameter :: BUFF_LEN = 100
       character(len=BUFF_LEN) path
       character(len=BUFF_LEN) title
       character(len=BUFF_LEN) url
       character(len=BUFF_LEN) media_type

       real category


       response => diffbot("http://www.google.com", token)

       ! print json response to the console
       call fson_print(response)

       ! extract data from the parsed json response
       ! string
       path = "meta.title"
       call fson_get(response, path, title)
       ! string
       path = "url"
       call fson_get(response, path, url)
       ! real
       path = "categories.education"
       call fson_get(response, path, category)
       ! first array element
       path = "media"
       call fson_get(response, path, media)
       path = "type"
       !call fson_print(fson_value_get(media, 1))
       call fson_get(fson_value_get(media, 1), path, media_type)

       write(*, *)
       write(*, "(a)") "Parsed json responsed data:"
       write(*, "(2(1x,a))") "Title:", trim(title)
       write(*, "(2(1x,a))") "URL:", trim(url)
       write(*, "(2(1x,a))") "First media type:", trim(media_type)
       write(*, "(1x,a,1x,f12.9)") "Education category:", category

       ! free memory
       call fson_destroy(response)
        
       end
