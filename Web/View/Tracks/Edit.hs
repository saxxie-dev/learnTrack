module Web.View.Tracks.Edit where
import Web.View.Prelude

data EditView = EditView { track :: Track }

instance View EditView where
    html EditView { .. } = [hsx|
        {breadcrumb}
        <div class="display-block md:text-center">
        <h1 >Edit Track</h1>
        </div>
        {renderForm track}
    |]
        where
            breadcrumb = renderBreadcrumb
                [ breadcrumbLink "Tracks" $ TracksAction currentUserId
                , breadcrumbText "Edit Track"
                ]

renderForm :: Track -> Html
renderForm track = formFor track [hsx|
    {trackWidget track}
    {(textField #name)}
    {(textField #completion)}
    {(textField #size)}
    {(checkboxField #paused)}
    {submitButton}

|]