{
  age = {
    # identityPaths = [ ~/.ssh/id_ed25519 ];
    secrets = {
      nerdPasswordFile.file = ../../secrets/nerd-password.age;
    };
  };
}
