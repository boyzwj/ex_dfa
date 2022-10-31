# ExDfa

## sensitive word detection and filter 敏感词检测

## Usage

```elixir

> ExDfa.build_words(["fuckyou","fuckoff","操你妈"])  
:ok
> ExDfa.check("fdsfsdfsfs")
:safe
> ExDfa.check("sdff操操你妈sdf")
{:error, {:unsafe, "操你妈"}
> ExDfa.filter("sdff操操你妈sdf")
"sdff操*sdf"

```

### benchmark VS global match (filter) 过滤

```elixir
Operating System: Linux
CPU Information: 12th Gen Intel(R) Core(TM) i7-12700K
Number of Available Cores: 20
Available memory: 15.47 GB
Elixir 1.13.4
Erlang 25.0

Benchmark suite executing with the following configuration:
warmup: 2 s
time: 5 s
memory time: 0 ns
reduction time: 0 ns
parallel: 1
inputs: none specified
Estimated total run time: 14 s

Benchmarking DFA ...
Benchmarking GLOBAL_MATCH ...

Name                   ips        average  deviation         median         99th %
DFA               262.13 K     0.00381 ms   ±256.62%     0.00331 ms      0.0128 ms
GLOBAL_MATCH        0.92 K        1.09 ms    ±12.89%        1.04 ms        1.58 ms

Comparison: 
DFA               262.13 K
GLOBAL_MATCH        0.92 K - 284.75x slower +1.08 ms
```

### benchmark VS global match (check) 检测

```elixir
Operating System: Linux
CPU Information: 12th Gen Intel(R) Core(TM) i7-12700K
Number of Available Cores: 20
Available memory: 15.47 GB
Elixir 1.13.4
Erlang 25.0

Benchmark suite executing with the following configuration:
warmup: 2 s
time: 5 s
memory time: 0 ns
reduction time: 0 ns
parallel: 1
inputs: none specified
Estimated total run time: 14 s

Benchmarking DFA ...
Benchmarking GLOBAL_MATCH ...

Name                   ips        average  deviation         median         99th %
DFA               367.99 K        2.72 μs   ±354.28%        2.33 μs        5.48 μs
GLOBAL_MATCH       27.94 K       35.79 μs    ±50.73%       34.43 μs       59.47 μs

Comparison: 
DFA               367.99 K
GLOBAL_MATCH       27.94 K - 13.17x slower +33.07 μs
```

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `ex_dfa` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:ex_dfa, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/ex_dfa](https://hexdocs.pm/ex_dfa).
