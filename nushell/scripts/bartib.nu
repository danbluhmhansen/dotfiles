# Lists all currently running activities
def --env "bartib current" [] {
  mut current = open $env.BARTIB_FILE | lines | last |
    parse --regex '(?<start>\d{4}-\d{2}-\d{2} \d{2}:\d{2}) \| (?<project>[^|]+) \| (?<description>.+)' |
    update start {|row| $row.start | into datetime } | first

  $current.duration = (date now) - $current.start

  $current
}

# List recent activities
def --env "bartib list" [
  --current_week        # Show activities of the current week
  --last_week           # Show activities of the last week
  --today               # Show activities of the current day
  --yesterday           # Show yesterdays' activities
  --date(-d) :string    # Show activities of a certain date only
  --from :string        # Begin of date range (inclusive)
  --round :string       # Rounds the start and end time to the nearest duration. Durations can be in minutes or hours. E.g. 15m or 4h
  --to :string          # End of date range (inclusive)
] {
  open $env.BARTIB_FILE | lines |
    parse --regex '(?<start>\d{4}-\d{2}-\d{2} \d{2}:\d{2}) - (?<end>\d{4}-\d{2}-\d{2} \d{2}:\d{2}) \| (?<project>[^|]+) \| (?<description>.+)' |
    update start {|row| $row.start | into datetime } |
    update end {|row| $row.end | into datetime } |
    append (bartib current | reject duration)
}

def "nu-complete bartib subcommands" [] {
  [
    "cancel",
    "change",
    "check",
    "continue",
    "current",
    "edit",
    "help",
    "last",
    "list",
    "projects",
    "report",
    "log",
    "sanity",
    "start",
    "stop",
  ]
}

# A simple timetracker
export extern "bartib" [
  --help(-h)    # Prints help information
  --version(-V) # Prints version information 
]

# Cancels all currently running activities
export extern "bartib cancel" [
  --help(-h) # Prints help information
]

# Changes the current activity
export extern "bartib change" [
  --help(-h)                # Prints help information
  --description(-d) :string # The description of the new activity
  --project(-p) :string     # The project to which the new activity belongs
  --time(-t) :string        # The time for changing the activity status (HH:MM)
] 

# Checks file and reports parsing errors
export extern "bartib check" [
  --help(-h) # Prints help information
] 

# Continues a previous activity
export extern "bartib continue" [
  number?: int              # The number of the activity to continue (see subcommand `last`) [default: 0]
  --help(-h)                # Prints help information
  --description(-d) :string # The description of the new activity
  --project(-p) :string     # The project to which the new activity belongs
  --time(-t) :string        # The time for changing the activity status (HH:MM)
] 

# Opens the activity log in an editor
export extern "bartib edit" [
  --help(-h) # Prints help information
  -e :string # The command to start your preferred text editor [env: EDITOR=hx]
] 

# prints this message or the help of the given subcommand(s)
export extern "bartib help" [
  subcommand?: string@"nu-complete bartib subcommands"
  --help(-h) # Prints help information
] 

# Displays the descriptions and projects of recent activities
export extern "bartib last" [
  --help(-h)        # Prints help information
  --number(-n) :int # Maximum number of lines to display [default: 10]
] 

# List recent activities
# export extern "bartib list" [
#   --help(-h)            # Prints help information
#   --current_week        # Show activities of the current week
#   --last_week           # Show activities of the last week
#   --no_grouping         # Do not group activities by date in list
#   --today               # Show activities of the current day
#   --yesterday           # Show yesterdays' activities
#   --date(-d) :string    # Show activities of a certain date only
#   --from :string        # Begin of date range (inclusive)
#   --number(-n) :int     # Maximum number of activities to display
#   --project(-p) :string # Do list activities for this project only
#   --round :string       # Rounds the start and end time to the nearest duration. Durations can be in minutes or hours. E.g. 15m or 4h
#   --to :string          # End of date range (inclusive)
# ] 

# List all projects
export extern "bartib projects" [
  --help(-h)    # Prints help information
  --current(-c) # Prints currently running projects only
] 

# Reports duration of tracked activities
export extern "bartib report" [
  --help(-h) # Prints help information
  --current_week        # Show activities of the current week
  --last_week           # Show activities of the last week
  --today               # Show activities of the current day
  --yesterday           # Show yesterdays' activities
  --date(-d) :string    # Show activities of a certain date only
  --from :string        # Begin of date range (inclusive)
  --project(-p) :string # Do list activities for this project only
  --round :string       # Rounds the start and end time to the nearest duration. Durations can be in minutes or hours. E.g. 15m or 4h
  --to :string          # End of date range (inclusive)
] 

# Checks sanity of bartib log
export extern "bartib sanity" [
  --help(-h) # Prints help information
] 

# Starts a new activity
export extern "bartib start" [
  --help(-h)                # Prints help information
  --description(-d) :string # The description of the new activity
  --project(-p) :string     # The project to which the new activity belongs
  --time(-t) :string        # The time for changing the activity status (HH:MM)
] 

# Stops all currently running activities
export extern "bartib stop" [
  --help(-h)         # Prints help information
  --time(-t) :string # The time for changing the activity status (HH:MM)
] 

