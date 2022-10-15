#macro ds_map_create      __MemTrackMapCreate
#macro __ds_map_create__  ds_map_create

function __MemTrackMapCreate()
{
    var _map = __ds_map_create__();
    
    if (MEMTRACK_ENABLED)
    {
        __MemTrackInitialize();
        global.__memTrackMaps[? _map] = __MemTrackDataCreate(_map, debug_get_callstack());
        if (MEMTRACK_VERBOSE) __MemTrackTrace("Created map ", _map, "          ", debug_get_callstack());
    }
    
    return _map;
}

#macro ds_map_destroy      __MemTrackMapDestroy
#macro __ds_map_destroy__  ds_map_destroy

function __MemTrackMapDestroy(_map)
{
    if (MEMTRACK_ENABLED)
    {
        __MemTrackInitialize();
        __MemTrackRecursiveMapDestroy(_map, debug_get_callstack());
    }
    
    return __ds_map_destroy__(_map);
}

function __MemTrackMapExists(_map)
{
    return ds_exists(_map, ds_type_map);
}
