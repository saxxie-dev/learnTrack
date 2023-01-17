module Web.View.Tracks.Index where
import Web.View.Prelude

data IndexView = IndexView { tracks :: [Track]  }

instance View IndexView where
    html IndexView { .. } = [hsx|
        {breadcrumb}
        <section>
            <h1>Learning tracks<a href={pathTo NewTrackAction} class="btn btn-primary ms-4">+ New</a></h1>
            {forEach tracks renderTrack}
        </section>
    |]
        where
            breadcrumb = renderBreadcrumb
                [ breadcrumbLink "Tracks" $ TracksAction currentUserId
                ]

renderTrack :: Track -> Html
renderTrack track = [hsx|
    <section style="display: flex; flex-direction: horizontal">
        <div style="width: 300px; flex-grow: 0">{track.name}
          (<a href={EditTrackAction track.id} class="text-muted">Edit</a>)
          (<a href={DeleteTrackAction track.id} class="js-delete text-muted">Delete</a>)
        </div>
        <div>{forEachWithIndex track.completion renderTrackCheck}</div>
    </section>
|]



renderTrackCheck :: (Int, Bool) -> Html
renderTrackCheck (i, b) = [hsx|
    <label>{i}<input type="checkbox" checked={b}/></label>
|]