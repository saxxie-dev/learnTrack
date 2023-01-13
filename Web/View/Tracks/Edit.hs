module Web.View.Tracks.Edit where
import Web.View.Prelude

data EditView = EditView { track :: Track }

instance View EditView where
    html EditView { .. } = [hsx|
        {breadcrumb}
        <h1>Edit Track</h1>
        {renderForm track}
    |]
        where
            breadcrumb = renderBreadcrumb
                [ breadcrumbLink "Tracks" TracksAction
                , breadcrumbText "Edit Track"
                ]

renderForm :: Track -> Html
renderForm track = formFor track [hsx|
    {(textField #name)}
    {(textField #completion)}
    {(textField #size)}
    {(textField #paused)}
    {submitButton}

|]