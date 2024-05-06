source ~/.config/nushell/scripts/date.nu

# Lists all currently running activities
def --env "bartib current" [] {
  let line = open $env.BARTIB_FILE | lines | last
    | parse --regex '(?<start>^\d{4}-\d{2}-\d{2} \d{2}:\d{2}) \| (?<project>[^|]+) \| (?<description>.+)'
    
  if ($line | is-empty) {
    # TODO: Print 'No Activity is currently running'
    return {}
  }

  $line | update start {|row| $row.start | into datetime } | first | insert duration {|r| (date now) - $r.start }
}

# List recent activities
def --env "bartib list" [
  # TODO: rounding
  --round(-r) :string # Rounds the start and end time to the nearest duration. Durations can be in minutes or hours. E.g. 15m or 4h
] {
  let current = bartib current
  open $env.BARTIB_FILE | lines
    | parse --regex '(?<start>\d{4}-\d{2}-\d{2} \d{2}:\d{2}) - (?<end>\d{4}-\d{2}-\d{2} \d{2}:\d{2}) \| (?<project>[^|]+) \| (?<description>.+)'
    | update start {|row| $row.start | into datetime }
    | update end {|row| $row.end | into datetime }
    | append (bartib current | reject duration?)
    | where start? != null
}

# List all projects
def "bartib projects" [
  --current(-c) # Prints currently running projects only
] {
  if $current {
    ^bartib projects --current | lines | each {|l| $l | str trim --char '"' }
  } else {
    ^bartib projects | lines | each {|l| $l | str trim --char '"' }
  }
}

# Reports duration of tracked activities
def --env "bartib report" [
  date          :datetime # Report activities after this date
  range?        :datetime # Report activities before this date
  --project(-p) :string # Do list activities for this project only
  # TODO: rounding
  --round(-r)   :string # Rounds the start and end time to the nearest duration. Durations can be in minutes or hours. E.g. 15m or 4h
] {
  let now = (date now)
  bartib list
    | where {|e| (date between $e.start $date (if ($range | is-empty) {$now} else {$range})) and (($project | is-empty) or ($e.project == $project))}
    | insert duration {|e| ($e.end? | default $now) - $e.start }
    | select project description duration
    | group-by --to-table project
    | each {|e|
        if ($e | is-empty) { return }
        {
          project: $e.group
          items: (
            $e.items
            | group-by --to-table description
            | each {|d| { description: $d.group duration: ($d.items | get duration | math sum) } }
          )
        }
      }
    | flatten
    | flatten
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

