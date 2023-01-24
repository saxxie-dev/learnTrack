module Api.Generated exposing
    ( Widget(..)
    , widgetEncoder
    , widgetDecoder
    , Track
    , trackEncoder
    , trackDecoder
    )

import Json.Decode
import Json.Decode.Pipeline
import Json.Encode


type Widget 
    = TrackWidget Track
    | TrackGridWidget 


widgetEncoder : Widget -> Json.Encode.Value
widgetEncoder a =
    case a of
        TrackWidget b ->
            Json.Encode.object [ ("tag" , Json.Encode.string "TrackWidget")
            , ("contents" , trackEncoder b) ]

        TrackGridWidget ->
            Json.Encode.object [("tag" , Json.Encode.string "TrackGridWidget")]


widgetDecoder : Json.Decode.Decoder Widget
widgetDecoder =
    Json.Decode.field "tag" Json.Decode.string |>
    Json.Decode.andThen (\a -> case a of
        "TrackWidget" ->
            Json.Decode.succeed TrackWidget |>
            Json.Decode.Pipeline.required "contents" trackDecoder

        "TrackGridWidget" ->
            Json.Decode.succeed TrackGridWidget

        _ ->
            Json.Decode.fail "No matching constructor")


type alias Track  =
    { id : String, name : String }


trackEncoder : Track -> Json.Encode.Value
trackEncoder a =
    Json.Encode.object [ ("id" , Json.Encode.string a.id)
    , ("name" , Json.Encode.string a.name) ]


trackDecoder : Json.Decode.Decoder Track
trackDecoder =
    Json.Decode.succeed Track |>
    Json.Decode.Pipeline.required "id" Json.Decode.string |>
    Json.Decode.Pipeline.required "name" Json.Decode.string