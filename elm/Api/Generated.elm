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


widgetEncoder : Widget -> Json.Encode.Value
widgetEncoder a =
    case a of
        TrackWidget b ->
            trackEncoder b


widgetDecoder : Json.Decode.Decoder Widget
widgetDecoder =
    Json.Decode.map TrackWidget trackDecoder


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