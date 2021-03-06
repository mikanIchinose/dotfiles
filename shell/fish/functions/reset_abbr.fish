function reset_abbr
  for abbriviation in (abbr --list)
      abbr -e $abbriviation
  end
end
