# List windows, tabs, and panes
export def list [] {
  wezterm cli list --format json | from json
}

export def explorer [] {
  let pane = wezterm cli get-pane-direction left

  if ($pane | is-empty) {
    wezterm cli split-pane --left --cells 36 -- nu -c broot
    wezterm cli activate-pane-direction left
  } else {
    wezterm cli kill-pane --pane-id $pane
  }
}

export def open [file: string] {
  mut pane = wezterm cli get-pane-direction right
  if ($pane | is-empty) { return }
  $pane = ($pane | into int)
  if ((list | where pane_id == $pane).0 | get title) == 'hx' {
    wezterm cli send-text --pane-id $pane --no-paste $':open ($file)(char crlf)'
    wezterm cli activate-pane-direction right
  } else {
    wezterm cli send-text --pane-id $pane --no-paste $'hx ($file)(char crlf)'
    wezterm cli activate-pane-direction right
  }
}
