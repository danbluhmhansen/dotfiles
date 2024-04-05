def --env fuzzy-pass [] {
  ls ($env.PASSWORD_STORE_DIR | path join **/* | into glob) |
    where type == file |
    get name |
    each {|p| $p | str substring (($env.PASSWORD_STORE_DIR | str length) + 1)..-4 } |
    to text |
    fuzzel --dmenu --prompt=" " |
    prs copy $in
}
