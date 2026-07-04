{
  flake.nixosModules."amd-gpu" = {
    services.xserver.videoDrivers = [ "amdgpu" ];
  };
}
