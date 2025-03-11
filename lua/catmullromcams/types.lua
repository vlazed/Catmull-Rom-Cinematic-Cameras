---@meta
---This file stores the type definitions for Catmull Rom Cineamtic Cameras

---@class CRCPlayer: Player
---@field CatmullRomCamsTrackZoom number

---@alias PlayerId string
---@alias CRCTrackKey integer

---@alias CRCTrack {[CRCTrackKey]: CatmullRomCamera[]}
---@alias CRCTracks {[PlayerId]: CRCTrack}