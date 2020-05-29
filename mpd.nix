{ config, pkgs, lib, ... }:

{
  services.mpd = {
    enable = true;
    musicDirectory = "/data/music";
    network.listenAddress = "any";
    extraConfig = ''
      restore_paused "yes"

      audio_output {
        type            "pulse"
        name            "PulseAudio"
        mixer_type      software
      }

      audio_output {
        type        "httpd"
        name        "HTTP Stream"
        encoder     "flac"
        compression "0"
        port        "60000"
        tags        "yes"
      }
    '';
  };
}
