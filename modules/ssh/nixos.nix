{
  flake.modules.nixos.ssh =
    { config, lib, ... }:
    lib.mkMerge [
      {
        users.groups.sshusers = { };

        services.openssh = {
          enable = true;
          openFirewall = true;
          startWhenNeeded = true;

          hostKeys = lib.mkDefault [
            {
              path = "/etc/ssh/ssh_host_ed25519_key";
              type = "ed25519";
            }
          ];

          # https://github.com/imthenachoman/How-To-Secure-A-Linux-Server#the-ssh-server
          settings = {
            PasswordAuthentication = false;
            PermitRootLogin = "no";
            PermitEmptyPasswords = false;
            HostbasedAuthentication = false;

            AllowGroups = [ "sshusers" ];

            LogLevel = "VERBOSE";
            UseDns = true;

            MaxAuthTries = 2;
            MaxSessions = 2;
            MaxStartups = "10:30:60";
            LoginGraceTime = 30;
            ClientAliveInterval = 15;
            ClientAliveCountMax = 3;

            AllowTcpForwarding = false;
            AllowStreamLocalForwarding = false;
            GatewayPorts = "no";
            PermitTunnel = false;
            X11Forwarding = false;
            PermitUserEnvironment = false;

            RequiredRSASize = 3072;

            KexAlgorithms = [
              "curve25519-sha256@libssh.org"
              "ecdh-sha2-nistp521"
              "ecdh-sha2-nistp384"
              "ecdh-sha2-nistp256"
              "diffie-hellman-group-exchange-sha256"
            ];
            Ciphers = [
              "chacha20-poly1305@openssh.com"
              "aes256-gcm@openssh.com"
              "aes128-gcm@openssh.com"
              "aes256-ctr"
              "aes192-ctr"
              "aes128-ctr"
            ];
            Macs = [
              "hmac-sha2-512-etm@openssh.com"
              "hmac-sha2-256-etm@openssh.com"
              "hmac-sha2-512"
              "hmac-sha2-256"
              "umac-128@openssh.com"
            ];

            Subsystem = "sftp internal-sftp -f AUTHPRIV -l INFO";
          };
        };
      }

      (lib.mkIf config.zix.impermanence.enable { environment.persistence."/persist".files = [ "/etc/ssh/ssh_host_ed25519_key" ]; })
    ];
}
