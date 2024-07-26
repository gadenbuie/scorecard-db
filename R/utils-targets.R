tar_when_file_changes <- function(name, file, command, ...) {
  name_file <- paste0(name, "_files")
  sym_file <- as.symbol(name_file)
  sym_cmd <- substitute(command)

  command_file <- substitute({ f }, list(f = file))
  command_target <- substitute({ f; cmd }, list(f = sym_file, cmd = sym_cmd))

  list(
    tar_target_raw(name_file, command_file, format="file"),
    tar_target_raw(name, command_target, ...)
  )
}