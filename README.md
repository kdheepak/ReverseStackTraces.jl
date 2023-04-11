# ReverseStackTraces.jl

`ReverseStackTraces.jl` is an experimental Julia package that provides a way to display stack traces in reverse order, with the stacktrace ordered bottom to top.
This can be useful in certain debugging scenarios where you have long stacktraces and you want to minimize scrolling.

### Installation

To install the package, open a Julia REPL and run:

```julia
] add ReverseStackTraces.jl
```

### Usage

Once installed, you can enable reverse stack traces by running the following command:

```
using ReverseStackTraces
```

After this command is run, stack traces will be displayed in reverse order by default.

### Example

Here is an example of the default stack trace when running `test/runtests.jl`:

```julia
ERROR: LoadError: MethodError: no method matching +(::Int64, ::String)
Closest candidates are:
  +(::Any, ::Any, ::Any, ::Any...) at operators.jl:591
  +(::T, ::T) where T<:Union{Int128, Int16, Int32, Int64, Int8, UInt128, UInt16, UInt32, UInt64, UInt8} at int.jl:87
  +(::Union{Int16, Int32, Int64, Int8}, ::BigInt) at gmp.jl:537
  ...
Stacktrace:
 [1] func_c()
   @ Main.ModuleC ~/gitrepos/ReverseStackTraces.jl/test/runtests.jl:5
 [2] func_b(#unused#::String, #unused#::Rational{Int64})
   @ Main.ModuleB ~/gitrepos/ReverseStackTraces.jl/test/runtests.jl:11
 [3] func_a(#unused#::Int64)
   @ Main.ModuleA ~/gitrepos/ReverseStackTraces.jl/test/runtests.jl:17
 [4] top-level scope
   @ ~/gitrepos/ReverseStackTraces.jl/test/runtests.jl:20
in expression starting at /Users/USERNAME/gitrepos/ReverseStackTraces.jl/test/runtests.jl:20
```

And here is the same stack trace using the `ReverseStackTraces.jl` package:

```julia
ERROR: LoadError:

Stacktrace (reverse order):
 [4] top-level scope
   @ ~/gitrepos/ReverseStackTraces.jl/test/runtests.jl:20
 [3] func_a(#unused#::Int64)
   @ Main.ModuleA ~/gitrepos/ReverseStackTraces.jl/test/runtests.jl:17
 [2] func_b(#unused#::String, #unused#::Rational{Int64})
   @ Main.ModuleB ~/gitrepos/ReverseStackTraces.jl/test/runtests.jl:11
 [1] func_c()
   @ Main.ModuleC ~/gitrepos/ReverseStackTraces.jl/test/runtests.jl:5

MethodError: no method matching +(::Int64, ::String)
Closest candidates are:
  +(::Any, ::Any, ::Any, ::Any...) at operators.jl:591
  +(::T, ::T) where T<:Union{Int128, Int16, Int32, Int64, Int8, UInt128, UInt16, UInt32, UInt64, UInt8} at int.jl:87
  +(::Union{Int16, Int32, Int64, Int8}, ::BigInt) at gmp.jl:537
  ...
in expression starting at /Users/USERNAME/gitrepos/ReverseStackTraces.jl/test/runtests.jl:20
```

### Contributing

Contributions to `ReverseStackTraces.jl` are welcome! To get started, please open an issue or pull request on the GitHub repository.

### Related

- https://github.com/BioTurboNick/AbbreviatedStackTraces.jl
- https://github.com/jkrumbiegel/ClearStacktrace.jl
- https://github.com/Cvikli/RelevanceStacktrace.jl
