module Web.View.Tracks.New where
import Web.View.Prelude

data NewView = NewView { track :: Track }

instance View NewView where
    html NewView { .. } = [hsx|
        {breadcrumb}
        <h1>New Track</h1>
        {renderForm track}
    |]
        where
            breadcrumb = renderBreadcrumb
                [ breadcrumbLink "Tracks" $ TracksAction currentUserId
                , breadcrumbText "New Track"
                ]

renderForm :: Track -> Html
renderForm track = formFor track [hsx|
    {(textField #name)}
    {(textField #completion)}
    {(textField #size)}
    {(checkboxField #paused)}
    {submitButton}

|]