$zone_whitelist = .\zone_whitelist.ps1

$source_dir = $args[0]
$zones_p = $source_dir + '\metadata\zones\'
$out_path = "..\minimaps\ffxidb\"
$marker_blacklist = 'pop','harvesting','logging','mining','lost_article','chest','coffer','zone','voidwatch_rift','unity_junction','questionmarks','seed_fragment','seed_afterglow'
$final_size = 2048
$rescale_markers = 1
$rescale_map = 1

$composite_keys = "ffxidb", "w2048", "wiki"

$zone_info = @{}
(((Get-Content ".\zones.json" | Out-String) -replace '(?m)(?<=^([^"]|"[^"]*")*)//.*' -replace '(?ms)/\*.*?\*/') | ConvertFrom-Json).psobject.properties | ForEach-Object { $zone_info[$_.Name] = $_.Value }

Function get_map_name {
  param($zone_id, $map_index, $map_id, $n_maps, $zone, $map)
  
  if ($null -eq $zone_id) {
    return $null
  }
  $zone_number = [convert]::ToInt32($zone_id, 10)
  $zone_name = "{0}" -f $zone_number
  if ($n_maps -eq 1) {
    return $zone_name + "_0.png"
  } elseif (-not($null -eq $map_id)) {
    return $zone_name + "_$map_id.png"
  } else {
    return $null
  }
}

$zones_p = $source_dir + '\metadata\zones\'

if ($args[1]) {
  $zone_id = $args[1]
  $single_zone = $zones_p + $zone_id + ".json"
  $zones = @($single_zone)
}
else {
  $zones = get-ChildItem -Path $zones_p
}

.\composite_zones.ps1