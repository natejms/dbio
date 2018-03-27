port module Publish exposing (main)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput, onClick)
import Navigation exposing (load)


main =
    Html.program
      { view = view
      , update = update
      , init = init
      , subscriptions = subscriptions
      }


-- MODEL

type alias Desc =
  { name         : String
  , location     : String
  , image        : String
  , work         : String
  , education    : String
  , bio : String
  }

type alias Model =
  { desc : Desc
  }

port pub : Desc -> Cmd msg

init : (Model, Cmd Msg)
init =
  ( { desc =
      { name         = ""
      , location     = ""
      , image        = ""
      , work         = ""
      , education    = ""
      , bio          = ""
      }
    }
  , Cmd.none
  )


-- VIEW


view : Model -> Html Msg
view model =
    div []
      [ input [ type_ "text", placeholder "Name", onInput Name] []
      , input [ type_ "text", placeholder "Location", onInput Location] []
      , input [ type_ "text", placeholder "IPFS image hash", onInput Image] []
      , div [ class "two-inputs" ]
        [ input [ type_ "text", placeholder "Work", onInput Work] []
        , input [ type_ "text", placeholder "Education", onInput Education] []
        ]
      , textarea [ placeholder "Talk about yourself", onInput Bio] []
      , input [ type_ "submit", value "Publish", onClick Submit] []
      ]



-- UPDATE
updateName desc name = { desc | name = name }
updateImage desc img = { desc | image = img }
updateWork desc work = { desc | work = work }
updateEducation desc education = { desc | education = education }
updateLocation desc location = { desc | location = location }
updateBio desc bio = { desc | bio = bio }

type Msg
    = Name String
    | Image String
    | Work String
    | Education String
    | Location String
    | Bio String
    | Submit
    | Navigate String


update : Msg -> Model -> (Model, Cmd msg)
update msg model =
    case msg of
      Name new ->
        ( { model |
            desc = updateName model.desc new
          }
        , Cmd.none
        )
      Image new ->
        ( { model |
          desc = updateImage model.desc new
          }
        , Cmd.none
        )
      Work new ->
        ( { model |
          desc = updateWork model.desc new
          }
        , Cmd.none
        )
      Education new ->
        ( { model |
            desc = updateEducation model.desc new
          }
        , Cmd.none
        )
      Location new ->
        ( { model |
            desc = updateLocation model.desc new
          }
        , Cmd.none
        )
      Bio new ->
        ( { model |
            desc = updateBio model.desc new
          }
        , Cmd.none
        )
      Submit ->
        ( model
        , pub model.desc
        )
      Navigate hash ->
        ( model
        , load ("u/#" ++ hash)
        )


-- SUBSCRIPTIONS


port new_hash : (String -> msg) -> Sub msg

subscriptions : Model -> Sub Msg
subscriptions model =
    new_hash Navigate
