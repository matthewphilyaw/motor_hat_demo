# MotorHatDemo

### Configuration

please see the notes about configuration [here](https://github.com/matthewphilyaw/motor_hat/blob/252fcbd868406144b654932b75e4a2b8f16748fb/README.md) 

Demo expects motors on :m2, :m3
```elixir
config :motor_hat,
  i2c: I2c,
  boards: [
    [name: :mhat, devname: "i2c-1", address: 0x60, motor_config: {:dc, [:m2, :m3]}]
  ]
```

### How to run

remember to run mix deps.get

from Iex you can run:

```shell
  ~ iex -S mix
Erlang/OTP 18 [erts-7.1] [source] [smp:4:4] [async-threads:10] [hipe] [kernel-poll:false]

Interactive Elixir (1.1.1) - press Ctrl+C to exit (type h() ENTER for help)
iex(1)> MotorHatDemo.demo

22:44:36.981 [debug] m1, m4 going forward min to max

22:44:51.322 [debug] m1, m4 going forward going  max to min

22:45:05.417 [debug] m1, m4 going backward going min to max

22:45:19.755 [debug] m1, m4 going backward going from max to min

22:45:33.851 [debug] m1 forward, m4 backward going from min to max

22:45:48.190 [debug] m1 forward, m4 backward going from max to min

22:46:02.275 [debug] m1 forward min - max, m4 backward max to min seq

22:46:29.667 [debug] m1 forward min - max, m4 backward max to min concurrently

22:46:43.267 [debug] release m1, m4
:ok
iex(2)>
```

you can also run it without a shell:

```shell
  ~ mix run -e MotorHatDemo.demo

22:44:36.981 [debug] m1, m4 going forward min to max

22:44:51.322 [debug] m1, m4 going forward going  max to min

22:45:05.417 [debug] m1, m4 going backward going min to max

22:45:19.755 [debug] m1, m4 going backward going from max to min

22:45:33.851 [debug] m1 forward, m4 backward going from min to max

22:45:48.190 [debug] m1 forward, m4 backward going from max to min

22:46:02.275 [debug] m1 forward min - max, m4 backward max to min seq

22:46:29.667 [debug] m1 forward min - max, m4 backward max to min concurrently

22:46:43.267 [debug] release m1, m4
:ok
```

Please check out lib/motor_hat_demo.ex for the specifics, it's pretty straight forward
