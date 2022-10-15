#macro surface_create      __MemTrackSurfaceCreate
#macro __surface_create__  surface_create

function __MemTrackSurfaceCreate(_width, _height)
{
    var _surface = __surface_create__(_width, _height);
    
    if (MEMTRACK_ENABLED)
    {
        __MemTrackInitialize();
        global.__memTrackSurfaces[? _surface] = __MemTrackDataCreate(_surface, debug_get_callstack());
        if (MEMTRACK_VERBOSE) __TrackingTrace("MemTrack: Created surface ", _surface, " as ", _width, "x", _height, "          ", debug_get_callstack());
    }
    
    return _surface;
}

#macro surface_free        __MemTrackSurfaceFree
#macro __surface_free__    surface_free

function __MemTrackSurfaceFree(_surface)
{
    if (MEMTRACK_ENABLED)
    {
        __MemTrackInitialize();
        ds_map_delete(global.__memTrackSurfaces, _surface);
        if (MEMTRACK_VERBOSE) __TrackingTrace("MemTrack: Freed surface ", _surface, " (", surface_get_width(_surface), "x", surface_get_height(_surface), ")          ", debug_get_callstack());
    }
    
    return __surface_free__(_surface);
}
