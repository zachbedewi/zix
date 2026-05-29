{
  ...
}:
{
  config.flake.lib = {

    mkBanner =
      { name, shellName }:
      let
        label = "${name} [${shellName}]";
        innerWidth = 35;
      in
      ''
        if [ -z "''${NO_COLOR:-}" ]; then
          _zb='\033[0;34m'
          _zr='\033[0m'
        else
          _zb=""
          _zr=""
        fi

        _zl="${label}"
        _zw=${toString innerWidth}

        _zp1=$(( _zw - ''${#_zl} - 2 ))
        _zt1=$(printf '%*s' "$_zp1" "" | tr ' ' '─')
        _zb2=$(printf '%*s' "$(( _zw ))" "" | tr ' ' '─')

        printf "\n"
        printf " ''${_zb}╭─ %s %s─╮''${_zr}\n" "$_zl" "$_zt1"
        printf " ''${_zb}╰─%s─╯''${_zr}\n" "$_zb2"
        printf "\n"

        unset _zb _zr _zl _zw _zp1 _zt1 _zb2
      '';

  };
}
