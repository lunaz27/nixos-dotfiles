# configuration.nix
{
  networking.nat = {
    enable = true;
    # Use "ve-*" when using nftables instead of iptables
    internalInterfaces = [ "ve-+" ];
    externalInterface = "ens3";
    # Lazy IPv6 connectivity for the container
    enableIPv6 = true;
  };

  containers.webserver = {
    autoStart = true;
    privateNetwork = true;
    hostAddress = "192.168.100.10";
    localAddress = "192.168.100.11";
    hostAddress6 = "fc00::1";
    localAddress6 = "fc00::2";
    config =
      { lib, ... }:

      {
        services.httpd = {
          enable = true;
          adminAddr = "admin@example.org";
        };

        networking = {
          firewall.allowedTCPPorts = [ 80 ];

          # Use systemd-resolved inside the container
          useHostResolvConf = lib.mkForce false;
        };

        services.resolved.enable = true;

        system.stateVersion = "25.11";
      };
  };
}
