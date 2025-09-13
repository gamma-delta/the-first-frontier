require "prototypes/random-things"
require "prototypes/entities/squibs"

require "prototypes/planets"

require "prototypes/items"
require "prototypes/entities/machines"
require "prototypes/entities/rockets"
require "prototypes/fluids"
require "prototypes/recipes"
require "prototypes/entities/resources"
require "prototypes/entities/logistics"
require "prototypes/entities/nauvis"
require "prototypes/entities/vulcanus"
require "prototypes/entities/fulgora"
require "prototypes/entities/gleba"
require "prototypes/entities/enemies/sapper"
require "prototypes/entities/platforms"
require "prototypes/tiles"

require "prototypes/combat"

require "prototypes/technologies"
require "prototypes/entities/misc"

require "prototypes/dust-pollution"

require "prototypes/tips-and-tricks"

-- must do these here because otherwise quality can't make the recycling
-- recipes correctly
require "data-updates-at-home/vanilla"

-- jansharp, you are the BEST
local qai = require "__quick-adjustable-inserters__/data_api"
qai.exclude("")
qai.include(qai.to_plain_pattern("tentacle-inserter"))
