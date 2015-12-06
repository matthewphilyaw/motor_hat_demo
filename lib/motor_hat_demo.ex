defmodule MotorHatDemo do
  require Logger
  alias MotorHat.DcMotor
  alias MotorHat.Board

  def run_motors(motors, dir) do
    Enum.each motors, &(DcMotor.run(&1, dir))
  end

  def set_speed(motors, speed \\ 0) do
    Enum.each motors, &(DcMotor.set_speed(&1, speed))
  end

  def set_speed_range(range, motors, delay \\ 0) do
    Enum.each range, fn x ->
      Enum.each motors, &(DcMotor.set_speed(&1, x))
      :timer.sleep delay
    end 
  end

  def demo do
    # Board is configured in the config/config.exs
    # file and sets up two dc motors one on m2, and m3

    # motor_hat app is automatically started and you can
    # just use MotorHat.Board to get the motors from the board
    # by the name provided in the config for that board.
    {:ok, m1} = Board.get_dc_motor :mhat, :m2
    {:ok, m4} = Board.get_dc_motor :mhat, :m3
    motors = [m1, m4]

    # only sets the direction to run, doesn't do anything else
    run_motors motors, :forward

    # now lets slowly speed up, motors can run from 0 to 255
    # and we will sleep for 50ms between each step
    Logger.debug "m1, m4 going forward min to max"
    set_speed_range 0..255, motors, 50

    # put the brakes on
    set_speed motors, 0

    # a moment of pause for the next phase :) haha.
    # yes arguable not needed comment.
    :timer.sleep 250

    # now lets go fast and slow down!

    Logger.debug "m1, m4 going forward going  max to min"
    set_speed_range 255..0, motors, 50 
    set_speed motors, 0

    # reverse

    run_motors motors, :backward

    Logger.debug "m1, m4 going backward going min to max"
    set_speed_range 0..255, motors, 50 
    set_speed motors, 0

    :timer.sleep 250

    Logger.debug "m1, m4 going backward going from max to min"
    set_speed_range 255..0, motors, 50 
    set_speed motors, 0


    # one forward and one back!
    run_motors [m1], :forward
    run_motors [m4], :backward

    Logger.debug "m1 forward, m4 backward going from min to max"
    set_speed_range 0..255, motors, 50 
    set_speed motors, 0

    :timer.sleep 250

    Logger.debug "m1 forward, m4 backward going from max to min"
    set_speed_range 255..0, motors, 50 
    set_speed motors, 0

    # now one forward one back and one speed up to max
    # one slow down to brake

    Logger.debug "m1 forward min - max, m4 backward max to min seq"
    set_speed_range 0..255, [m1], 50
    set_speed_range 255..0, [m4], 50

    set_speed motors, 0

    :timer.sleep 250

    # Anyone care to guess why that didn't happen concurrently :)
    # Lets see if tasks can help us here... 
    # also note that the motors don't turn off till told
    # so the example above did some weird stuff keeping the max
    # motor running

    Logger.debug "m1 forward min - max, m4 backward max to min concurrently"
    m1t = Task.async fn -> set_speed_range 0..255, [m1], 50 end
    m4t = Task.async fn -> set_speed_range 255..0, [m4], 50 end

    Task.await m1t, 1 * 60 * 1000
    Task.await m4t, 1 * 60 * 1000

    set_speed motors, 0
    # that's better :)

    Logger.debug "release m1, m4"
    Board.release_all_motors :mhat
  end
end
