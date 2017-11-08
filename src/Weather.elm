-- Read more about this program in the official Elm guide:
-- https://guide.elm-lang.org/architecture/effects/http.html


module Main exposing (..)

import Debug
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Json.Decode as Decode exposing (field)


main =
    Html.program
        { init = init "Berlin"
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- MODEL


type alias Model =
    { word : String, city : String, inputValue : String, reportUrl : String, report : Maybe Report }


init : String -> ( Model, Cmd Msg )
init city =
    ( Model "" city "" (getWeatherReportUrl city) Nothing, getWeatherReport city )


type alias ReportUrl =
    { url : String }



-- UPDATE


type Msg
    = CityInput String
    | WeatherReportPlease
    | Maiuscula String
    | NewReport String (Result Http.Error Report)
    | None


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        CityInput tempCity ->
            ( { model | inputValue = tempCity }, Cmd.none )

        WeatherReportPlease ->
            ( { model | city = model.inputValue, inputValue = "" }, getWeatherReport model.inputValue )

        Maiuscula word ->
            let
                debug =
                    Debug.log ">>>>>" word
            in
                ( { model | word = word }, Cmd.none )

        NewReport url (Ok newReport) ->
            --( Model model.city model.inputValue model.reportUrl newReport, Cmd.none )
            ( { model | reportUrl = url, report = (Just newReport) }, Cmd.none )

        NewReport url (Err x) ->
            let
                debug =
                    Debug.log ">>>>>" x
            in
                ( { model | reportUrl = url }, Cmd.none )

        None ->
            ( model, Cmd.none )



-- VIEW


view : Model -> Html Msg
view model =
    let
        lat =
            case model.report of
                Just report ->
                    toString report.coord.lat

                Nothing ->
                    "Error!!!"

        lon =
            case model.report of
                Just report ->
                    toString report.coord.lon

                Nothing ->
                    "Error!!!"

        temp =
            case model.report of
                Just report ->
                    toString report.main.temp

                Nothing ->
                    "Error!!!"

        min =
            case model.report of
                Just report ->
                    toString report.main.tempMin

                Nothing ->
                    "Error!!!"

        max =
            case model.report of
                Just report ->
                    toString report.main.tempMax

                Nothing ->
                    "Error!!!"
    in
        div []
            [ br [] []
            , input [ type_ "text", placeholder "City", onInput CityInput, onKeyPress wasEnter, value model.inputValue ] []
            , button [ onClick WeatherReportPlease ] [ text "Get me weather report, now!!" ]
            , button [ onClick (maiuscula "danilo") ] [ text "Converte ae" ]
            , h2 [] [ text model.city ]
            , h2 [] [ text model.word ]
            , br [] []
            , div []
                [ text "URL"
                , h3 [] [ text model.reportUrl ]
                ]
            , div []
                [ text "Geolocation"
                , h3 [] [ text (lat ++ " - " ++ lon) ]
                ]
            , div []
                [ text "Weather"
                , h3 [] [ text (temp ++ "°") ]
                , h3 [] [ text (min ++ "° Min") ]
                , h3 [] [ text (max ++ "° Max") ]
                ]
            ]


maiuscula : String -> Msg
maiuscula word =
    if String.length word > 10 then
        Maiuscula (String.toUpper word)
    else
        Maiuscula word


wasEnter : Int -> Msg
wasEnter key =
    if key == 13 then
        WeatherReportPlease
    else
        None


onKeyPress : (Int -> msg) -> Attribute msg
onKeyPress tagger =
    on "keypress" (Decode.map tagger keyCode)



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- HTTP


getWeatherReportUrl : String -> String
getWeatherReportUrl city =
    "http://api.openweathermap.org/data/2.5/weather?appid=c4ec15791ed2c066cca8dd5d51ad6a74&q=" ++ city ++ "&units=metric"


getWeatherReport : String -> Cmd Msg
getWeatherReport city =
    let
        url =
            getWeatherReportUrl city
    in
        Http.send (NewReport url) (Http.get url decodeReport)



--Debug.log ">>>>" Http.send NewReport (makeRequest city)


makeRequest : String -> Http.Request Report
makeRequest city =
    Http.get (getWeatherReportUrl city) decodeReport



--Debug.log ">>>>" Http.send NewReport (makeRequest city)


type alias Report =
    { coord : ReportCoord
    , main : ReportMain
    , sys : ReportSys
    , name : String
    }


type alias ReportCoord =
    { lon : Float
    , lat : Float
    }


type alias ReportMain =
    { temp : Float
    , pressure : Int
    , humidity : Int
    , tempMin : Float
    , tempMax : Float
    }


type alias ReportSys =
    { country : String
    , sunrise : Int
    , sunset : Int
    }


decodeReport : Decode.Decoder Report
decodeReport =
    Decode.map4 Report
        (field "coord" decodeReportCoord)
        (field "main" decodeReportMain)
        (field "sys" decodeReportSys)
        (field "name" Decode.string)


decodeReportCoord : Decode.Decoder ReportCoord
decodeReportCoord =
    Decode.map2 ReportCoord
        (field "lon" Decode.float)
        (field "lat" Decode.float)


decodeReportMain : Decode.Decoder ReportMain
decodeReportMain =
    Decode.map5 ReportMain
        (field "temp" Decode.float)
        (field "pressure" Decode.int)
        (field "humidity" Decode.int)
        (field "temp_min" Decode.float)
        (field "temp_max" Decode.float)


decodeReportSys : Decode.Decoder ReportSys
decodeReportSys =
    Decode.map3 ReportSys
        (field "country" Decode.string)
        (field "sunrise" Decode.int)
        (field "sunset" Decode.int)
