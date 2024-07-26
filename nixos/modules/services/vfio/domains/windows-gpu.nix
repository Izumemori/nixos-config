{ lib, pkgs, nixvirt, ...}:
{
  name
}:
let
base = nixvirt.lib.domain.templates.windows {
  inherit name;
  uuid = "88c074f9-c9fd-4a6d-9eb4-cd7c94318230";
  memory = { count = 16; unit = "GiB"; };
  nvram_path = /var/lib/libvirt/qemu/nvram/win11_VARS.fd;
  storage_vol = null;
  virtio_video = false;
};

in 
#base //
{
  type = "kvm";
  inherit name;
  uuid = "88c074f9-c9fd-4a6d-9eb4-cd7c94318230";
  memory = { count = 16; unit = "GiB"; };

  metadata = with nixvirt.lib.xml;
  [
    (elem "libosinfo:libosinfo" [ (attr "xmlns:libosinfo" "http://libosinfo.org/xmlns/libvirt/domain/1.0") ]
      [
        (elem "libosinfo:os" [ (attr "id" "http://microsoft.com/win/11") ] [ ])
      ])
  ];
  os =
  {
    type = "hvm";
    arch = "x86_64";
    machine = "q35";
  };

  vcpu = {
    placement = "static";
    count = 12;
  };
  iothreads = {
    count = 1;
  };
  cputune = {
    vcpupin = [
      { vcpu = "0"; cpuset = "1"; }
      { vcpu = "1"; cpuset = "9"; }
      { vcpu = "2"; cpuset = "2"; }
      { vcpu = "3"; cpuset = "10"; }
      { vcpu = "4"; cpuset = "3"; }
      { vcpu = "5"; cpuset = "11"; }
      { vcpu = "6"; cpuset = "4"; }
      { vcpu = "7"; cpuset = "12"; }
      { vcpu = "8"; cpuset = "5"; }
      { vcpu = "9"; cpuset = "13"; }
      { vcpu = "10"; cpuset = "6"; }
      { vcpu = "11"; cpuset = "14"; }
    ];
    emulatorpin.cpuset = [ "2" "8" ];
  };
  features =
  {
    acpi = {};
    apic = {};
    pae = {};
    hyperv = base.features.hyperv //
    {
      avic = { state = true; };
    };
    vmport.state = false;
    #smm.state = true;
  };
  cpu =
  {
    mode = "host-passthrough";
    check = "none";
    migratable = true;
    topology = {
      sockets = 1;
      dies = 1;
      clusters = 1;
      cores = 6;
      threads = 2;
    };
    cache = {
      mode = "passthrough";
    };
    feature = [
      {
        policy = "require";
        name = "topoext";
      }
      {
        policy = "require";
        name = "avic";
      }
    ];
  };
  clock =
  {
    offset = "localtime";
    timer = [
        { name = "rtc"; tickpolicy = "catchup"; }
        { name = "pit"; present = true; tickpolicy = "discard"; }
        { name = "hpet"; present = false; }
        { name = "hypervclock"; present = true; }
    ];
  };
  on_poweroff = "destroy";
  on_reboot = "restart";
  on_crash = "destroy";
  devices = base.devices //
  {
    disk = [];

    # Input
    input = [
      # Mouse
      { type = "evdev"; source = { dev = "/dev/input/by-id/usb-Razer_Razer_DeathAdder_V2_Pro_000000000000-event-mouse"; }; }
      # Keyboard
      { type = "evdev"; source = { dev = "/dev/input/by-id/usb-Massdrop_Inc._CTRL_Keyboard_1551060573-event-kbd"; grabToggle = "ctrl-ctrl"; repeat = true; }; }
      { type = "evdev"; source = { dev = "/dev/input/by-id/usb-Massdrop_Inc._CTRL_Keyboard_1551060573-event-if01"; }; }
      { type = "evdev"; source = { dev = "/dev/input/by-id/usb-Massdrop_Inc._CTRL_Keyboard_1551060573-if02-event-kbd"; grabToggle = "ctrl-ctrl"; repeat = true; }; }
    ];

    # Passthrough
    hostdev = [
      { # 3070
        mode = "subsystem";
        type = "pci";
        managed = true;
        source.address =
        {
          domain = 0;
          bus = 8;
          slot = 0;
          function = 0;
        };
        address = {
          type = "pci";
          domain = 0;
          bus = 5;
          slot = 0;
          function = 0;
        };
      }
      { # 3070 Audio
        mode = "subsystem";
        type = "pci";
        managed = true;
        source.address = {
          domain = 0;
          bus = 8;
          slot = 0;
          function = 1;
        };
        address = {
          type = "pci";
          domain = 0;
          bus = 6;
          slot = 0;
          function = 0;
        };
      }
      { # nvme
        mode = "subsystem";
        type = "pci";
        managed = true;
        source.address = {
          domain = 0;
          bus = 1;
          slot = 0;
          function = 0;
        };
        address = {
          type = "pci";
          domain = 0;
          bus = 4;
          slot = 0;
          function = 0;
        };
        boot.order = 1;
      }
    ];
    tpm = {
      model = "tpm-crb";
      backend = {
        type = "emulator";
        version = "2.0";
      };
    };
    audio = {
      id = 1;
      type = "pipewire";
      #runtimeDir = "/run/user/1000";
      #input.name = "qemuinput";
      #output.name = "qemuoutput";
    };
    sound = {
      model = "ich9";
      #audio.id = 1;
      address = {
        type = "pci";
        domain = 0;
        bus = 0;
        slot = 27;
        function = 0;
      };
    };
    video.model.type = "none";
  };
  qemu-commandline.arg = [
    { value = "-overcommit"; }
    { value = "cpu-pm=on"; }
  ];
}