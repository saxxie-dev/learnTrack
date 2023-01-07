module Web.Controller.Tracks where

import Web.Controller.Prelude
import Web.View.Tracks.Index
import Web.View.Tracks.New
import Web.View.Tracks.Edit
import Web.View.Tracks.Show

instance Controller TracksController where
    action TracksAction = do
        tracks <- query @Track |> fetch
        render IndexView { .. }

    action NewTrackAction = do
        let track = newRecord
        render NewView { .. }

    action ShowTrackAction { trackId } = do
        track <- fetch trackId
        render ShowView { .. }

    action EditTrackAction { trackId } = do
        track <- fetch trackId
        render EditView { .. }

    action UpdateTrackAction { trackId } = do
        track <- fetch trackId
        track
            |> buildTrack
            |> ifValid \case
                Left track -> render EditView { .. }
                Right track -> do
                    track <- track |> updateRecord
                    setSuccessMessage "Track updated"
                    redirectTo EditTrackAction { .. }

    action CreateTrackAction = do
        let track = newRecord @Track
        track
            |> buildTrack
            |> ifValid \case
                Left track -> render NewView { .. } 
                Right track -> do
                    track <- track |> createRecord
                    setSuccessMessage "Track created"
                    redirectTo TracksAction

    action DeleteTrackAction { trackId } = do
        track <- fetch trackId
        deleteRecord track
        setSuccessMessage "Track deleted"
        redirectTo TracksAction

buildTrack track = track
    |> fill @["ownerId", "completion", "size", "paused"]
