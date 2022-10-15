#macro ds_grid_create      __MemTrackGridCreate
#macro __ds_grid_create__  ds_grid_create

function __MemTrackGridCreate(_width, _height)
{
    var _grid = __ds_grid_create__(_width, _height);
    
    if (MEMTRACK_ENABLED)
    {
        __MemTrackInitialize();
        global.__memTrackGrids[? _grid] = __MemTrackDataCreate(_grid, debug_get_callstack());
        if (MEMTRACK_VERBOSE) __TrackingTrace("MemTrack: Created grid ", _grid, " as ", _width, "x", _height, "          ", debug_get_callstack());
    }
    
    return _grid;
}
#macro ds_grid_destroy      __MemTrackGridDestroy
#macro __ds_grid_destroy__  ds_grid_destroy

function __MemTrackGridDestroy(_grid)
{
    if (MEMTRACK_ENABLED)
    {
        __MemTrackInitialize();
        ds_map_delete(global.__memTrackGrids, _grid);
        if (MEMTRACK_VERBOSE) __TrackingTrace("MemTrack: Destroyed grid ", _grid, " (", ds_grid_width(_grid), "x", ds_grid_height(_grid), ")          ", debug_get_callstack());
    }
    
    return __ds_grid_destroy__(_grid);
}

function __MemTrackGridExists(_grid)
{
    return ds_exists(_grid, ds_type_grid);
}
