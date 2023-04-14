module ReverseStackTraces

function Base.showerror(io::IO, ex, bt; backtrace=true)
  backtrace && Base.show_backtrace(io, bt)
  println(io)
  try
    Base.showerror(io, ex)
  catch
  end
end

function Base.show_full_backtrace(io::IO, trace::Vector; print_linebreaks::Bool)
  num_frames = length(trace)
  ndigits_max = ndigits(num_frames)

  println(io, "\n\nStacktrace (reverse order):")

  for (i, (frame, n)) in reverse(collect(enumerate(trace)))
    Base.print_stackframe(io, i, frame, n, ndigits_max, Base.STACKTRACE_FIXEDCOLORS, Base.STACKTRACE_MODULECOLORS)
    println(io)
    print_linebreaks && println(io)
  end
end

end
