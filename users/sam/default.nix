{ 
  inputs',
  self',
  self,
  config,
  lib,
  ...
} : {
  users.users.sam = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
    ];
    openssh.authorizedKeys.keys = [ 
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC+eLx0zFwIEHVso57SwBXr5TmpM8kVQbb7FpMgpNWqpYKC92pzHeM+FFYAPy399arb+H0QIFDBXBX87CdTyOA3yZP0eEAtWNGFifWPIlpQj9gjdszdABc8qkREyTtYobBlT6uV4yICQw7IywALZIgq3M+qr5EDsUiDuWMAg/2GeA+sxmg+VaszqauS4LEhE1YK56oFq9IXB9UkohobVh0WjHbFz7iH6ER+CrntSkfnYlj+E5hg+bvNNXGvsvtAFWyQcy5B1iUoZkv7FFA/2L91mpoT2WiFsRpmEoH8NDmCrF5C8D4Gy6CfGUGNtWoKtXLhDlQECb4aZ6IbXoEfKmq416s+1ug7aB6m4K2qHS7OQfye/I8DqvFnvorhnO5fHvG1cIs+GI10AknkJ/UT+IWJjw2Y6j6blqFpEmgWgmjmQL+MRteRdAcOcerLVNTRPG3PENXBkff9FEsqQJdhJExHBr7lriX8jIw5TRJ0Xg305fnoYq3yoih2Ybc0jbescNO/x8tE9JdpVO3ElwG24zWSrXm4GIwMADwU4JH3um0R2NzxVIX6zzwncewIWC8BTD91cWw/fNAmdwSVCXcfIxS3CJ8dyOVNMdvBa9Ct2j+/lDaADM0VJiJM4vjLE4NMp22KHRnvwAa4C+dQx/LBxn8SeazQOzW2wOaR4pyXUogYyQ== cardno:14_236_673"
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDgrjAlpsC1uhLuDHqqaeF+jkpmd01DTpqrdR0FSRxvZu75dRi/KH2brv0+Sgd7tdKyiRjgTwTnDlOna7QXVOa4U6aXXLNZA1DBlhy0FcSZKOc3KXOSkbkaoNSsBPje6/3GZEwpAgBGkzrF+mtSgsCqF+sczHkdf7HdiXrMNGSyhizi+0h3OZVzOvJOt4KxRmzH8UsTyZfut8lXZryj7+OZY0bJ7bKw6idOklzdj2gvNjmInZjfmomgdYdpIlSLFouCfX6ZIUOAEhfySbkmCQRuB+Z9yf9vwKRYUj0SL9115f5UWoPePschcRrvmcolNa9dnqDlWR83MqKm2jKRhYZMIIRyqMAJCFNXEXol6a9+pc59dBGF7v2KyNRVus+X8/PPOG1kJdI6LTSm1446gwmDkKg3WLiUXwyF3Ie8UDkmfawk08KyzuH5NcxNtQ6R0zVHFKh+Um7c1dbYQFv0mXwbfDzNZ6RShRponBfcNIjArzbGQ5WPLsksPQGxTwBkAe5KOr8pRwPhjxcNWfRK/HbONxEdUUovnMcKaIplRe2UuxfpJF6FjRNXh+TY4ReLUT9YvIH7ddV/ijzkEzMyOEZKw/TILenfFjPLiueQfmAuJ1NO631f3t+nKg8qITb1ZDhmVS/RZaFpdBSfavDb9zlNfZ4h4rIduQ/DOr1y4b2+bQ== cardno:23_509_748"
    ];
  };

  nix.settings.trusted-users = [ lib.users.sam._name "@wheel" ];
  home-manager.users.sam = {
    imports = [
      ./sam.nix
    ];
  };
}