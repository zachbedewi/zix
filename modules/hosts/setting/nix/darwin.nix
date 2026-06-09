{
  flake.modules.darwin.nix = {
    nix = {
      settings = {
        allowed-users = [
          "root"
          "@admin"
        ];
        trusted-users = [
          "root"
          "@admin"
        ];
      };

      gc = {
        interval = [
          {
            Hour = 3;
            Minute = 0;
            Weekday = 6;
          }
        ];
      };

      optimise = {
        interval = [
          {
            Hour = 4;
            Minute = 0;
          }
        ];
      };
    };
  };
}
