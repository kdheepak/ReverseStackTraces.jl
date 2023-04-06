module ReverseStackTraces
__precompile__(false)

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

  println(io, "\nStacktrace (reverse order):")

  for (i, (frame, n)) in reverse(collect(enumerate(trace)))
    print_stackframe(io, i, frame, n, ndigits_max, Base.STACKTRACE_FIXEDCOLORS, Base.STACKTRACE_MODULECOLORS)
    println(io)
    print_linebreaks && println(io)
  end
end

function print_stackframe(io, i, frame::Base.StackFrame, n::Int, digit_align_width, modulecolordict, modulecolorcycler)
  m = Base.parentmodule(frame)
  if m !== nothing
    while parentmodule(m) !== m
      pm = parentmodule(m)
      pm == Main && break
      m = pm
    end
    if !haskey(modulecolordict, m)
      modulecolordict[m] = popfirst!(modulecolorcycler)
    end
    modulecolor = modulecolordict[m]
  else
    modulecolor = :default
  end
  print_stackframe(io, i, frame, n, digit_align_width, modulecolor)
end

# Print a stack frame where the module color is set manually with `modulecolor`.
function print_stackframe(io, i, frame::Base.StackFrame, n::Int, digit_align_width, modulecolor)
  file, line = string(frame.file), frame.line
  file = Base.fixup_stdlib_path(file)
  Base.stacktrace_expand_basepaths() && (file = something(Base.find_source_file(file), file))
  Base.stacktrace_contract_userdir() && (file = Base.contractuser(file))

  line_content = try
    readlines(expanduser(file))[line]
  catch err
    @error err
    ""
  end

  # Used by the REPL to make it possible to open
  # the location of a stackframe/method in the editor.
  if haskey(io, :last_shown_line_infos)
    push!(io[:last_shown_line_infos], (string(frame.file), frame.line))
  end

  inlined = getfield(frame, :inlined)
  modul = parentmodule(frame)

  # frame number
  print(io, " ", lpad("[" * string(i) * "]", digit_align_width + 2))
  print(io, " ")

  StackTraces.show_spec_linfo(IOContext(io, :backtrace => true), frame)
  if n > 1
    printstyled(io, " (repeats $n times)"; color=:light_black)
  end
  println(io)

  # @
  printstyled(io, " "^(digit_align_width + 2) * "@ ", color=:light_black)

  # module
  if modul !== nothing
    printstyled(io, modul, color=modulecolor)
    print(io, " ")
  end

  # filepath
  pathparts = splitpath(file)
  folderparts = pathparts[1:end-1]
  if !isempty(folderparts)
    printstyled(io, joinpath(folderparts...) * (Sys.iswindows() ? "\\" : "/"), color=:light_black)
  end

  # filename, separator, line
  # use escape codes for formatting, printstyled can't do underlined and color
  # codes are bright black (90) and underlined (4)
  printstyled(io, pathparts[end], ":", line; color=:light_black, underline=true)

  # inlined
  printstyled(io, inlined ? " [inlined]" : "", color=:light_black)

  println(io)
  println(io)
  println(io, " ", lpad("", digit_align_width + 2) * "|")
  print(io, " ", lpad(string(line), digit_align_width + 2) * "|")
  printstyled(io, "    ", line_content, color=:black)
  println(io)
  println(io, " ", lpad("", digit_align_width + 2) * "|")
end

end
