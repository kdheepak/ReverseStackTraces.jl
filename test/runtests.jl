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

ModuleA.func_a(1)
