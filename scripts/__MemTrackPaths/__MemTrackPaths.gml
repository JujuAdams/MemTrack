#macro path_add      __MemTrackPathAdd
#macro __path_add__  path_add

function __MemTrackPathAdd()
{
    var _path = __path_add__();
    
    if (MEMTRACK_ENABLED)
    {
        __MemTrackInitialize();
        global.__memTrackPaths[? _path] = __MemTrackDataCreate(_path, debug_get_callstack());
        if (MEMTRACK_VERBOSE) __MemTrackTrace("Created path ", _path, "          ", debug_get_callstack());
    }
    
    return _path;
}

#macro path_delete      __MemTrackPathDestroy
#macro __path_delete__  path_delete

function __MemTrackPathDestroy(_path)
{
    if (MEMTRACK_ENABLED)
    {
        __MemTrackInitialize();
        ds_map_delete(global.__memTrackPaths, _path);
        if (MEMTRACK_VERBOSE) __MemTrackTrace("Destroyed path ", _path, "          ", debug_get_callstack());
    }
    
    return __path_delete__(_path);
}

function __MemTrackPathExists(_path)
{
    return path_exists(_path);
}