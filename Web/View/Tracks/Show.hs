module Web.View.Tracks.Show where
import Web.View.Prelude

data ShowView = ShowView { track :: Track }

instance View ShowView where
    html ShowView { .. } = [hsx|
        {breadcrumb}
        <h1>Show Track</h1>
        <p>{track}</p>

    |]
        where
            breadcrumb = renderBreadcrumb
                            [ breadcrumbLink "Tracks" TracksAction
                            , breadcrumbText "Show Track"
                            ]