export def prompt [dir?: path] {
  if (which gstat | is-empty) {
    return ""
  }

  let gstat = if ($dir | is-not-empty) { gstat $dir } else { gstat }
  let branch = if $gstat.branch != "no_branch" { "󰘬 " + $gstat.branch }

  let untracked = if $gstat.wt_untracked > 0 { "?" }
  let modified = if $gstat.wt_modified > 0 { "!" }
  let deleted = if $gstat.wt_deleted > 0 { "✘" }
  let stash = if $gstat.stashes > 0 { "$" }
  let staged = if $gstat.idx_added_staged > 0 or $gstat.idx_modified_staged > 0 or $gstat.idx_deleted_staged > 0 { "+" }
  let renamed = if $gstat.idx_renamed > 0 { "»" }
  let ahead = if $gstat.ahead > 0 { "⇡" }
  let behind = if $gstat.behind > 0 { "⇣" }
  let conflicts = if $gstat.conflicts > 0 { "=" }

  let stat_symbols = [$untracked, $modified, $deleted, $stash, $staged, $renamed, $ahead, $behind, $conflicts] | str join
  let git_status = if $stat_symbols != "" { $stat_symbols }

  [$branch, $git_status] | str join ' '
}
