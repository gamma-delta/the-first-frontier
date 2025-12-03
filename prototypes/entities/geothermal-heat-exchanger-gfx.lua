local ACROSS = 10
local DOWN = 8

local SHEET_WIDTH = 5900
local SHEET_HEIGHT = 5120

local PATH = Asset"graphics/entities/geothermal-heat-exchanger/"

local width = SHEET_WIDTH / ACROSS
local height = SHEET_HEIGHT / DOWN

local SPEED = 0.2

local shift = util.by_pixel(-6, -16)

-- type Animation
local base_anim = {
  filename = PATH .. "animation.png",
  width = width, height = height,
  frame_count = ACROSS * DOWN,
  line_length = ACROSS,
  animation_speed = SPEED,
  scale = 0.5,
  shift = shift,
}

-- Tintable color
local glow_1 = {
  filename = PATH .. "color1.png",
  width = width, height = height,
  frame_count = ACROSS * DOWN,
  line_length = ACROSS,
  draw_as_glow = true,
  animation_speed = SPEED,
  scale = 0.5,
  shift = shift,
}
-- Orange color. Is the same as emission1.png afaict?
local glow_2 = {
  filename = PATH .. "color2.png",
  width = width, height = height,
  frame_count = ACROSS * DOWN,
  line_length = ACROSS,
  -- draw_as_glow = true,
  animation_speed = SPEED,
  scale = 0.5,
  shift = shift,
  -- for some reason this thing has a black background
  blend_mode = "additive",
}
-- Not using the tokamak lightning ring thing
-- fortunately it is on a separate layer
-- also, not using the frozen gfx because you only use this on Vulc
local shadow = {
  filename = PATH .. "hr-shadow.png",
  width = 1200, height = 700,
  -- The shadow image has tons of dead space on the left and right,
  -- and there's no instructions on how to line up the shadow and building.
  shift = util.by_pixel(-2, 0),
  draw_as_shadow = true,
  scale = 0.5,
  repeat_count = ACROSS * DOWN,
  -- must put this because all animations must play at the same speed
  -- and otherwise the fake under entity whizzes around
  animation_speed = SPEED,
}

local heat_pipes = {
  filename = PATH .. "heat-pipes.png",
  width = 620, height = 670,
  scale = 0.5,
  shift = shift,
  repeat_count = ACROSS * DOWN,
}
local heat_pipes_hot = apply_heat_pipe_glow{
  filename = PATH .. "heat-pipes-hot.png",
  width = 620, height = 670,
  scale = 0.5,
  shift = shift,
  repeat_count = ACROSS * DOWN,
}

return {
  normal = {
    layers = {
      shadow,
      base_anim,
      -- heat_pipes,
      glow_2,
      -- heat_pipes_hot
    }
    -- glow_1,
  },
  -- the load-bearing mspaint drawing
  -- apparently this doesn't appear in lava at all,
  -- which is why i couldn't get it to appear
  reflection = {
    pictures = {
      filename = PATH .. "reflection.png",
      priority = "extra-high",
      width = 118,
      height = 128,
      shift = util.by_pixel(0, 70),
      variation_count = 1,
      scale = 2.5,
    },
    rotate = false,
    orientation_to_variation = false,
  },
}
