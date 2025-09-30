let
  nerd = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC+3xzNBpTnEVENVWNNXzjIcwrDK6hJdxltFYT4Ancf6";
in
{
  "nerd-password.age".publicKeys = [ nerd ];
}
