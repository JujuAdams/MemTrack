#macro ds_map_create      __MemTrackMapCreate
#macro __ds_map_create__  ds_map_create

function __MemTrackMapCreate()
{
    var _map = __ds_map_create__();
    
    if (MEMTRACK_ENABLED)
    {
        __MemTrackInitialize();
        global.__memTrackMaps[? _map] = __MemTrackDataCreate(_map, debug_get_callstack());
        if (MEMTRACK_VERBOSE) __TrackingTrace("MemTrack: Created map ", _map, "          ", debug_get_callstack());
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

#macro ds_map_add_map      __MemTrackMapAddMap
#macro __ds_map_add_map__  ds_map_add_map

function __MemTrackMapAddMap(_id, _key, _value)
{
    if (MEMTRACK_ENABLED)
    {
        __MemTrackInitialize();
        ds_map_delete(global.__memTrackMaps, _value);
        if (MEMTRACK_VERBOSE) __TrackingTrace("MemTrack: Map ", _value, " added to map ", _id, " as \"", _key, "\", untracking map          ", debug_get_callstack());
    }
    
    return __ds_map_add_map__(_id, _key, _value)
}

#macro ds_list_mark_as_map     __MemTrackListMarkMap
#macro __ds_list_mark_as_map__ ds_list_mark_as_map

function __MemTrackListMarkMap(_id, _pos)
{
    if (MEMTRACK_ENABLED)
    {
        var _map = _id[| _pos];
        if (_map != undefined)
        {
            __MemTrackInitialize();
            ds_map_delete(global.__memTrackMaps, _map);
            if (MEMTRACK_VERBOSE) __TrackingTrace("MemTrack: Map ", _map, " marked for binding to list ", _id, " (pos=", _pos, "), untracking map          ", debug_get_callstack());
        }
    }
    
    return __ds_list_mark_as_map__(_id, _pos);
}

function __MemTrackMapExists(_map)
{
    return ds_exists(_map, ds_type_map);
}
