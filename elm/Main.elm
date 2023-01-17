module Main exposing (main)

import Api.Generated exposing (Track, Widget(..), widgetDecoder)
import Browser
import Html exposing (Html, div, h1, h2, p, pre, text)
import Json.Decode as D


type Model
    = TrackModel Track
    | ErrorModel String


type Msg
    = NoOp


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


view : Model -> Html msg
view model =
    div []
        [ text "<🌳>"
        , widgetView model
        , text "</🌳>"
        ]


widgetView : Model -> Html msg
widgetView model =
    case model of
        ErrorModel errorMsg ->
            errorView errorMsg

        TrackModel track ->
            trackView track


errorView : String -> Html msg
errorView errorMsg =
    pre [] [ text "Widget Error: ", text errorMsg ]


trackView : Track -> Html msg
trackView track =
    div []
        [ h2 [] [ text track.name ]
        , p []
            [ text
                (if track.name == "asdf" then
                    "You have read this track"

                 else
                    "You have not read this track"
                )
            ]
        ]


showReview : Maybe String -> Html msg
showReview maybeReview =
    case maybeReview of
        Just review ->
            text ("Your track review: " ++ review)

        Nothing ->
            text "You have not reviewed this track"


main : Program D.Value Model Msg
main =
    Browser.element
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }


init : D.Value -> ( Model, Cmd Msg )
init flags =
    ( initialModel flags
    , Cmd.none
    )


initialModel : D.Value -> Model
initialModel flags =
    case D.decodeValue widgetDecoder flags of
        Ok widget ->
            widgetFlagToModel widget

        Err error ->
            ErrorModel (D.errorToString error)


widgetFlagToModel : Widget -> Model
widgetFlagToModel widget =
    case widget of
        TrackWidget track ->
            TrackModel track