function MemTrackReport()
{
    if (!MEMTRACK_ENABLED) return "<MEMTRACK_ENABLED = false>";
    
    var _string = "";
    
    var _i = 0;
    repeat(array_length(global.__memTrackData))
    {
        var _dataStruct = global.__memTrackData[_i];
        var _dataMap        = _dataStruct.__map;
        var _existsFunction = _dataStruct.__exists;
        
        _string += "\n";
        _string += string(_dataStruct.__name) + " has " + string(ds_map_size(_dataMap)) + " entries\n";
        
        var _keyArray  = ds_map_keys_to_array(_dataMap);
        var _dataArray = ds_map_values_to_array(_dataMap);
        
        if (is_array(_dataArray))
        {
            try
            {
                array_sort(_dataArray, __MemTrackDataSort);
            }
            catch(_error)
            {
                show_debug_message("MemTrack: There was an error sorting data");
            }
            
            var _j = 0;
            repeat(array_length(_dataArray))
            {
                var _assetIndex = _keyArray[_j];
                
                _string += __MemTrackDataPresentation(_dataArray[_j]) + "\n";
                
                if ((_existsFunction != undefined) && !_existsFunction(_assetIndex))
                {
                    ds_map_delete(global.__memTrackSurfaces, _assetIndex);
                    _string += "Warning! Asset index " + string(_assetIndex) + " has disappeared\n";
                }
                
                ++_j;
            }
        }
        
        _string += "\n";
        
        ++_i;
    }
    
    return _string;
}