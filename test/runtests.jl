# From https://github.com/jkrumbiegel/ClearStacktrace.jl/blob/e6ead002507fdada5ca4b261329454ccae239547/test/runtests.jl
using ReverseStackTraces
using Test

module ModuleC
func_c() = 1 + "1"
end


module ModuleB
import ..ModuleC
func_b(::String, ::Rational) = ModuleC.func_c()
end


module ModuleA
import ..ModuleB
func_a(::Int) = ModuleB.func_b("a", 1 // 3)
end

@testset "ReverseStackTraces.jl" begin
  try
    ModuleA.func_a(1)
  catch e
    st = stacktrace(catch_backtrace())
    Base.show_backtrace(stdout, st)
    Base.showerror(stdout, e)
    println(stdout)
  end
end
