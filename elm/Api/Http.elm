
module Api.Http exposing (..)

import Api.Generated exposing (Track, trackDecoder)
import Http
import Json.Decode as D

getTracksAction :
    String
    -> (Result Http.Error (List Track) -> msg)
    -> Cmd msg
getTracksAction searchTerm msg =
    ihpRequest
        { method = "GET"
        , headers = []
        , url = "/Tracks?searchTerm=" ++ searchTerm
        , body = Http.emptyBody
        , expect = Http.expectJson msg (D.list trackDecoder)
        }

ihpRequest :
    { method : String
    , headers : List Http.Header
    , url : String
    , body : Http.Body
    , expect : Http.Expect msg
    }
    -> Cmd msg
ihpRequest { method, headers, url, body, expect } =
    Http.request
        { method = method
        , headers =
        [ Http.header "Accept" "application/json" ] ++ headers
        , url = url
        , body = body
        , expect = expect
        , timeout = Nothing
        , tracker = Nothing
        }
