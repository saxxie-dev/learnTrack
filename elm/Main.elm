module Main exposing (main)

import Api.Generated
    exposing
        ( Track
        , Widget(..)
        , trackDecoder
        , widgetDecoder
        )
import Browser
import Html exposing (..)
import Json.Decode as D
import Widgets.NewTrack
import Widgets.TrackGrid


type Model
    = TrackModel Widgets.NewTrack.Model
    | TrackGridModel Widgets.TrackGrid.Model
    | ErrorModel String


type Msg
    = GotTrackMsg Widgets.NewTrack.Msg
    | GotTrackGridMsg Widgets.TrackGrid.Msg
    | WidgetErrorMsg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case ( msg, model ) of
        ( GotTrackMsg subMsg, TrackModel track ) ->
            Widgets.NewTrack.update subMsg track
                |> updateWith TrackModel GotTrackMsg model

        (GotTrackGridMsg subMsg, TrackGridModel subModel) -> 
            Widgets.TrackGrid.update subMsg subModel
                |> updateWith TrackGridModel GotTrackGridMsg model

        ( WidgetErrorMsg, ErrorModel _ ) ->
            ( model, Cmd.none )

        _ ->
            ( model, Cmd.none )

updateWith :
    (subModel -> Model)
    -> (subMsg -> Msg)
    -> Model
    -> ( subModel, Cmd subMsg )
    -> ( Model, Cmd Msg )
updateWith toModel toMsg model ( subModel, subCmd ) =
    ( toModel subModel, Cmd.map toMsg subCmd )


subscriptions : Model -> Sub Msg
subscriptions parentModel =
    case parentModel of
        TrackModel track ->
            Sub.map GotTrackMsg
                (Widgets.NewTrack.subscriptions track)
        
        TrackGridModel subModel -> 
            Sub.map GotTrackGridMsg
                (Widgets.TrackGrid.subscriptions subModel)

        ErrorModel err ->
            Sub.none


view : Model -> Html Msg
view model =
    case model of
        ErrorModel errorMsg ->
            errorView errorMsg

        TrackModel track ->
            Html.map GotTrackMsg (Widgets.NewTrack.view track)
        
        TrackGridModel submodel -> 
            Html.map GotTrackGridMsg (Widgets.TrackGrid.view submodel)


errorView : String -> Html msg
errorView errorMsg =
    pre [] [ text "Widget Error: ", text errorMsg ]


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
    initiate flags


initiate : D.Value -> (Model, Cmd Msg)
initiate flags =
    case D.decodeValue widgetDecoder flags of
        Ok widget ->
            (widgetFlagToModel widget, widgetFlagToCmd widget)

        Err error ->
            (ErrorModel (D.errorToString error), Cmd.none)

widgetFlagToCmd : Widget -> Cmd Msg
widgetFlagToCmd widget =
    case widget of
        TrackWidget _ ->
            Cmd.map GotTrackMsg Widgets.NewTrack.initialCmd
        TrackGridWidget -> 
            Cmd.map GotTrackGridMsg Widgets.TrackGrid.initialCmd


widgetFlagToModel : Widget -> Model
widgetFlagToModel widget =
    case widget of
        TrackWidget track ->
            TrackModel track
        
        TrackGridWidget -> 
            TrackGridModel Widgets.TrackGrid.initialModel