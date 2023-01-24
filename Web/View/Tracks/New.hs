module Web.View.Tracks.New where
import Web.View.Prelude

data NewView = NewView { track :: Track }

instance View NewView where
    html NewView { .. } =  renderModal
        Modal
            { modalTitle = "New Column",
            modalCloseUrl = pathTo $ TracksAction $ currentUserId,
            modalFooter = Nothing,
            modalContent = renderForm track
            }
        
        

renderForm :: Track -> Html
renderForm track = formFor track [hsx|
    {(textField #name)}
    {(textField #completion)}
    {(textField #size)}
    {(checkboxField #paused)}
    {submitButton}

|]