{
  description = "A Collection of Personal Nix Flake Templates";

  outputs = { self, ... }: {
    templates = {
      basic = {
        path = ./templates/basic;
        description = "Basic flake template";
      };

      python-uv = {
        path = ./templates/python-uv;
        description = "Python with uv package management";
      };

      defaultTemplate = self.templates.trivial;
    };
  };
}
