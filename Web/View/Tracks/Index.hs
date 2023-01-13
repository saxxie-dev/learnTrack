module Web.View.Tracks.Index where
import Web.View.Prelude

data IndexView = IndexView { tracks :: [Track]  }

instance View IndexView where
    html IndexView { .. } = [hsx|
        {breadcrumb}

        <h1>Index<a href={pathTo NewTrackAction} class="btn btn-primary ms-4">+ New</a></h1>
        <div class="table-responsive">
            <table class="table">
                <thead>
                    <tr>
                        <th>Track</th>
                        <th></th>
                        <th></th>
                        <th></th>
                    </tr>
                </thead>
                <tbody>{forEach tracks renderTrack}</tbody>
            </table>
            
        </div>
    |]
        where
            breadcrumb = renderBreadcrumb
                [ breadcrumbLink "Tracks" TracksAction
                ]

renderTrack :: Track -> Html
renderTrack track = [hsx|
    <tr>
        <td>{track.name}</td>
        <td>{track.completion} / {track.size}</td>
        <td><a href={ShowTrackAction track.id}>Show</a></td>
        <td><a href={EditTrackAction track.id} class="text-muted">Edit</a></td>
        <td><a href={DeleteTrackAction track.id} class="js-delete text-muted">Delete</a></td>
    </tr>
|]