module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)


type alias Model =
    { shelves : Int, username : String }


model : Model
model =
    { shelves = 3, username = "danilol" }


main : Program Never Model Action
main =
    beginnerProgram { model = model, view = view, update = update }


shelfButton : String -> msg -> Bool -> Html msg
shelfButton caption action buttonDisabled =
    button
        [ disabled buttonDisabled, onClick action ]
        [ text caption ]


type Action
    = Increment Int
    | Decrement Int
    | Reset


update : Action -> Model -> Model
update msg model =
    case msg of
        Increment quantity ->
            { model | shelves = model.shelves + quantity }

        Decrement quantity ->
            { model | shelves = Basics.max 0 (model.shelves - 1) }

        _ ->
            Debug.crash "AHHHH"


view : { a | shelves : Int, username : String } -> Html Action
view model =
    let
        isDisabled =
            model.shelves <= 0

        caption =
            ((toString model.shelves)
                ++ " "
                ++ (pluralizeShelves model.shelves)
            )
    in
        div [ class "content" ]
            [ h1 [] [ text "Pluralizer" ]
            , div []
                [ shelfButton "Add a shelf" (Increment 1) False
                ]
            , div []
                [ shelfButton "Explode a shelf" (Decrement 1) isDisabled
                ]
            , text caption
            , div [] [ text ("Username: " ++ model.username) ]
            ]


pluralizeShelf : String -> Int -> String
pluralizeShelf =
    pluralize "shelf"


pluralizeShelves : Int -> String
pluralizeShelves =
    pluralize "shelf" "shelves"


pluralize : String -> (String -> (Int -> String))
pluralize singular plural quantity =
    if quantity == 1 then
        singular
    else
        plural
