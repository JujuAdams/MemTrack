#macro mp_grid_create      __MemTrackMPGridCreate
#macro __mp_grid_create__  mp_grid_create

function __MemTrackMPGridCreate(_left, _top, _hCells, _vCells, _cellW, _cellH)
{
    var _grid = __mp_grid_create__(_left, _top, _hCells, _vCells, _cellW, _cellH);
    
    if (MEMTRACK_ENABLED)
    {
        __MemTrackInitialize();
        global.__memTrackMPGrids[? _grid] = __MemTrackDataCreate(_grid, debug_get_callstack());
        if (MEMTRACK_VERBOSE) __MemTrackTrace("Created mp_grid ", _grid, " (", _left, ",", _top, ",", _hCells, ",", _vCells, ",", _cellW, ",", _cellH, ")          ", debug_get_callstack());
    }
    
    return _grid;
}

#macro mp_grid_destroy      __MemTrackMPGridDestroy
#macro __mp_grid_destroy__  mp_grid_destroy

function __MemTrackMPGridDestroy(_grid)
{
    if (MEMTRACK_ENABLED)
    {
        __MemTrackInitialize();
        ds_map_delete(global.__memTrackMPGrids, _grid);
        if (MEMTRACK_VERBOSE) __MemTrackTrace("Destroyed mp_grid ", _grid, "          ", debug_get_callstack());
    }
    
    return __mp_grid_destroy__(_grid);
}
