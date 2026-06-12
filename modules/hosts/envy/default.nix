{self, inputs, ...}: {
  flake.nixosConfigurations.envy = inputs.nixpkgs.lib.nixosSystem {
    modules = [ 
      self.nixosModules.envyConfiguration
    ];
  };
}