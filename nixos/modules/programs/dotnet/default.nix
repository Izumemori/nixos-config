 _: {
  pkgs,
  lib,
  config,
  ...
} : let 
  cfg = config.programs.dotnet;
  buildDotnet = attrs: pkgs.dotnetCorePackages.callPackage (import ./nixpkgs/dotnet/build-dotnet.nix attrs) { };
  packages = { fetchNuGet }: [
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-arm"; version = "9.0.0-preview.7.24406.2"; sha256 = "1f48vfy1r5c40swlf44ippd2zhpy7mgpk08yisvn62yslf9wqqin"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-arm64"; version = "9.0.0-preview.7.24406.2"; sha256 = "1ay99zj073hj5wcy7igzmr6mi106rscqhbqp3d9agx61j899ysnd"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm64"; version = "9.0.0-preview.7.24406.2"; sha256 = "04pmm083fnq3yzxr5fm9ygfvfvqvvhdlr00rcgmd73223bs4xr8d"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-x64"; version = "9.0.0-preview.7.24406.2"; sha256 = "023m314504r08b0bqc7amzksmh0abk42mwvlzaxfv3qk85zs7cw6"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-x64"; version = "9.0.0-preview.7.24406.2"; sha256 = "0caqwqr8drbpvmmkgb6k57qgh9wyn38nxdqz8a0skcgahy6pq9m2"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.osx-x64"; version = "9.0.0-preview.7.24406.2"; sha256 = "1v556hjhar64vz133q2lqw62b1jdn9iiicdqsvgqk0r5jqm8jdr4"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-arm64"; version = "9.0.0-preview.7.24406.2"; sha256 = "10hdf27nchw6hard88wxq4hngnix4iwqnxi38lpiykgh0vlh49nh"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-x64"; version = "9.0.0-preview.7.24406.2"; sha256 = "0phwx3chh6sikq1sms9dwrf256g8n635cjvizp7q2xw7l6b0p340"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-x86"; version = "9.0.0-preview.7.24406.2"; sha256 = "069n01fvpq82hyfz9wrr5cv0l35ngs1dayh25nzq5irk8qhjiqjc"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Ref"; version = "9.0.0-preview.7.24406.2"; sha256 = "00k2kdk94x36lwhi2i3pvxzg5ry6xi3z5b3bs49b79hfj1vggf9g"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm"; version = "9.0.0-preview.7.24406.2"; sha256 = "1nzcjv16pilfvplcqyxnr42vmq70kzaih2756gjkqph6yivqcday"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.osx-arm64"; version = "9.0.0-preview.7.24406.2"; sha256 = "0jhh0bxrh05102c638vpsjn0fm4hjnkkb2l7j7q5f30gim94w6bm"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-arm"; version = "9.0.0-preview.7.24405.7"; sha256 = "0571v4nn1fxx9mvp0qx8h80qblk6v37y4pr17k18kkcn3jvadig7"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-arm64"; version = "9.0.0-preview.7.24405.7"; sha256 = "0i1az3knmh7cn1cz56s0ggplfmaga6a5fki2p1hxalxc6by1f819"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-arm64"; version = "9.0.0-preview.7.24405.7"; sha256 = "07jc58k33wfq9999f0m64k6hccjnri27zpzpwyjdkrwgxxc9rdfg"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-x64"; version = "9.0.0-preview.7.24405.7"; sha256 = "1jgml4ixy6qkjlc4rk5dncjxfranxr0xv8qikwdplllksarn2bvi"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-x64"; version = "9.0.0-preview.7.24405.7"; sha256 = "0mxjv98kxjamrl8y8hl9adskczhwk33l8k36v1lfn4w9lfqxrjmf"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.osx-x64"; version = "9.0.0-preview.7.24405.7"; sha256 = "0kvprnbrymkyp4yg8vrrsackys7fc56ngqbf112mvwi56gacc2cy"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-arm64"; version = "9.0.0-preview.7.24405.7"; sha256 = "1jbc2zxgasdk9vbjh8bb8s4i5kqbgpfklijcqy8ig3af01k8pw67"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-x64"; version = "9.0.0-preview.7.24405.7"; sha256 = "1clzwsm180ki0cr5wp1i958phdarnv69zdqxp1bn2wqgd77rkrw6"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-x86"; version = "9.0.0-preview.7.24405.7"; sha256 = "0dx35jbbdkdbd0377ldgcncwix6857x1kqmn930sj2597z292m0v"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-arm"; version = "9.0.0-preview.7.24405.7"; sha256 = "1wm6vc3k4jkq1vxxvw3wq9k1b84azq8v2zazscpc44vksiisdxc0"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-arm64"; version = "9.0.0-preview.7.24405.7"; sha256 = "18zkm3mqr7464h0qmn5ighjf2gpfrpyg85cmrdr9jqknz1qd08qx"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm64"; version = "9.0.0-preview.7.24405.7"; sha256 = "034ncg45k07v7qfkbw6y8y3n9wzgkhy6gq000if2v71j45kdsa6c"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-x64"; version = "9.0.0-preview.7.24405.7"; sha256 = "07c1wnbki98sl472z32zhgkhdfzvf1qhhhmdfsfk41qxa6yz56xp"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-x64"; version = "9.0.0-preview.7.24405.7"; sha256 = "0pn4nx36w1prkg1kjjlhsx3iyqd19n4wiqzd8ck2k92z3l5397d7"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.osx-x64"; version = "9.0.0-preview.7.24405.7"; sha256 = "0v0sg0sdkjisg7j540bs48ylyaw0yypmnijv4qp4h42hsdgk213w"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-arm64"; version = "9.0.0-preview.7.24405.7"; sha256 = "02hwd80ikxbwikadmiwrybdv5ybp64sbbwkn4kfn7nqvw3q70yh0"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-x64"; version = "9.0.0-preview.7.24405.7"; sha256 = "1j0v5p9w7d9h1cl43ys29qh601zqw4nh5z827xyi0mqn69dz086s"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-x86"; version = "9.0.0-preview.7.24405.7"; sha256 = "1v2xidnjq70ivprdqf365kjdi1wm27dh7jgmlmjwrj65zbkkrp8n"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetAppHost"; version = "9.0.0-preview.7.24405.7"; sha256 = "016snk92jhgdixmv1nms2qqlx5myr1cj8qmxcm8851scv1k1hl7g"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetAppHost"; version = "9.0.0-preview.7.24405.7"; sha256 = "0m4jc8v22byj1r2fn9mh7sv5hn1ygrw8njazfffqcn90pv0gs5xf"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetAppHost"; version = "9.0.0-preview.7.24405.7"; sha256 = "1cp05rqz5bgw0h7vxf1gzwpmjbglrmwx8q9crn8mykvq0lmgwqim"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetAppHost"; version = "9.0.0-preview.7.24405.7"; sha256 = "1wld5vlag0rhi82f2h6hkkx4w5m5wpc5zpn70zyd0k17kg79iaqj"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetAppHost"; version = "9.0.0-preview.7.24405.7"; sha256 = "0n45l47iy12d49igzangz2ljbij52frvsxfniji5lzx40d97jkji"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetAppHost"; version = "9.0.0-preview.7.24405.7"; sha256 = "17g6qsaiazn001y5qhngmii0mfjlh2wj372g8682alxblgbb5zcm"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetAppHost"; version = "9.0.0-preview.7.24405.7"; sha256 = "1pmzakkq1ckhfsqb1a1s10gfj75nfkii2axwhb0rkyh1gm99iib2"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetAppHost"; version = "9.0.0-preview.7.24405.7"; sha256 = "1in2g348vacz1n59h2ivi9b4kh8fqlrbplg4hpajamz9az16dxlp"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetAppHost"; version = "9.0.0-preview.7.24405.7"; sha256 = "0n8w7lq4xd7vj9rvd4nb7c7vzjmzsl6rcad3gmqzrlkf7chp80s8"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetAppHost"; version = "9.0.0-preview.7.24405.7"; sha256 = "0ryyx1g8rb1fr3j3vxwww3fbfi4dpilddaq8nssa7pzcxbd7fwj7"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-arm"; version = "9.0.0-preview.7.24405.7"; sha256 = "1hw84f1n8imsy7xijmblwxpmzig11aphqn74dn7cjggdc6rhbjcw"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.osx-arm64"; version = "9.0.0-preview.7.24405.7"; sha256 = "0ypfvrl9dgsxkk36aixzk8n0kbwa766pihly46aq21rz2dwcnskw"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm"; version = "9.0.0-preview.7.24405.7"; sha256 = "19i9rih610mynm7d5b1kx6vdyynmx3853sz7ky69yg2ppyin4xy5"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.osx-arm64"; version = "9.0.0-preview.7.24405.7"; sha256 = "0gfqkjvalws82474wqd672xxpf0lhwq18vdxjpxm50fj1nl8sa35"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Ref"; version = "9.0.0-preview.7.24405.7"; sha256 = "08w7j5qs6nh7aa2nfslkmj4avbl4aqwh0z0r4qs309rlpa5q4i7l"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-arm"; version = "9.0.0-preview.7.24405.7"; sha256 = "0c1g6sb50gg69fs8jhclal3izkf9xrzhi4bhi0l6w3df1nx0m6mv"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-arm64"; version = "9.0.0-preview.7.24405.7"; sha256 = "1crp6qd0la8qmk1iks3s9n2mhml4474w4pr26ahmpp50j0dxv8cx"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-musl-x64"; version = "9.0.0-preview.7.24405.7"; sha256 = "0cd3838jm19q6izzp7vzi10hjsjsn31l579zz49hnnlpqxssnkd1"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-x64"; version = "9.0.0-preview.7.24405.7"; sha256 = "1xgivx8s3z03mqh6bwi8aapshzf9h7n5108k1adiff4xsvqbz7q7"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.osx-arm64"; version = "9.0.0-preview.7.24405.7"; sha256 = "0fnyk76w1fwwz9iscwqjxigpyslibm56fbxlbffpwmdaibhwrpx3"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.osx-x64"; version = "9.0.0-preview.7.24405.7"; sha256 = "08899x6by57wdgzbxs9sgajvn0cqjs2hqn70y3yisykgf3pis67c"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.win-x64"; version = "9.0.0-preview.7.24405.7"; sha256 = "01aml04jlslzxfmh8zhv1agapwm6cy57mb5v1iaqivrczny0c9kf"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.win-x86"; version = "9.0.0-preview.7.24405.7"; sha256 = "1j2m1hhimd85mm1nxz2qd4vswlxpx37a1kw2haa5w9dmn6wkahr3"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetAppHost"; version = "9.0.0-preview.7.24405.7"; sha256 = "033cjqzpph7rfhf4pv04xla5xbdz84416rdbra9na520apz2lsfx"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetAppHost"; version = "9.0.0-preview.7.24405.7"; sha256 = "1h5cv3vi9mzm41dmncdn9v78n3ihiyyvgsrw974xqspw9j6pmcwh"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm"; version = "9.0.0-preview.7.24405.7"; sha256 = "0x7rady0vb8lazb0kxn2yyp5f4kylg76xb1ha8pmgd0wkc6k00s0"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm64"; version = "9.0.0-preview.7.24405.7"; sha256 = "1apmjwkvdvpfq56wmlm7140ffqjykfwr0vz5c3ji6ps19gw7flp6"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-x64"; version = "9.0.0-preview.7.24405.7"; sha256 = "0anp07fypi7ah4g15p73bw3fmgpnq2cczws9r2s9hshx51kdn5ld"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-arm"; version = "9.0.0-preview.7.24405.7"; sha256 = "1qggl537v0kfd1nv14jbiqks2l7khzm937gc72a1vpcjlvv217xj"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-arm64"; version = "9.0.0-preview.7.24405.7"; sha256 = "06wibvavjggqldaifz26ykj6rk3wigxcm4gc8j75kxh5nd20ymra"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-x64"; version = "9.0.0-preview.7.24405.7"; sha256 = "0p3aff8018arm0rrkhbdqwbcz6mc70zvld068alr8r3rpaj2xrqk"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.osx-x64"; version = "9.0.0-preview.7.24405.7"; sha256 = "1gyr83lwzb0s327jjk26whcys45gkk7cgk2gc0p1rpaahxpb9ryc"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.osx-arm64"; version = "9.0.0-preview.7.24405.7"; sha256 = "1zwg4q8crmk1ldrdf3n2r3z0jrdgcyfcm9l1wl5x9nkn2f65r334"; })
      (fetchNuGet { pname = "Microsoft.DotNet.ILCompiler"; version = "9.0.0-preview.7.24405.7"; sha256 = "0jq5k1gn9ni5sxcnr3xsr7ns9pyicc529v60nwdfsv4343majshb"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.DotNet.ILCompiler"; version = "9.0.0-preview.7.24405.7"; sha256 = "1zcapqvghq17zb2z1f38p7lblkf34m3nl5jqza0rjppvkqg0wcrr"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.DotNet.ILCompiler"; version = "9.0.0-preview.7.24405.7"; sha256 = "1fwr4lk7a6pwpa6qhy1lnbkn3r81x9rishp43hpdzhra6ks6fma8"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.DotNet.ILCompiler"; version = "9.0.0-preview.7.24405.7"; sha256 = "0rlcmp2h9dxh76a59aq91cxlrz558c04l5xf4yfgg2c5hihqpgbq"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.DotNet.ILCompiler"; version = "9.0.0-preview.7.24405.7"; sha256 = "1rxlkz33095yk593r8mr4cx9883q9pfwj4w36lgim9kkqnv6cmb1"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.DotNet.ILCompiler"; version = "9.0.0-preview.7.24405.7"; sha256 = "0gvcfa2w7zdd35fnkjch9mn0zysz6jjnmmv2ibwng84xjma5104v"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.DotNet.ILCompiler"; version = "9.0.0-preview.7.24405.7"; sha256 = "18k4frx0vwsnm6wypcdiijvaa45gav3cjq8drirb01m5kaghn7ks"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.DotNet.ILCompiler"; version = "9.0.0-preview.7.24405.7"; sha256 = "0s6pq4zbgmzp30zw6ria5zflcz58ix6amm9bhxz73m85hwaiq5nj"; })
      (fetchNuGet { pname = "Microsoft.NET.ILLink.Tasks"; version = "9.0.0-preview.7.24405.7"; sha256 = "0dqslmn9nfrpi821y28cli3n4j2rvn4m9kp78qwpa8a9k3f1x8cb"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.DotNet.ILCompiler"; version = "9.0.0-preview.7.24405.7"; sha256 = "0gwidi14v21fvr15pgjhfy4x5611q32r52cyz1y18wff84vn6888"; })
  ];
in {
  options.programs.dotnet = {
    enable = lib.mkEnableOption "Enable dotnet";
  };

  config = lib.mkIf cfg.enable {
    environment =  let
      dotnet-combined = (with pkgs.dotnetCorePackages; combinePackages [
        # First SDK = Used in main system
        (buildDotnet {
          version = "9.0.100-preview.7.24407.12";
          srcs = {
            x86_64-linux = {
              url = "https://download.visualstudio.microsoft.com/download/pr/84a39cad-2147-4a3e-b8fd-ec6fca0f80dd/d86fc06f750e758770f5a2237e01f5c5/dotnet-sdk-9.0.100-preview.7.24407.12-linux-x64.tar.gz";
              sha512 = "3bc1bddb8bebbfa9e256487871c3984ebe2c9bc77b644dd25e4660f12c76042f500931135a080a97f265bc4c5504433150bde0a3ca19c3f7ad7127835076fc8e";
            };
          };
          inherit packages;
          type = "sdk";
        })
      ]).overrideAttrs (finalAttrs: previousAttrs: {
        # This is needed to install workload in $HOME
        # https://discourse.nixos.org/t/dotnet-maui-workload/20370/2

        postBuild =
              (previousAttrs.postBuild or '''')
              + ''
                for i in $out/sdk/*
                do
                  i=$(basename $i)
                  length=$(printf "%s" "$i" | wc -c)
                  substring=$(printf "%s" "$i" | cut -c 1-$(expr $length - 2))
                  i="$substring""00"
                  mkdir -p $out/metadata/workloads/''${i/-*}
                  touch $out/metadata/workloads/''${i/-*}/userlocal
                done
              '';

      });


    in
    {
      sessionVariables = {
        DOTNET_ROOT = "${dotnet-combined}";
      };

      systemPackages =
        [
          dotnet-combined
        ];
    };
  };
}
 
