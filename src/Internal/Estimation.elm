module Internal.Estimation exposing (velocity)

{-| -}

import Animator
import Internal.Interpolate as Interpolate
import Internal.Timeline as Timeline
import Time


mapTime fn time =
    Time.millisToPosix (fn (Time.posixToMillis time))


{-| Estimate velocity in pixels/second
-}
velocity : Int -> Time.Posix -> Animator.Timeline event -> (event -> Animator.Movement) -> Float
velocity resolution time timeline toPosition =
    let
        before =
            mapTime (\t -> t - resolution) time

        after =
            mapTime (\t -> t + resolution) time

        zero =
            Animator.move (Timeline.atTime before timeline) toPosition

        one =
            Animator.move (Timeline.atTime time timeline) toPosition

        two =
            Animator.move (Timeline.atTime after timeline) toPosition

        first =
            (one.position - zero.position) / toFloat resolution

        second =
            (two.position - one.position) / toFloat resolution

        expected =
            -- 1000 * avg first second
            1000 * (two.position - zero.position) / (2 * toFloat resolution)
    in
    expected
