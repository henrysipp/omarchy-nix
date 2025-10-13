{
  config,
  pkgs,
  ...
}:
let
  cfg = config.omarchy;
  palette = config.colorScheme.palette;
in
{
  home.file = {
    ".config/btop/themes/${cfg.theme}.theme" = {
      text = ''
        # Main text color
        theme[main_fg]="${palette.base05}"

        # Title color for boxes
        theme[title]="${palette.base05}"

        # Highlight color for keyboard shortcuts
        theme[hi_fg]="${palette.base0D}"

        # Background color of selected item in processes box
        theme[selected_bg]="${palette.base01}"

        # Foreground color of selected item in processes box
        theme[selected_fg]="${palette.base05}"

        # Color of inactive/disabled text
        theme[inactive_fg]="${palette.base04}"

        # Misc colors for processes box including mini cpu graphs, details memory graph and details status text
        theme[proc_misc]="${palette.base0D}"

        # Cpu box outline color
        theme[cpu_box]="${palette.base0B}"

        # Memory/disks box outline color
        theme[mem_box]="${palette.base09}"

        # Net up/down box outline color
        theme[net_box]="${palette.base0E}"

        # Processes box outline color
        theme[proc_box]="${palette.base0C}"

        # Box divider line and small boxes line color
        theme[div_line]="${palette.base04}"

        # Temperature graph colors
        theme[temp_start]="${palette.base0B}"
        theme[temp_mid]="${palette.base0A}"
        theme[temp_end]="${palette.base08}"

        # CPU graph colors
        theme[cpu_start]="${palette.base0B}"
        theme[cpu_mid]="${palette.base0A}"
        theme[cpu_end]="${palette.base08}"

        # Mem/Disk free meter
        theme[free_start]="${palette.base0B}"

        # Mem/Disk cached meter
        theme[cached_start]="${palette.base0A}"

        # Mem/Disk available meter
        theme[available_start]="${palette.base09}"

        # Mem/Disk used meter
        theme[used_start]="${palette.base08}"

        # Download graph colors
        theme[download_start]="${palette.base0E}"
        theme[download_mid]="${palette.base0D}"
        theme[download_end]="${palette.base0C}"

        # Upload graph colors
        theme[upload_start]="${palette.base0E}"
        theme[upload_mid]="${palette.base0D}"
        theme[upload_end]="${palette.base0C}"
      '';
    };
  };

  programs.btop = {
    enable = true;
    settings = {
      color_theme = cfg.theme;
      theme_background = false;
      truecolor = true;
      force_tty = false;
      vim_keys = true;
      rounded_corners = true;
      graph_symbol = "braille";
      graph_symbol_cpu = "default";
      graph_symbol_mem = "default";
      graph_symbol_net = "default";
      graph_symbol_proc = "default";
      shown_boxes = "cpu mem net proc";
      update_ms = 2000;
      proc_sorting = "cpu lazy";
      proc_reversed = false;
      proc_tree = false;
      proc_colors = true;
      proc_gradient = false;
      proc_per_core = false;
      proc_mem_bytes = true;
      proc_cpu_graphs = true;
      proc_info_smaps = false;
      proc_left = false;
      cpu_graph_upper = "total";
      cpu_graph_lower = "total";
      cpu_invert_lower = true;
      cpu_single_graph = false;
      cpu_bottom = false;
      show_uptime = true;
      check_temp = true;
      cpu_sensor = "Auto";
      show_coretemp = true;
      cpu_core_map = "";
      temp_scale = "celsius";
      base_10_sizes = false;
      show_cpu_freq = true;
      clock_format = "%X";
      background_update = true;
      custom_cpu_name = ";
      disks_filter = ";
      mem_graphs = true;
      mem_below_net = false;
      zfs_arc_cached = true;
      show_swap = true;
      swap_disk = true;
      show_disks = true;
      only_physical = true;
      use_fstab = true;
      zfs_hide_datasets = false;
      disk_free_priv = false;
      show_io_stat = true;
      io_mode = false;
      io_graph_combined = false;
      io_graph_speeds = ";
      net_download = 100;
      net_upload = 100;
      net_auto = true;
      net_sync = true;
      net_iface = ";
      show_battery = true;
      selected_battery = "Auto";
      log_level = "WARNING";
    };
  };
}
