module Application exposing (..)

import Html exposing (..)


type alias Model =
    { title: String
    }



-- Our Flags type alias must match the data passed to it from the index.html


type alias Flags =
    { title: String
    }


initialModel : Model
initialModel =
    { title = "This should not be displayed"
    }


main : Program Flags Model Msg
main =
    programWithFlags
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- init function to take the initial model but change title to the title flag passed to it


init : Flags -> ( Model, Cmd Msg )
init flags =
    ( { initialModel | title = flags.title }
    , Cmd.none
    )


view : Model -> Html Msg
view model =
    div []
        [ span []
            [ text (model.title) ]
        ]


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Example ->
            ( model, Cmd.none )


type Msg
    = Example
