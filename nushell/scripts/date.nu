# Get the current date at midnight
def "date today" [] -> datetime {
  date now | format date %F | into datetime
}

# Get yesterdays date at midnight
def "date yesterday" [] -> datetime {
  (date today) - 1day
}

# Get tomorrows date at midnight
def "date tomorrow" [] -> datetime {
  (date today) + 1day
}

# Check if a date is between to other dates
def "date between" [date: datetime, start: datetime, end: datetime] -> bool {
  $date >= $start and ($date) < $end
}

# Get the current week number
def "week now" [] -> int {
  date now | format date %W
}

# Get the week number of the specified date
def "week date" [date: datetime] -> int {
  $date | format date %W
}

def "week last" [number=1] -> int {
  week date ((date now) - ($'($number)wk' | into duration))
}

def "week next" [number=1] -> int {
  week date ((date now) + ($'($number)wk' | into duration))
}
