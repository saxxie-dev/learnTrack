module Widgets.NewTrack exposing (..)

import Api.Generated exposing (Track)
import Html exposing (..)


type alias Model =
    Track


init : Track -> ( Model, Cmd msg )
init track =
    ( track, Cmd.none )

initialCmd : Cmd Msg
initialCmd = Cmd.none

subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none


type Msg
    = NoOp


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )


view : Model -> Html Msg
view track =
    div []
        [ h2 [] [ text track.id ]
        , p []
            [ text "Pages: "
            ]
        , p []
            [ text
                (if track.name == "my track" then
                    "You have read this track"

                 else
                    "You have not read this track"
                )
            ]
        , p [] [ ]
        ]


showReview : Maybe String -> Html msg
showReview maybeReview =
    case maybeReview of
        Just review ->
            text ("Your track review: " ++ review)

        Nothing ->
            text "You have not reviewed this track"